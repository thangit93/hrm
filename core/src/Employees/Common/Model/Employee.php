<?php

namespace Employees\Common\Model;

use Classes\BaseService;
use Classes\CustomFieldManager;
use Classes\FileService;
use Classes\IceResponse;
use Company\Common\Model\CompanyStructure;
use Data\Admin\Import\EmployeeDataImporter;
use Jobs\Common\Model\JobTitle;
use Metadata\Common\Model\Country;
use Model\BaseModel;
use Users\Common\Model\User;

class Employee extends BaseModel
{

    public $oldObj = null;
    public $oldObjOrig = null;
    public $historyUpdateList = array();
    public $historyFieldsToTrack = array(
        "employee_id" => "employee_id",
        "first_name" => "first_name",
        "middle_name" => "middle_name",
        "last_name" => "last_name",
        "nationality" => "nationality_Name",
        "birthday" => "birthday",
        "gender" => "gender",
        "marital_status" => "marital_status",
        "ssn_num" => "ssn_num",
        "overtime_leave_days" => "overtime_leave_days",
        "nic_num" => "nic_num",
        "other_id" => "other_id",
        "employment_status" => "employment_status_Name",
        "job_title" => "job_title_Name",
        "pay_grade" => "pay_grade_Name",
        "work_station_id" => "work_station_id",
        "address1" => "address1",
        "address2" => "address2",
        "city" => "city_Name",
        "country" => "country_Name",
        "province" => "province_Name",
        "postal_code" => "postal_code",
        "home_phone" => "home_phone",
        "mobile_phone" => "mobile_phone",
        "work_phone" => "work_phone",
        "work_email" => "work_email",
        "private_email" => "private_email",
        "joined_date" => "joined_date",
        "confirmation_date" => "confirmation_date",
        "supervisor" => "supervisor_Name",
        "indirect_supervisors" => "indirect_supervisors",
        "department" => "department_Name"
    );

    public function getAdminAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getManagerAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getUserAccess()
    {
        return array("get");
    }

    public function getUserOnlyMeAccess()
    {
        return array("element", "save");
    }

    public function getUserOnlyMeAccessField()
    {
        return "id";
    }

    private function initHistory($obj)
    {

        $oldObjOrig = new Employee();
        $oldObjOrig->Load("id = ?", array($obj->id));
        $this->oldObjOrig = $oldObjOrig;

        $mapping = '{"nationality":["Nationality","id","name"],'
            . '"employment_status":["EmploymentStatus","id","name"],"job_title":["JobTitle","id","name"],'
            . '"pay_grade":["PayGrade","id","name"],"country":["Country","code","name"],'
            . '"province":["Province","id","name"],"department":["CompanyStructure","id","title"],'
            . '"supervisor":["Employee","id","first_name+last_name"]}';

        $this->oldObj = BaseService::getInstance()->getElement('Employee', $obj->id, $mapping, true);
    }

    private function saveHistory($obj)
    {

        $oldObj = $this->oldObj;
        $oldObjOrig = $this->oldObjOrig;

        $mapping = '{"nationality":["Nationality","id","name"],'
            . '"employment_status":["EmploymentStatus","id","name"],"job_title":["JobTitle","id","name"],'
            . '"pay_grade":["PayGrade","id","name"],"country":["Country","code","name"],'
            . '"province":["Province","id","name"],"department":["CompanyStructure","id","title"],'
            . '"supervisor":["Employee","id","first_name+last_name"]}';

        $objEnriched = BaseService::getInstance()->getElement('Employee', $obj->id, $mapping, true);

        foreach ($this->historyFieldsToTrack as $k => $v) {
            if (empty($oldObjOrig->$k) && $obj->$k = '[]') {
                continue;
            }

            if (empty($obj->$k) && $oldObjOrig->$k == '0000-00-00') {
                continue;
            }

            if ($oldObjOrig->$k != $obj->$k) {
                $enrichNewVal = '';
                $enrichOldVal = '';

                if ($k == 'indirect_supervisors') {
                    if (!empty($obj->$k) && $obj->$k != '[]') {
                        $newIndeirectSupervisorIds = json_decode($obj->$k);
                        foreach ($newIndeirectSupervisorIds as $id) {
                            $item = BaseService::getInstance()->getItemFromCache("Employee", $id);
                            if ($enrichNewVal != "") {
                                $enrichNewVal .= ", ";
                            }
                            $enrichNewVal .= $item->first_name . " " . $item->last_name;
                        }
                    }

                    if (!empty($oldObjOrig->$k) && $oldObjOrig->$k != '[]') {
                        $oldIndeirectSupervisorIds = json_decode($oldObjOrig->$k);
                        foreach ($oldIndeirectSupervisorIds as $id) {
                            $item = BaseService::getInstance()->getItemFromCache("Employee", $id);
                            if ($enrichOldVal != "") {
                                $enrichOldVal .= ", ";
                            }
                            $enrichOldVal .= $item->first_name . " " . $item->last_name;
                        }
                    }
                } else {
                    $enrichOldVal = $oldObj->$v;
                    $enrichNewVal = $objEnriched->$v;
                }

                $this->historyUpdateList[] = array($obj->id, $k, $enrichOldVal, $enrichNewVal);
            }
        }

        while (count($this->historyUpdateList)) {
            $ele = array_pop($this->historyUpdateList);
            BaseService::getInstance()->addHistoryItem("Employee", "Employee", $ele[0], $ele[1], $ele[2], $ele[3]);
        }
    }

    public function executePreSaveActions($obj)
    {
        if (empty($obj->status)) {
            $obj->status = 'Active';
        }
        $this->setEmployeeId($obj);
        return new IceResponse(IceResponse::SUCCESS, $obj);
    }

    public function executePreUpdateActions($obj)
    {
        $this->initHistory($obj);
        $this->setEmployeeId($obj);
        return new IceResponse(IceResponse::SUCCESS, $obj);
    }

    public function executePostUpdateActions($obj)
    {
        $this->saveHistory($obj);
    }

    public function postProcessGetData($obj)
    {
        $obj = FileService::getInstance()->updateSmallProfileImage($obj);

        $customFieldManager = new CustomFieldManager();
        $customFields = $customFieldManager->getCustomField('Employee', $obj->id, 'full_working_days');
        $customField = array_shift($customFields);

        if (!empty($customField->value) && $customField->value != "NULL") {
            $obj->{$customField->name} = $customField->value;
        }else{
            unset($obj->{$customField->name});
        }

//        var_dump($obj);die;
        return $obj;
    }

    public function getBankAccount($obj)
    {
        $customFieldManager = new CustomFieldManager();
        /** @var array $customFields */
        $customFields = $customFieldManager->getCustomField('Employee', $obj->id, 'bank_account');
        $customField = array_shift($customFields);

        if (!empty($customField->value) && $customField->value != "NULL") {
            $obj->{$customField->name} = $customField->value;
        }

        /** @var array $customFields */
        $customFields = $customFieldManager->getCustomField('Employee', $obj->id, 'bank_name');
        $customField = array_shift($customFields);

        if (!empty($customField->value) && $customField->value != "NULL") {
            $obj->{$customField->name} = $customField->value;
        }

        return $obj;
    }

    public function getIndirectSupervisor($obj)
    {
        $customFieldManager = new CustomFieldManager();
        /** @var array $customFields */
        $customFields = $customFieldManager->getCustomField('Employee', $obj->id, 'indirect-supervisor');
        $customField = array_shift($customFields);

        if (!empty($customField->value) && $customField->value != "NULL") {
            $obj->indirectSupervisor = $customField->value;
        }

        return $obj;
    }

    public function getJobTitle($obj)
    {
        $jobTitleModel = new JobTitle();
        $jobTitles = $jobTitleModel->Find('id = ?', [$obj->job_title]);
        $jobTitle = array_shift($jobTitles);
        $obj->job_title = $jobTitle;

        return $obj;
    }

    public function getVirtualFields()
    {
        return array(
            "image"
        );
    }

    public function getActiveEmployees()
    {
        $employee = new Employee();
        $list = $employee->Find("status = ?", array('Active'));
        return $list;
    }

    public function getActiveSubordinateEmployees()
    {

        $employee = new Employee();
        if (BaseService::getInstance()->currentUser->user_level != 'Admin') {
            $cemp = BaseService::getInstance()->getCurrentProfileId();
            $list = $employee->Find("status = ? and supervisor = ?", array('Active', $cemp));
        } else {
            $list = $employee->Find("status = ?", array('Active'));
        }
        return $list;
    }

    public static function cleanEmployeeData($obj)
    {
        unset($obj->keysToIgnore);
        unset($obj->historyFieldsToTrack);
        unset($obj->historyUpdateList);
        unset($obj->oldObjOrig);
        unset($obj->oldObj);
        return $obj;
    }

    public function fieldValueMethods()
    {
        return ['getActiveSubordinateEmployees'];
    }

    public static function getCurrentEmployeeCompanyStructureCountry()
    {
        $cemp = BaseService::getInstance()->getCurrentProfileId();
        $employee = new Employee();
        $employee->Load('id = ?', [$cemp]);

        $companyStructure = new CompanyStructure();
        $companyStructure->Load('id = ?', [$employee->department]);

        $country = new Country();
        $country->Load('code = ?', [$companyStructure->country]);

        return $country->id;
    }

    public $table = 'Employees';

    public function executePostSaveActions($object)
    {
        $importer = new EmployeeDataImporter();
        $importer->createUser($object->first_name, $object->last_name, $object->birthday, $object);
    }

    public function setEmployeeId(&$employee)
    {
        $birthday = \DateTime::createFromFormat('Y-m-d', $employee->birthday);
        $importer = new EmployeeDataImporter();
        $employee->employee_id = $importer->convert_vi_to_en("{$employee->first_name}{$employee->last_name}{$birthday->format('Y')}");
    }

    public function getCompany($obj)
    {
        $customFieldManager = new CustomFieldManager();
        /** @var array $customFields */
        $customFields = $customFieldManager->getCustomField('Employee', $obj->id, 'company');
        $customField = array_shift($customFields);

        if (!empty($customField->value) && $customField->value != "NULL") {
            return $customField->value;
        }

        return null;
    }
}

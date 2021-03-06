<?php

namespace Data\Admin\Import;

use Classes\BaseService;
use Data\Admin\Api\AbstractDataImporter;
use DateTime;
use Employees\Common\Model\Employee;
use Metadata\Common\Model\CurrencyType;
use Metadata\Common\Model\CustomFieldValue;
use Metadata\Common\Model\Nationality;
use Model\BaseModel;
use Payroll\Common\Model\DeductionGroup;
use Payroll\Common\Model\PayFrequency;
use Salary\Common\Model\PayrollEmployee;
use Users\Common\Model\User;
use Utils\LogManager;

class EmployeeDataImporter extends AbstractDataImporter
{

    protected $processed = array();
    public $jobTitles = [];
    public $supervisors = [];
    public $companies = [];

    public function getModelObject()
    {
        return Employee::class;
    }

    public function getCustomFieldType()
    {
        return 'Employee';
    }

    public function fixBeforeSave($object, $data)
    {
        $fullName = $object->first_name;
        $hash = md5(strtoupper($this->convert_vi_to_en($fullName)));
        list($firstName, $lastName, $middleName) = $this->getFirstNameAndLastName($fullName);
        $object->first_name = $firstName;
        $object->last_name = $lastName;
        $object->middle_name = $middleName;
        $object->custom2 = $object->bank_account;
        $object->nationality = $this->getNationality()->id;
        $object->country = 'VN';
        $birthday = new DateTime();

        if (array_key_exists($hash, $this->supervisors)) {
            $oldObject = $object;
            $oldObject = json_decode(json_encode($oldObject), true);
            $object = $this->supervisors[$hash];
            foreach ($oldObject as $key => $val) {
                if (!empty($val) && empty($object->{$key})) {
                    $object->{$key} = $val;
                }
            }
        }

        if (empty($object->status)) {
            $object->status = "Active";
        }

        $headerMapping = $this->getHeaderMapping();
        foreach ($data as $columnIndex => $value) {
            $value = $this->convertString($value);

            if (empty($value)) {
                continue;
            }

            $column = $headerMapping[$columnIndex];

            if ($column->name == 'job_title') {
                $jobTitleObject = $this->addJobTitle($value);
                $object->job_title = $jobTitleObject->id;
            } elseif ($column->name == 'email' && !empty($value)) {
                $object->work_email = $value;
            } elseif ($column->name == 'supervisor' && !empty($value)) {
                $supervisor = $this->addSupervisor($value);
                $object->supervisor = $supervisor->id;
            } elseif ($column->name == 'company') {
                $department = $this->addCompany('Y Viet');
                $object->department = $department->id;
                $object->custom10 = $value;
            } elseif ($column->name == 'indirect_supervisors') {
                $value = explode('&', $value);
                $indirectSupervisors = [];

                foreach ($value as $name) {
                    $indirectSupervisor = $this->addSupervisor(trim($name));
                    $indirectSupervisors[] = "{$indirectSupervisor->id}";
                }

                $object->indirect_supervisors = "[" . implode(',', $indirectSupervisors) . "]";
            } elseif (in_array($column->name, ['birthday', 'joined_date']) && !empty($value)) {
                $value = DateTime::createFromFormat('Y-m-d H:i:s', $value);
                if ($value) {
                    $object->{$column->name} = $value->format('Y-m-d');

                    if ($column->name == 'birthday') {
                        $birthday = $value;
                    }

                } else {
                    $object->{$column->name} = $value;
                }
            } elseif ($column->name == 'emp_level') {
                $object->custom3 = $value;
            }
        }

        $object->employee_id = $this->convert_vi_to_en("{$firstName}{$lastName}{$birthday->format('Y')}");
        $this->supervisors[$hash] = $object;

        $object->birthday = !empty($object->birthday) ? $object->birthday : null;
        $object->supervisor = !empty($object->supervisor) ? $object->supervisor : null;

        return $object;
    }

    public function fixAfterSave($object)
    {
        if (!empty($object) && !empty($object->first_name) && !empty($object->last_name) && !empty($object->birthday)) {
            $this->createUser($object->first_name, $object->last_name, $object->birthday, $object, $object->work_email);
        }

        if (!empty($object)) {
            $this->addPayrollEmployee($object);

            if ($object->custom3 == 'Gi??m ?????c') {
                $this->setFullWorkingDay($object);
            }
        }
    }

    private function setFullWorkingDay($employee)
    {
        $model = new CustomFieldValue();
        $model->type = 'Employee';
        $model->name = 'full_working_days';
        $model->object_id = $employee->id;
        $model->value = '2020-01-01';
        $model->Save();
    }

    private function addPayrollEmployee($employee)
    {
        $model = new PayrollEmployee();
        $model->employee = $employee->id;
        $model->pay_frequency = $this->getPayFrequency()->id;
        $model->currency = $this->getCurrency()->id;
        $model->deduction_group = $this->getDeductionGroup()->id;
        $model->Save();
    }

    private function getPayFrequency()
    {
        $model = new PayFrequency();
        /** @var array $list */
        $list = $model->Find('name = ?', ['name' => 'Monthly']);

        return array_shift($list);
    }

    private function getCurrency()
    {
        $model = new CurrencyType();
        /** @var array $list */
        $list = $model->Find('code = ?', ['code' => 'VND']);

        return array_shift($list);
    }

    private function getDeductionGroup()
    {
        $model = new DeductionGroup();
        /** @var array $groups */
        $groups = $model->Find('1 = 1', []);

        return array_shift($groups);
    }

    /**
     * @param $value
     * @return BaseModel
     */
    private function addJobTitle($value)
    {
        $code = md5($value);

        if (array_key_exists($code, $this->jobTitles)) {
            return $this->jobTitles[$code];
        }

        $class = BaseService::getInstance()->getFullQualifiedModelClassName('JobTitle');
        /* @var BaseModel $object */
        $object = new $class();
        $object->Load("name = ?", ['name' => $value]);
        $object->code = $code;
        $object->name = $value;
        $object->description = 'Imported from Employee Data Importer';
        $object->Save();

        $this->jobTitles[$code] = $object;

        return $object;
    }

    /**
     * @param $value
     * @return mixed
     */
    private function addSupervisor($value)
    {
        $hash = md5(strtoupper($this->convert_vi_to_en($value)));

        if (array_key_exists($hash, $this->supervisors)) {
            return $this->supervisors[$hash];
        }
        list($firstName, $lastName, $middleName) = $this->getFirstNameAndLastName($value);
        $class = BaseService::getInstance()->getFullQualifiedModelClassName('Employee');
        /** @var BaseModel $class */
        $object = new $class();
        $object->Load("first_name = ? and middle_name = ? and last_name = ?",
            ['first_name' => $firstName, 'middle_name' => $middleName, 'last_name' => $lastName,]);
        $object->first_name = $firstName;
        $object->last_name = $lastName;
        $object->middle_name = $middleName;
        $object->birthday = '2020-02-20';
        $object->joined_date = '2020-02-20';
        $object->status = 'Active';
        $object->Save();

        $this->supervisors[$hash] = $object;

        return $object;
    }

    /**
     * @param $value
     * @return mixed
     */
    private function addCompany($value)
    {
        $class = BaseService::getInstance()->getFullQualifiedModelClassName('CompanyStructure');
        /** @var BaseModel $class */
        $object = new $class();

        $object->Load("title = ?", ['title' => $value]);
        $object->title = $value;
        $object->description = $value;
        $object->type = 'Company';
        $object->country = 'VN';
        $object->timezone = 'Asia/Ho_Chi_Minh';
        $object->Save();

        $this->companies[$value] = $object;

        return $object;
    }

    /**
     * @return BaseModel
     */
    private function getNationality()
    {
        $object = new Nationality();
        $object->Load("name = ?", ['name' => 'Vi???t Nam']);

        return $object;
    }

    private function convertString($value)
    {
        return mb_convert_encoding(trim($value), 'utf-8');
    }

    /**
     * Get first name and last name from full name
     *
     * @param $fullName
     * @return array [$firstName, $lastName]
     */
    private function getFirstNameAndLastName($fullName)
    {
        $fullName = $this->convertString($fullName);
        $fullName = trim($fullName);
        $fullName = explode(' ', $fullName);

        array_filter($fullName, function ($value) {
            return $this->convertString($value);
        });

        $firstName = array_pop($fullName);
        $lastName = array_shift($fullName);

        return [$firstName, $lastName, implode(' ', $fullName)];
    }

    private function getUsername($firstName, $lastName, $yearOfBirth)
    {
        $username = $this->convert_vi_to_en("{$firstName}{$lastName}{$yearOfBirth}");
        $username = strtolower($username);
        return $username;
    }

    private function getEmail($username)
    {
        return "{$username}@example.company";
    }

    private function getPassword(DateTime $birthday)
    {
        return $birthday->format('dmY');
    }

    private function getBirthDay($birthday)
    {
        $birthday = DateTime::createFromFormat('Y-m-d', $birthday);

        return $birthday;
    }

    public function createUser($firstName, $lastName, $birthday, $employee, $email = null)
    {
        $birthday = $this->getBirthDay($birthday);
        $username = $this->getUsername($firstName, $lastName, $birthday->format('Y'));
        $email = empty($email) ? $this->getEmail($username) : $email;
        $password = $this->getPassword($birthday);

        $user = new User();
        $user->email = $email;
        $user->username = $username;
        $user->password = md5($password);
        $user->employee = $employee->id;
        $user->user_level = 'Employee';
        $user->last_login = date("Y-m-d H:i:s");
        $user->last_update = date("Y-m-d H:i:s");
        $user->created = date("Y-m-d H:i:s");

        return $user->Save();
    }

    public function convert_vi_to_en($str)
    {
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???)/", "a", $str);
        $str = preg_replace("/(??|??|???|???|???|??|???|???|???|???|???)/", "e", $str);
        $str = preg_replace("/(??|??|???|???|??)/", "i", $str);
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???)/", "o", $str);
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???)/", "u", $str);
        $str = preg_replace("/(???|??|???|???|???)/", "y", $str);
        $str = preg_replace("/(??)/", "d", $str);
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???)/", "A", $str);
        $str = preg_replace("/(??|??|???|???|???|??|???|???|???|???|???)/", "E", $str);
        $str = preg_replace("/(??|??|???|???|??)/", "I", $str);
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???|??|???|???|???|???|???)/", "O", $str);
        $str = preg_replace("/(??|??|???|???|??|??|???|???|???|???|???)/", "U", $str);
        $str = preg_replace("/(???|??|???|???|???)/", "Y", $str);
        $str = preg_replace("/(??)/", "D", $str);
        //$str = str_replace(" ", "-", str_replace("&*#39;","",$str));
        return $str;
    }
}

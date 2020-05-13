<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 11:11 PM
 */

namespace Salary\Common\Model;

use Classes\CustomFieldManager;
use Classes\IceResponse;
use Model\BaseModel;

class EmployeeSalaryBonus extends BaseModel
{
    public $table = 'EmployeeSalaryBonus';

    public function getAdminAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getManagerAccess()
    {
        return array();
    }

    public function getUserAccess()
    {
        return array();
    }

    public function getUserOnlyMeAccess()
    {
        return array("get", "element");
    }

    public function getUserOnlyMeSwitchedAccess()
    {
        return array();
    }

    public function executePreSaveActions($obj)
    {
        $obj = $this->removeNonNumericCharacters($obj);
        return new IceResponse(IceResponse::SUCCESS, $obj);
    }

    public function executePreUpdateActions($obj)
    {
        $obj = $this->removeNonNumericCharacters($obj);
        return new IceResponse(IceResponse::SUCCESS, $obj);
    }

    /**
     * @param $obj
     * @return mixed
     */
    private function removeNonNumericCharacters($obj)
    {
        $obj->amount = preg_replace('/[\D]/', '', $obj->amount);

        return $obj;
    }

    public function postProcessGetData($obj)
    {
        $customFieldManager = new CustomFieldManager();
        $customFields = $customFieldManager->getCustomField($obj->_table, $obj->id, 'date');

        foreach ($customFields as $customField) {
            if (!empty($customField->value)) {
                if ($customField->value == "NULL") {
                    $obj->{$customField->name} = null;
                }else{
                    $obj->{$customField->name} = $customField->value;
                }
            }
        }

        return $obj;
    }

    public function getVirtualFields()
    {
        return [];
    }

}

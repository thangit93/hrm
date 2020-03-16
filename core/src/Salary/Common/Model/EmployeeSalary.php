<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 11:11 PM
 */

namespace Salary\Common\Model;

use Classes\IceResponse;
use Model\BaseModel;

class EmployeeSalary extends BaseModel
{
    public $table = 'EmployeeSalary';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
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
        return new IceResponse(IceResponse::SUCCESS, $this->removeNonNumericCharacters($obj));
    }

    public function executePreUpdateActions($obj)
    {
        return new IceResponse(IceResponse::SUCCESS, $this->removeNonNumericCharacters($obj));
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
}

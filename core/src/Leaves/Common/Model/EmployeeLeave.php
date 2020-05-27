<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 2:56 PM
 */

namespace Leaves\Common\Model;

use Classes\FileService;
use Employees\Common\Model\Employee;
use Model\BaseModel;

class EmployeeLeave extends BaseModel
{
    public $table = 'EmployeeLeaves';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }

    public function getManagerAccess()
    {
        return array("get","element","save","delete");
    }

    public function getUserAccess()
    {
        return array("get", "delete");
    }

    public function getUserOnlyMeAccess()
    {
        return array("get","element");
    }

    public function postProcessGetData($obj)
    {
        $obj = FileService::getInstance()->updateSmallProfileImage($obj);

        $employee = new Employee();
        $empInfo = $employee->find('id = ?', [$obj->employee]);

        if (!empty($empInfo[0]->supervisor) && $empInfo[0]->supervisor != "NULL") {
            $supervisor = $employee->find('id = ?', [$empInfo[0]->supervisor]);
            $obj->supervisor = $supervisor[0]->first_name . ' ' . $supervisor[0]->last_name;
        }
        return $obj;
    }
}

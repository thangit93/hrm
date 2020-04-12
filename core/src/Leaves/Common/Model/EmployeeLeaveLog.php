<?php


namespace Leaves\Common\Model;


use Model\BaseModel;

class EmployeeLeaveLog extends BaseModel
{
    public $table = 'EmployeeLeaveDays';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}
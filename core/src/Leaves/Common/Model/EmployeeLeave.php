<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 2:56 PM
 */

namespace Leaves\Common\Model;

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
}

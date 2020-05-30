<?php
/**
 * @author Ha Tran <manhhaniit@gmail.com>
 */

namespace Leaves\Common\Model;

use Classes\FileService;
use Model\BaseModel;

class LeaveType extends BaseModel
{
    public $table = 'LeaveTypes';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }

    public function postProcessGetData($obj)
    {
        $obj = FileService::getInstance()->updateSmallProfileImage($obj);
        $obj->name = t($obj->name);
        $obj->default_per_year = (int) $obj->default_per_year;
        return $obj;
    }
}

<?php
/**
 * @author Ha Tran <manhhaniit@gmail.com>
 */

namespace Leaves\Common\Model;

use Model\BaseModel;

class LeaveType extends BaseModel
{
    public $table = 'LeaveTypes';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}

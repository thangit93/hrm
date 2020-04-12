<?php


namespace Model;



class LeaveRule extends BaseModel
{
    public $table = 'LeaveRules';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}
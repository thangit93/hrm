<?php


namespace Model;

class LeavePeriod extends BaseModel
{
    public $table = 'LeavePeriods';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}
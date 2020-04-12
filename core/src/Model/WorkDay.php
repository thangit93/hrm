<?php


namespace Model;


class WorkDay extends BaseModel
{
    public $table = 'WorkDays';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}
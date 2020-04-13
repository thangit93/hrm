<?php


namespace Model;



class HoliDay extends BaseModel
{
    public $table = 'Holidays';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }
}
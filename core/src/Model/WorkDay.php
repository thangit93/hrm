<?php


namespace Model;


use Classes\FileService;

class WorkDay extends BaseModel
{
    public $table = 'WorkDays';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }

    public function postProcessGetData($obj)
    {
        $obj = FileService::getInstance()->updateSmallProfileImage($obj);
        $obj->name = t($obj->name);
        $obj->status = t($obj->status);
        $obj->default_per_year = (int) $obj->default_per_year;
        return $obj;
    }
}
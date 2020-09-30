<?php


namespace Model;



use Classes\FileService;

class HoliDay extends BaseModel
{
    public $table = 'HoliDays';

    public function getAdminAccess()
    {
        return array("get","element","save","delete");
    }

    public function executePreSaveActions($obj)
    {
        $obj = parent::executePreSaveActions($obj);

        $obj->dateh = $obj->date;

        return $obj;
    }

    public function executePreUpdateActions($obj)
    {
        $obj = parent::executePreUpdateActions($obj);

        $obj->dateh = $obj->date;

        return $obj;
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
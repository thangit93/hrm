<?php

namespace Data\Common\Model;

use Model\BaseModel;

class DataImport extends BaseModel
{
    public $table = 'DataImport';

    public function getAdminAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getUserAccess()
    {
        return array("get", "element");
    }

    public function getManagerImporter($getId = false)
    {
        $importers =  [
//            "EmployeeDataImporter",
            "AttendanceDataImporter",
        ];
        $data = $this->Find("dataType IN (?)", implode(',', $importers));

        if (!empty($getId)) {
            $newData = [];

            foreach ($data as $item) {
                $newData[] = $item->id;
            }

            return $newData;
        }

        return $data;
    }
}

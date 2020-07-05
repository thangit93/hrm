<?php

namespace Data\Common\Model;

use Classes\BaseService;
use Classes\IceResponse;
use Model\BaseModel;

class DataImportFile extends BaseModel
{
    public $table = 'DataImportFiles';

    public function getAdminAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getManagerAccess()
    {
        return array("get", "element", "save", "delete");
    }

    public function getUserAccess()
    {
        return array("get", "element");
    }

    public function executePreSaveActions($obj)
    {
        if (empty($obj->status)) {
            $obj->status = "Not Processed";
        }
        return new IceResponse(IceResponse::SUCCESS, $obj);
    }

    public function getCustomFilterQuery($filter)
    {
        $query = "";
        $queryData = [];

        if (BaseService::getInstance()->getCurrentUser()->user_level == 'Manager') {
            $dataImportModel = new DataImport();
            $importers = $dataImportModel->getManagerImporter(true);
            $query = " AND data_import_definition IN (?)";
            $queryData[] = implode(',', $importers);
        }

        return [$query, $queryData];
    }
}

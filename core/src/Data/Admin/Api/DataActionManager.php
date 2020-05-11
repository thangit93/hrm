<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 8:02 AM
 */

namespace Data\Admin\Api;

require dirname(dirname(dirname(dirname(dirname(__FILE__))))) . '/lib/composer/vendor/autoload.php';

use Classes\FileService;
use Classes\IceResponse;
use Classes\SubActionManager;
use Data\Common\Model\DataImport;
use Data\Common\Model\DataImportFile;
use SimpleXLS;
use SimpleXLSX;
use Utils\LogManager;

class DataActionManager extends SubActionManager
{

    public function processDataFile($req)
    {
        $id = $req->id;
        $dataFile = new DataImportFile();
        $dataFile->Load("id = ?", array($id));
        if (empty($dataFile->id)) {
            return new IceResponse(IceResponse::ERROR, null);
        }
        $url = FileService::getInstance()->getFileUrl($dataFile->file);

        if (strstr($url, CLIENT_BASE_URL) !== false) {
            $url = str_replace(CLIENT_BASE_URL, CLIENT_BASE_PATH, $url);
        }

        LogManager::getInstance()->info("File Path:" . $url);
        preg_match('/^.*\.xlsx$/', $url, $xlsxMatches, PREG_OFFSET_CAPTURE);
        preg_match('/^.*\.xls$/', $url, $xlsMatches, PREG_OFFSET_CAPTURE);

        if (count($xlsxMatches) > 0) {
            $data = $this->processXLSXFile($url);
        } elseif (count($xlsMatches) > 0) {
            $data = $this->processXLSFile($url);
        } else {
            $data = file_get_contents($url);
        }

        $dataImport = new DataImport();
        $dataImport->Load("id =?", array($dataFile->data_import_definition));
        if (empty($dataImport->id)) {
            return new IceResponse(IceResponse::ERROR, null);
        }

        $processClass = '\\Data\Admin\Import\\' . $dataImport->dataType;
        $processObj = new $processClass();

        $res = $processObj->process($data, $dataImport->id);
        if ($processObj->getLastStatus() === IceResponse::SUCCESS) {
            $dataFile->status = "Processed";
        }
        $dataFile->details = json_encode($res, JSON_PRETTY_PRINT);
        $dataFile->Save();
        return new IceResponse($processObj->getLastStatus(), $processObj->getResult());
    }

    private function processHeader($dataImportId, $data)
    {
    }

    private function readExcelFile($filePath, $type)
    {
        switch ($type) {
            case 'xlsx':
                return SimpleXLSX::parse($filePath);
                break;
            case 'xls':
                return SimpleXLS::parse($filePath);
                break;
            default:
                return false;
        }
    }

    private function parseExcelToCsv($content)
    {
        if (empty($content)) {
            return "";
        }

        $data = [];

        $rows = $content->rows();

        foreach ($rows as $row) {
            $data[] = implode(',', $row);
        }

        $data = implode("\r\n", $data);

        return $data;
    }

    private function processXLSXFile($filePath)
    {
        $content = $this->readExcelFile($filePath, 'xlsx');
        return $this->parseExcelToCsv($content);
    }

    private function processXLSFile($filePath)
    {
        $content = $this->readExcelFile($filePath, 'xls');
        return $this->parseExcelToCsv($content);
    }
}

<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 3:17 PM
 */

namespace Overtime\Admin\Api;

use Classes\Approval\ApproveAdminActionManager;
use Classes\IceResponse;
use Classes\LanguageManager;
use Employees\Common\Model\Employee;
use Overtime\Common\Model\EmployeeOvertime;
use Overtime\Common\Model\OvertimeCategory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Utils\LogManager;

class OvertimeActionManager extends ApproveAdminActionManager
{

    public function getModelClass()
    {
        return "EmployeeOvertime";
    }

    public function getItemName()
    {
        return "Overtime Request";
    }

    public function getModuleName()
    {
        return "Overtime Management";
    }

    public function getModuleTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabEmployeeOvertime";
    }

    public function getModuleSubordinateTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabSubordinateEmployeeOvertime";
    }

    public function getModuleApprovalTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabEmployeeOvertimeApproval";
    }

    public function getLogs($req)
    {
        return parent::getLogs($req);
    }

    public function changeStatus($req)
    {
        return parent::changeStatus($req);
    }

    public function getReportOvertime($req)
    {
        $filters = $req->ft;
        $mEmployeeOvertime = new EmployeeOvertime();
        if (empty($filters)) {
            $overtimes = $mEmployeeOvertime->Find('status = \'Approved\'');
        } else {
            $overtimes = $mEmployeeOvertime->Find('status = \'Approved\' '
                .'and date_format(start_time, \'%Y-%m\') >= \''.$filters->date_start.'\' and date_format(start_time, \'%Y-%m\') <= \''.$filters->date_start.'\'');
        }
        $responseData = [];
        $mEmployee = new Employee();
//        $mCategory = new OvertimeCategory();
        foreach ($overtimes as $overtime) {
            $employee = $mEmployee->Find('id = ?', [$overtime->employee]);
            $responseData[] = [
                'id' => $overtime->id,
                'startTime' => date('d/m/Y H:i:s', strtotime($overtime->start_time)),
                'endTime' => date('d/m/Y H:i:s', strtotime($overtime->end_time)),
                'name' => $employee[0]->first_name . ' ' . $employee[0]->last_name,
                'totalTime' => $overtime->total_time,
                'notes' => $overtime->notes,
            ];
        }

        if(!empty($req->save) && $req->save != 0){
            try {
                $spreadsheet = new Spreadsheet();
                $sheet = $spreadsheet->getActiveSheet();
                $numOfColumns = 8;
                $alphas = range('A', 'Z');
                $endColumnName = $alphas[$numOfColumns - 1];

                //Set title
                $rowIndex = 1;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Report Overtime") . ' ' . date('d/m/Y'));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                //Set header
                $rowIndex = 3;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("STT"));
                $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Name"));
                $sheet->setCellValueByColumnAndRow(3, $rowIndex, LanguageManager::tran("Start Time"));
                $sheet->setCellValueByColumnAndRow(4, $rowIndex, LanguageManager::tran("End Time"));
                $sheet->setCellValueByColumnAndRow(5, $rowIndex, LanguageManager::tran("Total Time"));
                $sheet->setCellValueByColumnAndRow(6, $rowIndex, LanguageManager::tran("Notes"));

                //Set data
                $rowIndex = 4;
                foreach ($responseData as $rowData) {
                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, $rowData['id']);
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, $rowData['name']);
                    $sheet->setCellValueByColumnAndRow(3, $rowIndex, $rowData['startTime']);
                    $sheet->setCellValueByColumnAndRow(4, $rowIndex, $rowData['endTime']);
                    $sheet->setCellValueByColumnAndRow(5, $rowIndex, $rowData['totalTime']);
                    $sheet->setCellValueByColumnAndRow(6, $rowIndex, $rowData['notes']);

                    $rowIndex++;
                }
            } catch (Exception $e) {
                LogManager::getInstance()->error("Export to EXCEL Error\r\n" . $e->getMessage() . "\r\n" . $e->getTraceAsString());
            }
            $filename = uniqid('report_overtime_');
            $filePath = CLIENT_BASE_PATH . "/data/report_overtime_{$filename}.xlsx";
            $fileUrl = CLIENT_BASE_URL . "/data/report_overtime_{$filename}.xlsx";
            $writer = new Xlsx($spreadsheet);
            $writer->save($filePath);
            $responseData['file'] = [
                'url' => $fileUrl,
                'name' => "{$filename}.xlsx"
            ];
        }

        return new IceResponse(IceResponse::SUCCESS, $responseData);
    }
}

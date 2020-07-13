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
use Leaves\Common\Model\LeaveType;
use Overtime\Common\Model\EmployeeOvertime;
use Overtime\Common\Model\OvertimeCategory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Utils\LogManager;

class OvertimeActionManager extends ApproveAdminActionManager
{
    protected $db;

    public function __construct()
    {
        if ($this->db == null) {
            $this->db = NewADOConnection('mysqli');
            $this->db->Connect(APP_HOST, APP_USERNAME, APP_PASSWORD, APP_DB);
        }
    }

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
                . 'and date_format(start_time, \'%Y-%m\') >= \'' . $filters->date_start . '\' and date_format(start_time, \'%Y-%m\') <= \'' . $filters->date_start . '\'');
        }
        $responseData = [];
        if (empty($req->save)) {
            $mEmployee = new Employee();
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
        }

        if (!empty($req->save) && $req->save != 0) {

            $sql = "select e.id                                   as employee_id,
                           eo.notes                               as location,
                           eo.start_time,
                           eo.end_time,
                           eo.total_time,
                           oc.coefficient,
                           oc.name                                as ot_type,
                           es.amount                              as total_salary,
                           oc.type                                as cat_type,                           
                           concat(e.first_name, ' ', e.last_name) as name
                    from EmployeeOvertime eo
                             join Employees e on eo.employee = e.id
                             join OvertimeCategories oc on eo.category = oc.id
                             join EmployeeSalary es on e.id = es.employee
                    group by eo.id;";
            $result = $this->db->Execute($sql);
            $employee = [];
            while ($r = $result->fetchRow()) {
                unset($r[0]);
                unset($r[1]);
                unset($r[2]);
                unset($r[3]);
                unset($r[4]);
                unset($r[5]);
                unset($r[6]);
                unset($r[7]);
                unset($r[8]);
                $employee[$r['employee_id']][] = $r;
            }

            try {
                $spreadsheet = new Spreadsheet();
                //$sheet = $spreadsheet->getActiveSheet();
                $sheetIdx = 0;

                //Set data
                echo '<pre>';
                print_r($employee);
                echo '<pre>';die;
                foreach ($employee as $data) {
                    if ($sheetIdx > 0) {
                        $spreadsheet->createSheet();
                    }
                    $sheet = $spreadsheet->getSheet($sheetIdx);

                    //Set header
                    $rowIndex = 1;
                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Location"));
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Date Start"));
                    $sheet->setCellValueByColumnAndRow(3, $rowIndex, LanguageManager::tran("Date End"));
                    $sheet->setCellValueByColumnAndRow(4, $rowIndex, LanguageManager::tran("Start Time"));
                    $sheet->setCellValueByColumnAndRow(5, $rowIndex, LanguageManager::tran("End Time"));
                    $sheet->setCellValueByColumnAndRow(6, $rowIndex, LanguageManager::tran("Total Days"));
                    $sheet->setCellValueByColumnAndRow(7, $rowIndex, LanguageManager::tran("Total Hours"));
                    $sheet->setCellValueByColumnAndRow(8, $rowIndex, LanguageManager::tran("Coefficient"));
                    $sheet->setCellValueByColumnAndRow(9, $rowIndex, LanguageManager::tran("Base salary / day"));
                    $sheet->setCellValueByColumnAndRow(10, $rowIndex, LanguageManager::tran("Salary get"));
                    $sheet->setCellValueByColumnAndRow(11, $rowIndex, LanguageManager::tran("Category"));
                    $sheet->setTitle($data[0]['name']);
                    $sheet->getStyle('A1:K1')->getFont()->setBold(true);

                    $rowIndex = 2;
                    foreach ($data as $rowData) {
                        $startDate = new \DateTime(date('Y-m-d H:i:s', strtotime($rowData['start_time'])));
                        $endDate = new \DateTime(date('Y-m-d H:i:s', strtotime($rowData['end_time'])));
                        $totalDays = $startDate->diff($endDate);
                        $days = date('d', strtotime($rowData['start_time']));
                        $daysWorking = 25;

                        if ($days == 31) {
                            $daysWorking = 26;
                        }

                        $pricePerDay = $rowData['total_salary'] / $daysWorking;
                        $pricePerHour = $pricePerDay / 8;
                        $salary = $pricePerHour * $rowData['coefficient'] * $rowData['total_time'];
                        if ($rowData['cat_type'] == 4) {
                            $totalDays = ($totalDays == 0 ? 1 : $totalDays);
                            $salary = $totalDays * 500000;
                        } else if ($rowData['cat_type'] == 5) {
                            $totalDays = ($totalDays == 0 ? 1 : $totalDays);
                            $salary = $totalDays * 120000;
                        }

                        $sheet->setCellValueByColumnAndRow(1, $rowIndex, $rowData['location']);
                        $sheet->setCellValueByColumnAndRow(2, $rowIndex, date('d/m/Y', strtotime($rowData['start_time'])));
                        $sheet->setCellValueByColumnAndRow(3, $rowIndex, date('d/m/Y', strtotime($rowData['end_time'])));
                        $sheet->setCellValueByColumnAndRow(4, $rowIndex, date('H:i', strtotime($rowData['start_time'])));
                        $sheet->setCellValueByColumnAndRow(5, $rowIndex, date('H:i', strtotime($rowData['end_time'])));
                        $sheet->setCellValueByColumnAndRow(6, $rowIndex, $totalDays->days);
                        $sheet->setCellValueByColumnAndRow(7, $rowIndex, $rowData['total_time']);
                        $sheet->setCellValueByColumnAndRow(8, $rowIndex, $rowData['coefficient']);
                        $sheet->setCellValueByColumnAndRow(9, $rowIndex, $pricePerDay);
                        $sheet->setCellValueByColumnAndRow(10, $rowIndex, $salary);
                        $sheet->setCellValueByColumnAndRow(11, $rowIndex, $rowData['ot_type']);

                        $rowIndex++;
                    }
                    $tempIdx = $rowIndex-1;
                    $sheet->setCellValueByColumnAndRow(10, $rowIndex, "=sum(J2:J$tempIdx)");
                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Total"));
                    $sheet->mergeCells("A{$rowIndex}:I{$rowIndex}");
                    $sheet->getStyle("A{$rowIndex}:I{$rowIndex}")->getFont()->setBold(true);
                    $sheet->getStyle("A{$rowIndex}:I{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
                    $sheetIdx++;
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

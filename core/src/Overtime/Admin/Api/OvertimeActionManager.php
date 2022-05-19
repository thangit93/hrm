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
use DateTime;
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
        $currentDate = new \DateTime();
        if (!empty($filters)) {
            $currentDate = \DateTime::createFromFormat('Y-m', "{$filters->date_start}");
        }

        $startDate = (clone $currentDate)->setDate($currentDate->format('Y'), $currentDate->format('m') - 1, 26);
        $endDate = (clone $currentDate)->setDate($currentDate->format('Y'), $currentDate->format('m'), 25);

        $overtimes = $mEmployeeOvertime->Find('status = \'Approved\' and formality = \'Trả lương\' '
            . 'and date_format(start_time, \'%Y-%m-%d\') >= \'' . $startDate->format('Y-m-d') . '\' and date_format(start_time, \'%Y-%m-%d\') <= \'' . $endDate->format('Y-m-d') . '\'');

        $responseData = [];
        if (empty($req->save)) {
            $mEmployee = new Employee();
            foreach ($overtimes as $overtime) {
                $employee = $mEmployee->Find('id = ?', [$overtime->employee]);
                $totalTime = number_format((strtotime($overtime->end_time) - strtotime($overtime->start_time)) / 3600, 2);
                $responseData[] = [
                    'id' => $overtime->id,
                    'startTime' => date('d/m/Y H:i:s', strtotime($overtime->start_time)),
                    'endTime' => date('d/m/Y H:i:s', strtotime($overtime->end_time)),
                    'name' => $employee[0]->first_name . ' ' . $employee[0]->last_name,
//                    'totalTime' => $overtime->total_time,
                    'totalTime' => $totalTime,
                    'notes' => $overtime->notes,
                ];
            }
        }

        if (!empty($req->save) && $req->save != 0) {

            if ($this->user->user_level !== 'Admin') {
                return new IceResponse(IceResponse::ERROR, []);
            }

            if (empty($filters)) {
                $dateFilter = 'and date_format(start_time, \'%Y-%m-%d\') >= \'' . $startDate->format('Y-m-d') . '\' and date_format(start_time, \'%Y-%m-%d\') <= \'' . $endDate->format('Y-m-d') . '\'';
            } else {
                $dateFilter = 'and date_format(start_time, \'%Y-%m-%d\') >= \'' . $startDate->format('Y-m-d') . '\' and date_format(start_time, \'%Y-%m-%d\') <= \'' . $endDate->format('Y-m-d') . '\'';
            }

            $sql = "select e.id                                   as employee_id,
                           eo.notes                               as location,
                           eo.start_time,
                           eo.end_time,
                           FORMAT(TIMESTAMPDIFF(SECOND , eo.start_time , eo.end_time) / 3600, 2) as total_time,
                           oc.coefficient,
                           oc.name                                as ot_type,
                           es.amount                              as total_salary,
                           oc.type                                as cat_type,                           
                           concat(e.first_name, ' ', e.last_name) as name
                    from EmployeeOvertime eo
                             join Employees e on eo.employee = e.id
                             join OvertimeCategories oc on eo.category = oc.id
                             join EmployeeSalary es on e.id = es.employee
                             join SalaryComponent sc on es.component = sc.id
                    where sc.componentType = 1 and eo.status = \"Approved\" and eo.formality = \"Trả lương\"
                    $dateFilter
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
                        $totalDays = $rowData['total_time'] / 24;
                        if (date('d', strtotime($rowData['start_time'])) > 26) {
                            $dateStartMonth = date('Y-m-26', strtotime($rowData['start_time']));
                            $dateEndMonth = date('Y-m-25', strtotime("+1 months", strtotime($rowData['end_time'])));
                        } else {
                            $dateStartMonth = date('Y-m-26', strtotime("-1 months", strtotime($rowData['start_time'])));
                            $dateEndMonth = date('Y-m-25', strtotime($rowData['end_time']));
                        }
                        $daysWorkingOfMonth = $this->getTotalWorkingDaysInMonth($dateStartMonth, $dateEndMonth);

                        $pricePerDay = $rowData['total_salary'] / $daysWorkingOfMonth;
                        $pricePerHour = round($pricePerDay) / 8;
                        $salary = (round($pricePerHour) * $rowData['total_time']) * $rowData['coefficient'];
                        if ($rowData['cat_type'] == 4) {
                            $totalDays = ($totalDays > 0 && $totalDays < 1 ? 1 : $totalDays);
                            $pricePerDay = 500000;
                            $salary = $totalDays * $pricePerDay;
                        } else if ($rowData['cat_type'] == 5) {
                            $totalDays = ($totalDays > 0 && $totalDays < 1  ? 1 : $totalDays);
                            $reqStartTime = new DateTime($rowData['start_time']);
                            $reqEndTime = new DateTime($rowData['end_time']);
                            $startDay = $reqStartTime->format('d');
                            $endDay = $reqEndTime->format('d');
                            $startTime = $reqStartTime->format('H:i:s');
                            $endTime = $reqEndTime->format('H:i:s');
                            $differDay = $endDay - $startDay;
                            $overDay = $endTime > '00:00:00' && $endTime < '04:00:00' && $differDay >= 1;

                            $pricePerDay = 120000;
                            $coefficient = 1;
                            $bonus = 0;

                            if ($startTime < '04:00:00' && $overDay) {
                                $coefficient = 4;
                                $bonus = 200000;
                            } elseif ($startTime < '04:00:00' || $overDay) {
                                $coefficient = 2;
                                $bonus = 100000;
                            } elseif ($endTime > '23:00:00' || $overDay) {
                                $bonus = 50000;
                                $coefficient = 1.5;
                            } elseif ($startTime < '05:00:00' || $endTime > '20:00:00') {
                                if ($rowData['total_time'] <= 6 && $endTime <= '20:30:00') {
                                    $pricePerDay = $pricePerDay * 0.5;
                                }
                                $coefficient = 1;
                                $bonus = 0;
                            } elseif ($startTime >= '08:00:00' && $endTime <= '20:00:00') {
                                $coefficient = 0;
                                $bonus = 0;
                            }

                            $pricePerDay = $pricePerDay * $coefficient;

                            $salary = $pricePerDay + $bonus;
                            if ($differDay > 1 || ($differDay == 1 && $endTime > '04:00:00')) {
                                $salary = $salary * ($differDay + 1);
                            }
                            // if ($rowData['total_time'] < 24) {
                            //     $salary = $pricePerDay + $bonus;
                            // } elseif ($rowData['total_time'] > 24){
                            //     $salary = ($pricePerDay / 24) * $rowData['total_time'] + $bonus;
                            // }
                        } else if ($rowData['cat_type'] == 6) {
                            $totalDays = ($totalDays > 0 && $totalDays < 1  ? 1 : $totalDays);
                            $reqStartTime = new DateTime($rowData['start_time']);
                            $reqEndTime = new DateTime($rowData['end_time']);
                            $startDay = $reqStartTime->format('d');
                            $endDay = $reqEndTime->format('d');
                            $startTime = $reqStartTime->format('H:i:s');
                            $endTime = $reqEndTime->format('H:i:s');
                            $differDay = $endDay - $startDay;
                            $overDay = $endTime > '00:00:00' && $endTime < '04:00:00' && $differDay >= 1;
                            $pricePerDay = 120000;
                            $coefficient = 1;
                            $bonus = 0;

                            if (($startTime < '04:00:00' && $endTime > '23:00:00') || ($startTime < '04:00:00' && $overDay)) {
                                $coefficient = 4;
                            } elseif ($startTime < '05:00:00' && ($endTime > '20:30:00' || $overDay)) {
                                $coefficient = 3;
                            } elseif ($startTime < '04:00:00' || $endTime > '23:00:00' || $overDay) {
                                $coefficient = 2;
                            } elseif ($startTime < '05:00:00' || $endTime >= '20:30:00') {
                                if ($rowData['total_time'] <= 6 && $endTime <= '20:30:00') {
                                    $pricePerDay = $pricePerDay * 0.5;
                                }
                                $coefficient = 1.5;
                            } elseif ($startTime >= '05:00:00' && $endTime <= '20:30:00') {
                                $coefficient = 1;
                                if ($rowData['total_time'] <= 6) {
                                    $pricePerDay = $pricePerDay * 0.5;
                                }
                            }

                            $pricePerDay = $pricePerDay * $coefficient;

                            $salary = $pricePerDay + $bonus;
                            if ($differDay > 1 || ($differDay == 1 && $endTime > '04:00:00')) {
                                $salary = $salary * ($differDay + 1);
                            }
                            // if ($rowData['total_time'] < 24) {
                            //     $salary = $pricePerDay + $bonus;
                            // } elseif ($rowData['total_time'] > 24){
                            //     $salary = ($pricePerDay / 24) * $rowData['total_time'] + $bonus;
                            // }
                        }
                        
                        $sheet->setCellValueByColumnAndRow(1, $rowIndex, $rowData['location']);
                        $sheet->setCellValueByColumnAndRow(2, $rowIndex, date('d/m/Y', strtotime($rowData['start_time'])));
                        $sheet->setCellValueByColumnAndRow(3, $rowIndex, date('d/m/Y', strtotime($rowData['end_time'])));
                        $sheet->setCellValueByColumnAndRow(4, $rowIndex, date('H:i', strtotime($rowData['start_time'])));
                        $sheet->setCellValueByColumnAndRow(5, $rowIndex, date('H:i', strtotime($rowData['end_time'])));
                        $sheet->setCellValueByColumnAndRow(6, $rowIndex, $totalDays);
                        $sheet->setCellValueByColumnAndRow(7, $rowIndex, $rowData['total_time']);
                        if ($rowData['cat_type'] == 5 || $rowData['cat_type'] == 6) {
                            $sheet->setCellValueByColumnAndRow(8, $rowIndex, $coefficient);
                            $sheet->setCellValueByColumnAndRow(9, $rowIndex, '120000');
                        } else {
                            $sheet->setCellValueByColumnAndRow(8, $rowIndex, $rowData['coefficient']);
                            $sheet->setCellValueByColumnAndRow(9, $rowIndex, round($pricePerDay));
                        }
                        $sheet->setCellValueByColumnAndRow(10, $rowIndex, round($salary));
                        $sheet->setCellValueByColumnAndRow(11, $rowIndex, $rowData['ot_type']);

                        $rowIndex++;
                    }
                    $tempIdx = $rowIndex - 1;
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

    protected function getTotalWorkingDaysInMonth($startDate, $endDate)
    {
        $startTime = \DateTime::createFromFormat('Y-m-d H:i:s', $startDate . " 00:00:00");
        $endTime = \DateTime::createFromFormat('Y-m-d H:i:s', $endDate . " 23:59:59");
        $totalDays = $endTime->diff($startTime)->days + 1;
        LogManager::getInstance()->info("Total Days: " . $totalDays->days);
        while ($startTime <= $endTime) {
            $dayOfWeek = $startTime->format('w');

            if ($dayOfWeek < 1) {
                $totalDays -= 1;
            } elseif ($dayOfWeek == 6) {
                $totalDays -= 0.5;
            }

            $startTime->add(\DateInterval::createFromDateString('1 day'));
        }

        return $totalDays;
    }
}

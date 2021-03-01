<?php


namespace Leaves\Admin\Api;


use Classes\IceConstants;
use Classes\IceResponse;
use Classes\LanguageManager;
use Classes\SubActionManager;
use Employees\Common\Model\Employee;
use Leaves\Common\Model\EmployeeLeave;
use Leaves\Common\Model\EmployeeLeaveDay;
use Leaves\Common\Model\EmployeeLeaveLog;
use Leaves\Common\Model\LeaveType;
use Leaves\User\Api\LeavesEmailSender;
use Model\LeavePeriod;
use Model\LeaveRule;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Users\Common\Model\User;
use Utils\LogManager;

class LeavesActionManager extends SubActionManager
{
    public function getReportLeaves($req)
    {
        //$employee = $this->baseService->getElement('Employee', $this->getCurrentProfileId(), null, true);
        $mEmployee = new Employee();

        $responseData = array();

        $mLeaveType = new LeaveType();
        $leaveType = $mLeaveType->Load("id=1");
        //Find Current leave period

        $currentLeavePeriodResp = $this->getCurrentLeavePeriod(date('Y-m-d'), date('Y-m-d'));
        if(!isset($req->ft->date_start) && !isset($req->ft->date_end)){
            if ($currentLeavePeriodResp->getStatus() != IceResponse::SUCCESS) {
                return new IceResponse(IceResponse::ERROR, $currentLeavePeriodResp->getData());
            } else {
                $currentLeavePeriod = $currentLeavePeriodResp->getData();
            }
        } else {
            $currentLeavePeriod = $req->ft;
        }

        $allApproveLeaves = $this->getAllApproveLeave($currentLeavePeriod, $leaveType);
        $employeeList = [];

        foreach ($allApproveLeaves as $approve){
            $employeeList[] = $approve->employee;
        }

        $employees = $mEmployee->Find("status = 'Active' and id in (".implode(',', $employeeList).")");

        foreach ($employees as $employee){
            $leaveMatrix = $this->getAvailableLeaveMatrixForEmployeeLeaveType($employee, $currentLeavePeriod, $leaveType);

            $time = strtotime($employee->joined_date);

            $joinDate = date('d/m/Y',$time);

            $leaves = array();
            $leaves['id'] = $employee->id;
            $leaves['name'] = $employee->first_name . ' ' . $employee->last_name;
            $leaves['joinedDate'] = $joinDate;
            $leaves['totalLeaves'] = floatval($leaveMatrix[0]);
            $leaves['approvedLeaves'] = floatval($leaveMatrix[1]);
            $leaves['carriedForward'] = floatval($leaveMatrix[2]['carriedForward']);
            $leaves['availableLeaves'] = floatval($leaveMatrix[0]) - $leaves['approvedLeaves'];
            $leaves['bonusLeaveDays'] = 0;
            $leaves['previousBalanceDays'] = 0;

            $responseData[] = $leaves;
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
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Report Leaves") . ' ' . date('d/m/Y'));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                //Set header
                $rowIndex = 3;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("STT"));
                $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Name"));
                $sheet->setCellValueByColumnAndRow(3, $rowIndex, LanguageManager::tran("Joined Date"));
                $sheet->setCellValueByColumnAndRow(4, $rowIndex, LanguageManager::tran("Approved Leaves"));
                $sheet->setCellValueByColumnAndRow(5, $rowIndex, LanguageManager::tran("Leaves Carried Forward"));
                $sheet->setCellValueByColumnAndRow(6, $rowIndex, LanguageManager::tran("Available Leaves"));

                //Set data
                $rowIndex = 4;
                foreach ($responseData as $rowData) {
                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, $rowData['id']);
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, $rowData['name']);
                    $sheet->setCellValueByColumnAndRow(3, $rowIndex, $rowData['joinedDate']);
                    $sheet->setCellValueByColumnAndRow(4, $rowIndex, $rowData['approvedLeaves']);
                    $sheet->setCellValueByColumnAndRow(5, $rowIndex, $rowData['carriedForward']);
                    $sheet->setCellValueByColumnAndRow(6, $rowIndex, $rowData['availableLeaves']);

                    $rowIndex++;
                }
            } catch (Exception $e) {
                LogManager::getInstance()->error("Export to EXCEL Error\r\n" . $e->getMessage() . "\r\n" . $e->getTraceAsString());
            }
            $filename = uniqid('report_leaves_');
            $filePath = CLIENT_BASE_PATH . "/data/report_leaves_{$filename}.xlsx";
            $fileUrl = CLIENT_BASE_URL . "/data/report_leaves_{$filename}.xlsx";
            $writer = new Xlsx($spreadsheet);
            $writer->save($filePath);
            $responseData['file'] = [
                'url' => $fileUrl,
                'name' => "{$filename}.xlsx"
            ];
        }

        return new IceResponse(IceResponse::SUCCESS, $responseData);
    }

    public function getCurrentLeavePeriod($startDate, $endDate)
    {
        $leavePeriod = new LeavePeriod();
        $leavePeriod->Load("date_start <= ? and date_end >= ?", array($startDate, $endDate));
        if (empty($leavePeriod->id)) {
            $leavePeriod1 = new LeavePeriod();
            $leavePeriod1->Load("date_start <= ? and date_end >= ?", array($startDate, $startDate));

            $leavePeriod2 = new LeavePeriod();
            $leavePeriod2->Load("date_start <= ? and date_end >= ?", array($endDate, $endDate));

            if (!empty($leavePeriod1->id) && !empty($leavePeriod2->id)) {
                return new IceResponse(IceResponse::ERROR, "You are trying to apply leaveman in two leave periods. You may apply leaveman til $leavePeriod1->date_end. Rest you have to apply seperately");
            } else {
                $leavePeriod->name = 'Year ' . date('Y');
                $leavePeriod->date_start = date('Y-m-01');
                $leavePeriod->date_end = date('Y-m-t');
                $leavePeriod->status = 'Active';
                $leavePeriod->save();
                return new IceResponse(IceResponse::SUCCESS, $leavePeriod);
                #return new IceResponse(IceResponse::ERROR, "The leave period for your leave application is not defined. Please inform administrator");
            }

        } else {
            return new IceResponse(IceResponse::SUCCESS, $leavePeriod);
        }
    }

    private function getAvailableLeaveMatrixForEmployeeLeaveType($employee, $currentLeavePeriod, $leaveTypeId)
    {
        /**
         * [Total Available],[Pending],[Approved],[Rejected]
         */

        $rule = $this->getLeaveRule($employee, $leaveTypeId);
        //$avalilable = $rule->default_per_year;
        $avalilableLeaves = $this->getAvailableLeaveCount($employee, $rule, $currentLeavePeriod, $leaveTypeId);
        $avalilable = $avalilableLeaves[0];
        $approved = $this->countLeaveAmounts($this->getEmployeeLeaves($employee->id, $currentLeavePeriod, $leaveTypeId, 'Approved'));

        return array($avalilable, $approved, $avalilableLeaves[1]);
    }

    private function countLeaveAmounts($leaves)
    {
        $amount = 0;
        foreach ($leaves as $leave) {
            $empLeaveDay = new EmployeeLeaveDay();
            $leaveDays = $empLeaveDay->Find("employee_leave = ?", array($leave->id));
            foreach ($leaveDays as $leaveDay) {
                if ($leaveDay->leave_type == 'Full Day') {
                    $amount += 1;
                } else if ($leaveDay->leave_type == 'Half Day - Morning') {
                    $amount += 0.5;
                } else if ($leaveDay->leave_type == 'Half Day - Afternoon') {
                    $amount += 0.5;
                }
            }
        }
        return floatval($amount);
    }

    private function getEmployeeLeaves($employeeId, $leavePeriod, $leaveType, $status)
    {
        $employeeLeave = new EmployeeLeave();
        $employeeLeaves = $employeeLeave->Find("employee = ? and date_start >= ? and date_end <= ? and leave_type = ? and status = ?",
            array(
                $employeeId,
                date('Y-m-01', strtotime($leavePeriod->date_start)),
                date('Y-m-t', strtotime($leavePeriod->date_end)),
                $leaveType,
                'Approved'
            )
        );
        if (!$employeeLeaves) {
            error_log($employeeLeave->ErrorMsg());
        }

        return $employeeLeaves;

    }

    private function getAvailableLeaveCount($employee, $rule, $currentLeavePeriod, $leaveTypeId)
    {

        $availableLeaveArray = array();

        $currentLeaves = intval($rule->default_per_year);

        //If the employee joined in current leave period, his leaveman should be calculated proportional to joined date
        if ($employee->joined_date != "0000-00-00 00:00:00" && !empty($employee->joined_date)) {
            if (strtotime($currentLeavePeriod->date_start) < strtotime($employee->joined_date)) {
                $currentLeaves = intval($currentLeaves * (strtotime($currentLeavePeriod->date_end) - strtotime($employee->joined_date)) / (strtotime($currentLeavePeriod->date_end) - strtotime($currentLeavePeriod->date_start)));
            }
        }

        $availableLeaveArray["total"] = $currentLeaves;

        if ($rule->leave_accrue == "Yes") {
            $dateTodayTime = strtotime(date("Y-m-d"));
            //Take employee joined date into account
            $startTime = strtotime($currentLeavePeriod->date_start);
            $endTime = strtotime($currentLeavePeriod->date_end);
            $datediffFromStart = $dateTodayTime - $startTime;
            $datediffPeriod = $endTime - $startTime;

            $currentLeaves = intval(ceil(($currentLeaves * $datediffFromStart) / $datediffPeriod));
        }

        $availableLeaveArray["accrued"] = $currentLeaves;

        $availableLeaveArray["carriedForward"] = 0;

        //Leaves should be carried forward only if employee joined before current leave period

        if ($rule->carried_forward == "Yes" &&
            strtotime($currentLeavePeriod->date_start) > strtotime($employee->joined_date)) {
            //findPreviousLeavePeriod
            $dayInPreviousLeavePeriod = date('Y-m-d', strtotime($currentLeavePeriod->date_start . ' -1 day'));
            $resp = $this->getCurrentLeavePeriod($dayInPreviousLeavePeriod, $dayInPreviousLeavePeriod);
            if ($resp->getStatus() == "SUCCESS") {
                $prvLeavePeriod = $resp->getData();
                $avalilable = $rule->default_per_year;

                //If the employee joined in this leave period, his leaveman should be calculated proportionally
                if ($employee->joined_date != "0000-00-00 00:00:00" && !empty($employee->joined_date)) {
                    if (strtotime($prvLeavePeriod->date_start) < strtotime($employee->joined_date)) {
                        $avalilable = intval($avalilable * (strtotime($prvLeavePeriod->date_end) - strtotime($employee->joined_date)) / (strtotime($prvLeavePeriod->date_end) - strtotime($prvLeavePeriod->date_start)));
                    }
                }

                $approved = $this->countLeaveAmounts($this->getEmployeeLeaves($employee->id, $prvLeavePeriod, $leaveTypeId, 'Approved'));

                $leaveTypeObj = new LeaveType();
                $leaveTypeData = $leaveTypeObj->Find("id = ?", array($leaveTypeId));

                $leavesCarriedForward = intval($avalilable) - intval($approved);

                if(!empty($leaveTypeData[0]->days_forward) && !empty($leaveTypeData[0]->date_reset) && $leavesCarriedForward > $leaveTypeData[0]->days_forward) {
                    $leavesCarriedForward = $leaveTypeData[0]->days_forward;
                }

                if(!empty($leaveTypeData[0]->date_reset) && date('m-d', strtotime($leaveTypeData[0]->date_reset)) < date('m-d')) {
                    $leavesCarriedForward = 0;
                }

                if ($leavesCarriedForward < 0) {
                    $leavesCarriedForward = 0;
                }
                $availableLeaveArray["carriedForward"] = $leavesCarriedForward;
                $currentLeaves = intval($currentLeaves) + intval($leavesCarriedForward);
            }
        }

        return array($currentLeaves, $availableLeaveArray);
    }

    private function getLeaveRule($employee, $leaveType)
    {
        $rule = null;
        $leaveRule = new LeaveRule();
        $leaveTypeObj = new LeaveType();
        $rules = $leaveRule->Find("employee = ? and leave_type = ?", array($employee->id, $leaveType));
        if (count($rules) > 0) {
            return $rules[0];
        }

        $rules = $leaveRule->Find("job_title = ? and employment_status = ? and leave_type = ? and employee is null", array($employee->job_title, $employee->employment_status, $leaveType));
        if (count($rules) > 0) {
            return $rules[0];
        }

        $rules = $leaveRule->Find("job_title = ? and employment_status is null and leave_type = ? and employee is null", array($employee->job_title, $leaveType));
        if (count($rules) > 0) {
            return $rules[0];
        }

        $rules = $leaveRule->Find("job_title is null and employment_status = ? and leave_type = ? and employee is null", array($employee->employment_status, $leaveType));
        if (count($rules) > 0) {
            return $rules[0];
        }

        $rules = $leaveTypeObj->Find("id = ?", array($leaveType));
        if (count($rules) > 0) {
            return $rules[0];
        }

    }

    private function getAllApproveLeave($leavePeriod, $leaveTypeId) {
        $employeeLeave = new EmployeeLeave();
        $employeeLeaves = $employeeLeave->Find("date_start >= ? and date_end <= ? and leave_type = ? and status = ?",
            array(
                date('Y-m-01', strtotime($leavePeriod->date_start)),
                date('Y-m-t', strtotime($leavePeriod->date_end)),
                $leaveTypeId, 'Approved'
            )
        );
        if (!$employeeLeaves) {
            error_log($employeeLeave->ErrorMsg());
        }

        return $employeeLeaves;
    }

    public function getLeaveDaysReadonly($req)
    {
        $leaveId = $req->leave_id;
        $leaveLogs = array();

        $employeeLeave = new EmployeeLeave();
        $employeeLeave->Load("id = ?", array($leaveId));

        $employee = $this->baseService->getElement('Employee', $employeeLeave->employee, null, true);
        $rule = $this->getLeaveRule($employee, $employeeLeave->leave_type);

        $currentLeavePeriodResp = $this->getCurrentLeavePeriod($employeeLeave->date_start, $employeeLeave->date_end);
        if ($currentLeavePeriodResp->getStatus() != IceResponse::SUCCESS) {
            return new IceResponse(IceResponse::ERROR, $currentLeavePeriodResp->getData());
        } else {
            $currentLeavePeriod = $currentLeavePeriodResp->getData();
        }

        $leaveMatrix = $this->getAvailableLeaveMatrixForEmployeeLeaveType($employee, $currentLeavePeriod, $employeeLeave->leave_type);

        $leaves = array();
        $leaves['totalLeaves'] = floatval($leaveMatrix[0]);
        $leaves['pendingLeaves'] = floatval($leaveMatrix[1]);
        $leaves['approvedLeaves'] = floatval($leaveMatrix[2]);
        $leaves['rejectedLeaves'] = floatval($leaveMatrix[3]);
        $leaves['availableLeaves'] = $leaves['totalLeaves'] - $leaves['pendingLeaves'] - $leaves['approvedLeaves'];
        $leaves['attachment'] = $employeeLeave->attachment;

        $employeeLeaveDay = new EmployeeLeaveDay();
        $days = $employeeLeaveDay->Find("employee_leave = ?", array($leaveId));

        $employeeLeaveLog = new EmployeeLeaveLog();
        $logsTemp = $employeeLeaveLog->Find("employee_leave = ? order by created", array($leaveId));
        foreach ($logsTemp as $empLeaveLog) {
            $t = array();
            $t['time'] = $empLeaveLog->created;
            $t['status_from'] = $empLeaveLog->status_from;
            $t['status_to'] = $empLeaveLog->status_to;
            $t['time'] = $empLeaveLog->created;
            $userName = null;
            if (!empty($empLeaveLog->user_id)) {
                $lgUser = new User();
                $lgUser->Load("id = ?", array($empLeaveLog->user_id));
                if ($lgUser->id == $empLeaveLog->user_id) {
                    if (!empty($lgUser->employee)) {
                        $lgEmployee = new Employee();
                        $lgEmployee->Load("id = ?", array($lgUser->employee));
                        $userName = $lgEmployee->first_name . " " . $lgEmployee->last_name;
                    } else {
                        $userName = $lgUser->userName;
                    }

                }
            }

            if (!empty($userName)) {
                $t['note'] = $empLeaveLog->data . " (by: " . $userName . ")";
            } else {
                $t['note'] = $empLeaveLog->data;
            }

            $leaveLogs[] = $t;
        }

        return new IceResponse(IceResponse::SUCCESS, array($days, $leaves, $leaveId, $employeeLeave, $leaveLogs));
    }

    public function changeLeaveStatus($req)
    {
        $employee = $this->baseService->getElement('Employee', $this->getCurrentProfileId(), null, true);

        $subordinate = new Employee();
        $subordinates = $subordinate->Find("supervisor = ?", array($employee->id));

        $subordinatesIds = array();
        foreach ($subordinates as $sub) {
            $subordinatesIds[] = $sub->id;
        }


        $employeeLeave = new EmployeeLeave();
        $employeeLeave->Load("id = ?", array($req->id));
        if ($employeeLeave->id != $req->id) {
            return new IceResponse(IceResponse::ERROR, "Leave not found");
        }

        if (!in_array($employeeLeave->employee, $subordinatesIds) && $this->user->user_level != 'Admin') {
            return new IceResponse(IceResponse::ERROR, "This leave does not belong to any of your subordinates");
        }
        $oldLeaveStatus = $employeeLeave->status;
        $employeeLeave->status = $req->status;

        if ($oldLeaveStatus == $req->status) {
            return new IceResponse(IceResponse::SUCCESS, "");
        }


        $ok = $employeeLeave->Save();
        if (!$ok) {
            error_log($employeeLeave->ErrorMsg());
            return new IceResponse(IceResponse::ERROR, "Error occured while saving leave infomation. Please contact admin");
        }

        $employeeLeaveLog = new EmployeeLeaveLog();
        $employeeLeaveLog->employee_leave = $employeeLeave->id;
        $employeeLeaveLog->user_id = $this->baseService->getCurrentUser()->id;
        $employeeLeaveLog->status_from = $oldLeaveStatus;
        $employeeLeaveLog->status_to = $employeeLeave->status;
        $employeeLeaveLog->created = date("Y-m-d H:i:s");
        $employeeLeaveLog->data = isset($req->reason) ? $req->reason : "";
        $ok = $employeeLeaveLog->Save();
        if (!$ok) {
            error_log($employeeLeaveLog->ErrorMsg());
        }


        if (!empty($this->emailSender) && $oldLeaveStatus != $employeeLeave->status) {
            $leavesEmailSender = new LeavesEmailSender($this->emailSender, $this);
            $leavesEmailSender->sendLeaveStatusChangedEmail($employee, $employeeLeave);
        }


        $this->baseService->audit(IceConstants::AUDIT_ACTION, "Leave status changed \ from:" . $oldLeaveStatus . "\ to:" . $employeeLeave->status . " \ id:" . $employeeLeave->id);

        if ($employeeLeave->status != "Pending") {
            $notificationMsg = "Your leave has been $employeeLeave->status by " . $employee->first_name . " " . $employee->last_name;
            if (!empty($req->reason)) {
                $notificationMsg .= " (Note:" . $req->reason . ")";
            }
        }

        $this->baseService->notificationManager->addNotification($employeeLeave->employee, $notificationMsg, '{"type":"url","url":"g=modules&n=leaveman&m=module_Leaves#tabEmployeeLeaveApproved"}', IceConstants::NOTIFICATION_LEAVE);

        return new IceResponse(IceResponse::SUCCESS, "");
    }

}
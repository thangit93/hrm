<?php


namespace Leaves\Admin\Api;


use Classes\IceResponse;
use Classes\SubActionManager;
use Employees\Common\Model\Employee;
use Leaves\Common\Model\EmployeeLeave;
use Leaves\Common\Model\EmployeeLeaveDay;
use Leaves\Common\Model\LeaveType;
use Model\LeavePeriod;
use Model\LeaveRule;

class LeavesActionManager extends SubActionManager
{
    public function getReportLeaves($req)
    {
        //$employee = $this->baseService->getElement('Employee', $this->getCurrentProfileId(), null, true);
        $mEmployee = new Employee();

        $leaveEntitlementArray = array();

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

        $employees = $mEmployee->Find("status = ? and id in (?)", [
            'Active',
            implode(',', $employeeList)
        ]);

        foreach ($employees as $employee){
            $leaveMatrix = $this->getAvailableLeaveMatrixForEmployeeLeaveType($employee, $currentLeavePeriod, $leaveType);

            $time = strtotime($employee->joined_date);

            $joinDate = date('d/m/Y',$time);

            $leaves = array();
            $leaves['id'] = $leaveType->id;
            $leaves['name'] = $employee->first_name . ' ' . $employee->last_name;
            $leaves['joinedDate'] = $joinDate;
            $leaves['totalLeaves'] = floatval($leaveMatrix[0]);
            $leaves['approvedLeaves'] = floatval($leaveMatrix[1]);
            $leaves['availableLeaves'] = floatval($leaveMatrix[0]) - $leaves['pendingLeaves'] - $leaves['approvedLeaves'];
            $leaves['bonusLeaveDays'] = 0;
            $leaves['previousBalanceDays'] = 0;

            $leaveEntitlementArray[] = $leaves;
        }

        return new IceResponse(IceResponse::SUCCESS, $leaveEntitlementArray);
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

                $leavesCarriedForward = intval($avalilable) - intval($approved);
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
}
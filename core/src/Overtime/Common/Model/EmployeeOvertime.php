<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 3:14 PM
 */

namespace Overtime\Common\Model;

use Classes\FileService;
use Classes\IceResponse;
use Classes\SettingsManager;
use Employees\Common\Model\Employee;
use Model\ApproveModel;
use Utils\LogManager;
use Leaves\Common\Model\LeaveType;

class EmployeeOvertime extends ApproveModel
{
    public $table = 'EmployeeOvertime';

    public $notificationModuleName = "Overtime Management";
    public $notificationUnitName = "OvertimeRequest";
    public $notificationUnitPrefix = "An";
    public $notificationUnitAdminUrl = "g=modules&n=overtime&m=module_Time_Management#tabSubordinateEmployeeOvertime";
    public $preApproveSettingName = "Attendance: Pre-Approve Overtime Request";

    public function isMultiLevelApprovalsEnabled()
    {
        return (SettingsManager::getInstance()->getSetting('Overtime: Enable Multi Level Approvals') == '1');
    }

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
        return array("get");
    }

    public function getUserOnlyMeAccess()
    {
        return array("element", "save", "delete");
    }

    public function fieldsNeedToBeApproved()
    {
        return array(
            "start_time",
            "end_time"
        );
    }

    public function getType()
    {
        return 'EmployeeOvertime';
    }

    public function allowIndirectMapping()
    {
        if (SettingsManager::getInstance()->getSetting('Overtime: Allow Indirect Admins to Approve') == '1') {
            return true;
        }
        return false;
    }

    public function validateSave($obj)
    {
        if (strtotime($obj->start_time) >= strtotime($obj->end_time)) {
            return new IceResponse(IceResponse::ERROR, 'Incorrect start and end time');
        }
        return new IceResponse(IceResponse::SUCCESS, "");
    }

    public function postProcessGetData($obj)
    {
        $obj = FileService::getInstance()->updateSmallProfileImage($obj);
        #$obj->status = t($obj->status);

        $employee = new Employee();
        $empInfo = $employee->find('id = ?', [$obj->employee]);
        $totalTime = number_format((strtotime($obj->end_time) - strtotime($obj->start_time)) / 3600, 2);
        $obj->total_time = $totalTime;

        if (!empty($empInfo[0]->supervisor) && $empInfo[0]->supervisor != "NULL") {
            $supervisor = $employee->find('id = ?', [$empInfo[0]->supervisor]);
            $obj->supervisor = $supervisor[0]->first_name . ' ' . $supervisor[0]->last_name;
        }
        return $obj;
    }

    public function executePostSaveActions($obj)
    {
        try {
            parent::executePostSaveActions($obj);
            // && $obj->status == 'Approved'
            if ($obj->formality == 'Ngh??? b??') {
                $ovtCateModel = new OvertimeCategory();
                $leaveType = new LeaveType();
                $leaveType->Load('id = ?', [14]);
                $defaultDay = $leaveType->default_per_year;

                $ovtCateInfo = $ovtCateModel->find('id = ?', [$obj->category]);
                $diffTime = number_format((strtotime($obj->end_time) - strtotime($obj->start_time)) / 3600, 2);
                $baseDayCount = number_format($diffTime / 8, 2);
                if ($baseDayCount < 0.5) $baseDayCount = 0.5;
                if ($baseDayCount > 1) $baseDayCount = intval($baseDayCount);
                $overTimeLeaveDays = $baseDayCount * $ovtCateInfo[0]->coefficient;

                $employee = new Employee();
                $employee->Load('id = ?', [$obj->employee]);
                $employee->overtime_leave_days += $overTimeLeaveDays;

                if ($employee->overtime_leave_days > $defaultDay) $employee->overtime_leave_days = $defaultDay;

                $employee->save();
            }
        } catch (\Exception $e) {
            LogManager::getInstance()->error($e);
        }
    }
}

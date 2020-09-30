<?php


namespace Leaves\Admin\Api;


use Leaves\Common\Model\EmployeeLeave;
use Leaves\Common\Model\EmployeeLeaveDay;
use Leaves\Common\Model\LeaveType;
use Model\HoliDay;

class EmployeeLeaveUtil
{
    public function calculateEmployeeLeave($employeeId, $startDate, $endDate)
    {
        $total = 0;
        $total += EmployeeLeaveUtil::getHolidayAtSum($startDate, $endDate);
        $leaves = $this->getEmployeeLeave($employeeId, $startDate, $endDate);

        if (empty($leaves)) {
            return $total;
        }

        foreach ($leaves as $leave) {
            foreach ($leave as $day) {
                $total += $day->period;
            }
        }

        return $total;
    }

    public function getEmployeeLeave($employeeId, $startDate, $endDate)
    {
        $employeeLeavesModel = new EmployeeLeave();
        /** @var array $employeeLeaves */
        $employeeLeaves = $employeeLeavesModel->Find('employee = ? and status = "Approved" and ((date_start >= ? and date_start <= ?) or (date_end >= ? and date_end <= ?))', [
            $employeeId,
            $startDate,
            $endDate,
            $startDate,
            $endDate,
        ]);

        $leaveDays = [];

        foreach ($employeeLeaves as $employeeLeave) {
            $leaveType = $this->getLeaveType($employeeLeave->leave_type);

            if (empty($leaveType) || empty($leaveType->pay)) {
                continue;
            }

            $leaveDays[] = $this->getLeaveDays($employeeLeave->id, $startDate, $endDate);
        }

        return $leaveDays;
    }

    public function getLeaveDays($employeeLeaveId, $startDate, $endDate)
    {
        $model = new EmployeeLeaveDay();
        $dates = $model->Find('employee_leave = ? and (leave_date >= ? or leave_date <= ?)', [
            $employeeLeaveId,
            $startDate,
            $endDate
        ]);

        foreach ($dates as $date) {
            if ($date->leave_type == 'Full Day') {
                $date->period = 1;
            } else {
                $date->period = 0.5;
            }
        }

        return $dates;
    }

    public function getLeaveType($id)
    {
        $model = new LeaveType();
        /** @var array $obj */
        $obj = $model->Find('id = ?', [$id]);
        return array_shift($obj);
    }

    public static function getHolidayAtSum($startDate, $endDate, $countryId = null)
    {
        $hd = new HoliDay();
        $total = 0;
        $query = "dateh >= ? and dateh <= ?";
        $queryData = [$startDate, $endDate];

        if (empty($countryId)) {
            $query .= " and country IS NULL";
        } else {
            $query .= " and country = ?";
            $queryData[] = $countryId;
        }

        $holidays = $hd->Find($query, $queryData);

        foreach ($holidays as $holiday) {
            if ($holiday->status == "Full Day") {
                $total += 1;
            } else {
                $total += 0.5;
            }
        }

        return $total;
    }

    public static function getHolidays($startDate, $endDate, $countryId = null)
    {
        $hd = new HoliDay();
        $query = "dateh >= ? and dateh <= ?";
        $queryData = [$startDate, $endDate];

        if (empty($countryId)) {
            $query .= " and country IS NULL";
        } else {
            $query .= " and country = ?";
            $queryData[] = $countryId;
        }

        return $hd->Find($query, $queryData);
    }
}
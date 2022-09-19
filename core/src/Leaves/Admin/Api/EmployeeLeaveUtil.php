<?php


namespace Leaves\Admin\Api;


use Attendance\Admin\Api\AttendanceUtil;
use DateInterval;
use DateTime;
use Employees\Common\Model\Employee;
use Leaves\Common\Model\EmployeeLeave;
use Leaves\Common\Model\EmployeeLeaveDay;
use Leaves\Common\Model\LeaveType;
use Model\HoliDay;
use Salary\Admin\Api\SalaryUtil;

class EmployeeLeaveUtil
{
    public function calculateEmployeeLeave($employeeId, $startDate, $endDate)
    {
        $startDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $startDate . " 00:00:00");
        $endDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $endDate . " 23:59:59");
        $total = 0;
        $employee = new Employee();
        $employee->Load('id = ?', [$employeeId]);
        $joinedDate = DateTime::createFromFormat('Y-m-d H:i:s', "{$employee->joined_date} 00:00:00");

        while ($startDateObj <= $endDateObj) {
            if ($joinedDate > $startDateObj) {
                $startDateObj->add(\DateInterval::createFromDateString('1 day'));
                continue;
            }

            $dayOfWeek = $startDateObj->format('w');
            $employeeLeaveDays = $this->getEmployeeLeave($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
            $holidays = EmployeeLeaveUtil::getHolidays($startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));

            if (empty($employeeLeaveDays) && empty($holidays)) {
                $startDateObj->add(DateInterval::createFromDateString('1 day'));
                continue;
            }

            $atSum = 0;

            if (!empty($employeeLeaveDays)) {
                foreach ($employeeLeaveDays as $employeeLeaveDay) {
                    foreach ($employeeLeaveDay as $day) {
                        $atSum += $day->period;

                        if ($dayOfWeek < 6 && $dayOfWeek >= 1 && $atSum > 1) {
                            $atSum = 1;
                        } elseif ($dayOfWeek == 6 && $atSum > 0.5) {
                            $atSum = 0.5;
                        }
                    }
                }
            }

            if (!empty($holidays)) {
                foreach ($holidays as $holiday) {
                    $atSum = ($holiday->status == "Full Day") ? 1 : 0.5;
                }
            }

            $atSum = SalaryUtil::maxAt($startDateObj->format('Y-m-d'), $atSum);

            $atts = AttendanceUtil::getAttendancesData($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
            if (!empty($atts)) {
                $att = array_shift($atts);
                $at = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employeeId);
                $atSum2 = $at + $atSum;
                if ($dayOfWeek < 6 && $dayOfWeek >= 1 && $atSum2 > 1) {
                    $atSum = 1 - $at;
                } elseif ($dayOfWeek == 6 && $atSum2 > 0.5) {
                    $atSum = 0.5 - $at;
                }
            }

            $atSum = ($atSum < 0) ? 0 : $atSum;

            $total += $atSum;

            $startDateObj->add(\DateInterval::createFromDateString('1 day'));
        }

        $attUtil = new AttendanceUtil();
        $totalWorkingDaysInMonth = $attUtil->getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $totalWorkedDaysInMonth = $attUtil->getDaysWorked($employeeId, $startDate, $endDate);
        $totalWorkedDaysAndLeave = $total + $totalWorkedDaysInMonth;

        if ($totalWorkedDaysAndLeave > $totalWorkingDaysInMonth) {
            $total = $totalWorkingDaysInMonth - $totalWorkedDaysInMonth;
        }

        return $total;
    }

    public function calculateEmployeeLeaveNoPay($employeeId, $startDate, $endDate)
    {
        $startDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $startDate . " 00:00:00");
        $endDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $endDate . " 23:59:59");
        $total = 0;
        $employee = new Employee();
        $employee->Load('id = ?', [$employeeId]);
        $joinedDate = DateTime::createFromFormat('Y-m-d H:i:s', "{$employee->joined_date} 00:00:00");

        while ($startDateObj <= $endDateObj) {
            if ($joinedDate > $startDateObj) {
                $startDateObj->add(\DateInterval::createFromDateString('1 day'));
                continue;
            }

            $dayOfWeek = $startDateObj->format('w');
            $employeeLeaveDays = $this->getEmployeeLeaveNoPay($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
            $holidays = EmployeeLeaveUtil::getHolidays($startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));

            if (empty($employeeLeaveDays) && empty($holidays)) {
                $startDateObj->add(DateInterval::createFromDateString('1 day'));
                continue;
            }

            $atSum = 0;

            if (!empty($employeeLeaveDays)) {
                foreach ($employeeLeaveDays as $employeeLeaveDay) {
                    foreach ($employeeLeaveDay as $day) {
                        $atSum += $day->period;

                        if ($dayOfWeek < 6 && $dayOfWeek >= 1 && $atSum > 1) {
                            $atSum = 1;
                        } elseif ($dayOfWeek == 6 && $atSum > 0.5) {
                            $atSum = 0.5;
                        }
                    }
                }
            }

            if (!empty($holidays)) {
                foreach ($holidays as $holiday) {
                    $atSum = ($holiday->status == "Full Day") ? 1 : 0.5;
                }
            }

            $atSum = SalaryUtil::maxAt($startDateObj->format('Y-m-d'), $atSum);

            $atts = AttendanceUtil::getAttendancesData($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
            if (!empty($atts)) {
                $att = array_shift($atts);
                $at = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employeeId);
                $atSum2 = $at + $atSum;
                if ($dayOfWeek < 6 && $dayOfWeek >= 1 && $atSum2 > 1) {
                    $atSum = 1 - $at;
                } elseif ($dayOfWeek == 6 && $atSum2 > 0.5) {
                    $atSum = 0.5 - $at;
                }
            }

            $atSum = ($atSum < 0) ? 0 : $atSum;

            $total += $atSum;

            $startDateObj->add(\DateInterval::createFromDateString('1 day'));
        }

        $attUtil = new AttendanceUtil();
        $totalWorkingDaysInMonth = $attUtil->getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $totalWorkedDaysInMonth = $attUtil->getDaysWorked($employeeId, $startDate, $endDate);
        $totalWorkedDaysAndLeave = $total + $totalWorkedDaysInMonth;

        if ($totalWorkedDaysAndLeave > $totalWorkingDaysInMonth) {
            $total = $totalWorkingDaysInMonth - $totalWorkedDaysInMonth;
        }

        return $total;
    }

    public function calculateEmployeeLeave2($employeeId, $startDate, $endDate)
    {
        $total = 0;
        $total += EmployeeLeaveUtil::getHolidayAtSum($startDate, $endDate);
        $leaves = $this->getEmployeeLeave($employeeId, $startDate, $endDate);

        if (empty($leaves)) {
            return $total;
        }

        foreach ($leaves as $leave) {
            foreach ($leave as $day) {
                if (empty(EmployeeLeaveUtil::getHolidayAtSum($day->leave_date, $day->leave_date))) {
                    $total += $day->period;
                }
            }
        }

        $attUtil = new AttendanceUtil();
        $totalWorkingDaysInMonth = $attUtil->getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $totalWorkedDaysInMonth = $attUtil->getDaysWorked($employeeId, $startDate, $endDate);
        $totalWorkedDaysAndLeave = $total + $totalWorkedDaysInMonth;

        if ($totalWorkedDaysAndLeave > $totalWorkingDaysInMonth) {
            $total = $totalWorkingDaysInMonth - $totalWorkedDaysInMonth;
        }

        return $total;
    }

    public function getEmployeeLeave($employeeId, $startDate, $endDate, $getAll = false)
    {
        $employeeLeavesModel = new EmployeeLeave();
        /** @var array $employeeLeaves */
        $employeeLeaves = $employeeLeavesModel->Find('employee = ? and status = "Approved" and date_start <= ? and date_end >= ? and is_deleted <> 1', [
            $employeeId,
            $startDate,
            $endDate,
        ]);

        $leaveDays = [];

        foreach ($employeeLeaves as $employeeLeave) {
            $leaveType = $this->getLeaveType($employeeLeave->leave_type);

            if (empty($leaveType) || (empty($leaveType->pay) && empty($getAll))) {
                continue;
            }

            $leaveDays[] = $this->getLeaveDays($employeeLeave->id, $startDate, $endDate, $leaveType);
        }

        return $leaveDays;
    }

    public function getEmployeeLeaveNoPay($employeeId, $startDate, $endDate, $getAll = false)
    {
        $employeeLeavesModel = new EmployeeLeave();
        /** @var array $employeeLeaves */
        $employeeLeaves = $employeeLeavesModel->Find('employee = ? and status = "Approved" and date_start <= ? and date_end >= ? and is_deleted <> 1', [
            $employeeId,
            $startDate,
            $endDate,
        ]);

        $leaveDays = [];
        foreach ($employeeLeaves as $employeeLeave) {
            $leaveType = $this->getLeaveType($employeeLeave->leave_type);

            if (empty($leaveType) || (empty($leaveType->pay) && empty($getAll))) {
                $leaveDays[] = $this->getLeaveDays($employeeLeave->id, $startDate, $endDate, $leaveType);
            }
            continue;
        }

        return $leaveDays;
    }

    public function getLeaveDays($employeeLeaveId, $startDate, $endDate, $leaveType = null)
    {
        $model = new EmployeeLeaveDay();
        $dates = $model->Find('employee_leave = ? and leave_date = ?', [
            $employeeLeaveId,
            $startDate,
        ]);
        $existedDates = [];

        foreach ($dates as $index => $date) {
            if ($date->leave_type == 'Full Day') {
                $existedDates[$date->leave_date] = empty($existedDates[$date->leave_date]) ? 0 : $existedDates[$date->leave_date];

                $period = 1 - $existedDates[$date->leave_date];

                $date->period = ($period > 0) ? $period : 0;
                $existedDates[$date->leave_date] += $period;
            } else {
                $existedDates[$date->leave_date] = empty($existedDates[$date->leave_date]) ? 0 : $existedDates[$date->leave_date];

                $period = 0.5 - $existedDates[$date->leave_date];

                $date->period = ($period > 0) ? $period : 0;
                $existedDates[$date->leave_date] += $period;
            }

            if (!empty($leaveType)) {
                $date->leaveTypeCode = $leaveType->code;
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
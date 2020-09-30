<?php


namespace Salary\Admin\Api;


use Attendance\Admin\Api\AttendanceUtil;
use Classes\CustomFieldManager;
use DateTime;
use Employees\Common\Model\Employee;
use Exception;
use Leaves\Admin\Api\EmployeeLeaveUtil;
use Leaves\Common\Model\EmployeeLeave;
use Leaves\Common\Model\EmployeeLeaveDay;
use Leaves\Common\Model\LeaveType;
use Overtime\Admin\Api\OvertimePayrollUtils;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\EmployeeSalaryBonus;
use Salary\Common\Model\EmployeeSalaryDeposit;
use Salary\Common\Model\EmployeeSalaryOvertime;

/**
 * Class SalaryUtil
 * @package Salary\Admin\Api
 */
class SalaryUtil
{
    /**
     * @param $employeeId
     * @param null $from
     * @param null $to
     * @param array $components
     * @param bool $getOne
     * @return mixed
     * @throws Exception
     */
    public static function getEmployeeSalaries(
        $employeeId,
        $from = null,
        $to = null,
        $components = [],
        $getOne = false
    )
    {
        $model = new EmployeeSalary();
        $query = 'employee = ?';
        $queryParams = ['employee' => $employeeId];

        if (!empty($components)) {
            $query .= ' AND component IN (?)';
            $queryParams['component'] = implode(',', $components);
        }

        /** @var array $empSalaries */
        $empSalaries = $model->Find($query, $queryParams);

        /** @var EmployeeSalary $empSalary */
        foreach ($empSalaries as $index => $empSalary) {
            $empSalaries[$index] = $empSalary->postProcessGetData($empSalary);
        }

        $now = new DateTime();

        /*if (!empty($from)) {
            $empSalaries = array_filter($empSalaries, function ($empSalary) use ($from) {
                if (empty($empSalary->start_date)) {
                    return true;
                }
                $startDateObj = DateTime::createFromFormat('Y-m-d', $empSalary->start_date);
                $fromObj = DateTime::createFromFormat('Y-m-d', $from);

                return $startDateObj >= $fromObj;
            });
        }*/

        if (!empty($to)) {
            $empSalaries = array_filter($empSalaries, function ($empSalary) use ($to) {
                if (empty($empSalary->start_date)) {
                    return true;
                }

                $startDateObj = DateTime::createFromFormat('Y-m-d', $empSalary->start_date);
                $toObj = DateTime::createFromFormat('Y-m-d', $to);

                return $startDateObj <= $toObj;
            });
        }

        $empSalaries = array_filter($empSalaries, function ($empSalary) use ($now) {
            if (empty($empSalary->start_date)) {
                return true;
            }

            $startDate = DateTime::createFromFormat('Y-m-d', $empSalary->start_date);
            return ($now >= $startDate || ($empSalary->start_date == 'NULL'));
        });

        /** @var EmployeeSalary $a */
        /** @var EmployeeSalary $b */
        usort($empSalaries, function ($a, $b) {
            if ((empty($a->start_date) && empty($b->start_date)) || $a->start_date == $b->start_date) {
                return 0;
            }

            if (empty($a->start_date) || $a->start_date < $b->start_date) {
                return -1;
            }

            if (empty($b->start_date) || $a->start_date > $b->start_date) {
                return 1;
            }
        });

        if ($getOne) {
            return array_pop($empSalaries);
        }

        return $empSalaries;
    }

    private function getStartDate($employeeId)
    {
        $customFieldManager = new CustomFieldManager();
        $startDate = $customFieldManager->getCustomFields('EmployeeSalary', $employeeId);

        if (empty($startDate)) {
            return null;
        }

        return array_shift($startDate);
    }

    public function getBaseSalary($employeeId, $startDate, $endDate, $salaryComponents = "")
    {
        $salaryComponents = $this->parseSalaryComponent($salaryComponents);

        $empSalaries = self::getEmployeeSalaries($employeeId, $startDate, $endDate, $salaryComponents);

        if (!empty($empSalaries)) {
            $baseSalary = array_pop($empSalaries);

            return round($baseSalary->amount);
        }

        return 0;
    }

    public function getRealSalary($employeeId, $startDate, $endDate, $salaryComponents = "", $responseArray = false)
    {
        $startDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $startDate . " 00:00:00");
        $endDateObj = DateTime::createFromFormat('Y-m-d H:i:s', $endDate . " 23:59:59");
        $salaryComponents = $this->parseSalaryComponent($salaryComponents);
        $totalWorkingDays = AttendanceUtil::getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $totalRealSalary = 0;
        $totalAtSum = 0;
        $data = [];

        while ($startDateObj <= $endDateObj) {
            $dayOfWeek = $startDateObj->format('w');

            if ($totalAtSum >= $totalWorkingDays) {
                break;
            }

            $isFullWorkingDay = AttendanceUtil::isFullWorkingDay($employeeId, $startDateObj);

            if (!$isFullWorkingDay) {
                /** @var array $atts */
                $atts = AttendanceUtil::getAttendancesData($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
                $employeeLeaveDays = $this->getEmployeeLeave($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));
                $holidays = EmployeeLeaveUtil::getHolidays($startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));

                if (empty($atts) && empty($employeeLeaveDays) && empty($holidays)) {
                    $startDateObj->add(\DateInterval::createFromDateString('1 day'));
                    continue;
                }

                $atSum = 0;

                if (!empty($atts)) {
                    $att = array_shift($atts);
                    $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $att->in_time);
                    $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $att->out_time);
                    $atSum = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employeeId);
                }

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
            } else {
                $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $startDateObj->format('Y-m-d') . " 09:00:00");
                $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $startDateObj->format('Y-m-d') . " 17:00:00");

                if ($dayOfWeek >= 1 && $dayOfWeek < 6) {
                    $atSum = 1;
                } elseif ($dayOfWeek == 6) {
                    $atSum = 0.5;
                } else {
                    $atSum = 0;
                }
            }

            $totalAtSum += $atSum;

            $empSalary = self::getEmployeeSalaries($employeeId, $startDate, $startDateObj->format('Y-m-d'),
                $salaryComponents, true);
            $baseSalary = ((int)$empSalary->amount / (float)$totalWorkingDays) * (float)$atSum;
            $totalRealSalary += $baseSalary;

            $data[] = [
                'date' => $startDateObj->format('Y-m-d'),
                'checkIn' => $checkIn ? $checkIn->format('Y-m-d Y:i:s') : '',
                'checkOut' => $checkOut ? $checkOut->format('Y-m-d Y:i:s') : '',
                'salaryComponents' => implode(',', $salaryComponents),
                'totalWorkingDays' => $totalWorkingDays,
                'atSum' => $atSum,
                'empSalary' => $empSalary->amount,
                'baseSalary' => $baseSalary,
            ];

            $startDateObj->add(\DateInterval::createFromDateString('1 day'));
        }

        if ($responseArray) {
            return $data;
        }

        return round($totalRealSalary);
    }

    private function getEmployeeLeave($employeeId, $startDate, $endDate)
    {
        $employeeLeavesModel = new EmployeeLeave();
        /** @var array $employeeLeaves */
        $employeeLeaves = $employeeLeavesModel->Find('employee = ? and status = "Approved" and date_start <= ? and date_end >= ?', [
            $employeeId,
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

    private function getLeaveDays($employeeLeaveId, $startDate, $endDate)
    {
        $model = new EmployeeLeaveDay();
        $dates = $model->Find('employee_leave = ? and (leave_date = ? or leave_date = ?)', [
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

    private function getLeaveType($id)
    {
        $model = new LeaveType();
        /** @var array $obj */
        $obj = $model->Find('id = ?', [$id]);
        return array_shift($obj);
    }

    public function getSalaryDeposit($employeeId, $startDate, $endDate, $salaryComponents = "", $toArray = false)
    {
        $totalSalaryDeposit = 0;

        $model = new EmployeeSalaryDeposit();
        $deposits = $model->Find('employee = ? AND date >= ? AND date <= ?', [
            $employeeId,
            $startDate,
            $endDate,
        ]);

        $data = [];
        foreach ($deposits as $deposit) {
            $data[] = $deposit;
            $totalSalaryDeposit += round($deposit->amount);
        }

        if (!empty($toArray)) {
            return $data;
        }

        return round($totalSalaryDeposit);
    }

    public function getSalaryBonus($employeeId, $startDate, $endDate, $salaryComponents = "", $toArray = false)
    {
        $totalSalaryBonus = 0;

        $model = new EmployeeSalaryBonus();
        $bonuses = $model->Find('employee = ? AND date >= ? AND date <= ?', [
            $employeeId,
            $startDate,
            $endDate,
        ]);

        $data = [];
        foreach ($bonuses as $bonus) {
            $data[] = $bonus;
            $totalSalaryBonus += round($bonus->amount);
        }

        if (!empty($toArray)) {
            return $data;
        }

        return round($totalSalaryBonus);
    }

    public function getSalaryOvertime($employeeId, $startDate, $endDate, $salaryComponents = "", $toArray = false)
    {
        $totalSalaryOvertime = 0;

        $model = new EmployeeSalaryOvertime();
        $overtime = $model->Find('employee = ? AND date >= ? AND date <= ?', [
            $employeeId,
            $startDate,
            $endDate,
        ]);

        $data = [];
        foreach ($overtime as $item) {
            $data[] = $item;
            $totalSalaryOvertime += round($item->amount);
        }

        if (!empty($toArray)) {
            return $data;
        }

        return round($totalSalaryOvertime);
    }

    /**
     * @param $salaryComponents
     * @return array|mixed
     */
    public function parseSalaryComponent($salaryComponents)
    {
        if (!empty($salaryComponents) && !empty(json_decode($salaryComponents, true))) {
            $salaryComponents = json_decode($salaryComponents, true);
        } else {
            $salaryComponents = [];
        }
        return $salaryComponents;
    }
}

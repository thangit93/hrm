<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/13/17
 * Time: 8:07 AM
 */

namespace Attendance\Admin\Api;

use Attendance\Common\Model\Attendance;
use Classes\SettingsManager;
use DateTime;
use Employees\Common\Model\Employee;
use Utils\LogManager;

class AttendanceUtil
{
    /**
     * @param $employeeId
     * @param $startDate
     * @param $endDate
     * @return bool
     */
    public static function getAttendancesData($employeeId, $startDate, $endDate)
    {
        $startTime = $startDate . " 00:00:00";
        $endTime = $endDate . " 23:59:59";
        $attendance = new Attendance();
        return $attendance->Find(
            "employee = ? and in_time >= ? and out_time <= ?",
            array($employeeId, $startTime, $endTime)
        );
    }

    public function getAttendanceSummary($employeeId, $startDate, $endDate)
    {
        $atts = self::getAttendancesData($employeeId, $startDate, $endDate);

        $atCalClassName = SettingsManager::getInstance()->getSetting('Attendance: Overtime Calculation Class');
        $atCalClassName = '\\Attendance\\Common\\Calculations\\' . $atCalClassName;
        $atCal = new $atCalClassName();
        $atSum = $atCal->getDataSeconds($atts, $startDate, true);

        return $atSum;
    }

    public function getTimeWorkedHours($employeeId, $startDate, $endDate)
    {
        $atSum = $this->getAttendanceSummary($employeeId, $startDate, $endDate);
        return round(($atSum['t'] / 60) / 60, 2);
    }

    /**
     * @param string|null $checkIn
     * @param string|null $checkOut
     * @param null $employeeId
     * @return int
     */
    public static function calculateWorkingDay($checkIn, $checkOut, $employeeId = null)
    {
        if (empty($checkIn) || empty($checkOut)) {
            return 0;
        }

        $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $checkIn);
        $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $checkOut);

        /** @var DateTime $timeStart */
        $timeStart = clone $checkIn;
        $timeStart->setTime(9, 0, 0);

        /** @var DateTime $timeEnd */
        $timeEnd = clone $checkOut;
        $timeEnd->setTime(17, 0, 0);

        if ($employeeId == 919) {
            $debug = true;
        }

        if (!empty($employeeId) && self::isFullWorkingDay($employeeId, $checkIn)) {
            $checkIn = $timeStart;
            $checkOut = $timeEnd;
        }

        //start after 09:00 and left after 17:00
        if ($timeStart < $checkIn && $timeEnd <= $checkOut) {
            return 0.5;
        }

        //start before 09:00 and left after 17:00
        if ($timeStart > $checkIn && $timeEnd <= $checkOut) {
            $dayOfWeek = $checkIn->format('w');

            if ($dayOfWeek >= 1 && $dayOfWeek < 6) {
                return 1;
            }

            return 0.5;
        }

        //start before 09:00 and left before 17:00
        if ($timeStart > $checkIn && $timeEnd > $checkOut) {
            return 0.5;
        }

        return 0;
    }

    public static function isFullWorkingDay($employeeId, $date)
    {
        $model = new Employee();
        $employee = $model->Find('id = ?', ['id' => $employeeId]);
        $employee = array_shift($employee);
        $employee = $model->postProcessGetData($employee);

        if (!empty($employee->full_working_days)) {
            $fullWorkingDayFrom = DateTime::createFromFormat('Y-m-d', $employee->full_working_days);
            $fullWorkingDayFrom->setTime(0, 0, 0);

            if ($date >= $fullWorkingDayFrom) {
                return true;
            }
        }

        return false;
    }

    public function getDaysWorked($employeeId, $startDate, $endDate)
    {
        $totalWorkingDays = $this->getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $startDate = DateTime::createFromFormat('Y-m-d H:i:s', $startDate . " 00:00:00");
        $endDate = DateTime::createFromFormat('Y-m-d H:i:s', $endDate . " 23:59:59");

        $atSum = 0;

        while ($startDate <= $endDate) {
            if (self::isFullWorkingDay($employeeId, $startDate)) {
                $atSum += 1;
            } else {
                /** @var array $atts */
                $atts = self::getAttendancesData($employeeId, $startDate->format('Y-m-d'), $startDate->format('Y-m-d'));

                foreach ($atts as $att) {
                    $atSum += AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employeeId);
                }
            }

            $startDate->add(\DateInterval::createFromDateString('1 days'));
        }

        return ($atSum > $totalWorkingDays) ? $totalWorkingDays : $atSum;
    }

    public function getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate)
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

            LogManager::getInstance()->info("Date: " . $startTime->format('w, Y-m-d'));

            $startTime->add(\DateInterval::createFromDateString('1 day'));
        }

        return $totalDays;
    }

    public function getRegularWorkedHours($employeeId, $startDate, $endDate)
    {
        $atSum = $this->getAttendanceSummary($employeeId, $startDate, $endDate);
        return round(($atSum['r'] / 60) / 60, 2);
    }

    public function getOverTimeWorkedHours($employeeId, $startDate, $endDate)
    {
        $atSum = $this->getAttendanceSummary($employeeId, $startDate, $endDate);
        return round(($atSum['o'] / 60) / 60, 2);
    }

    public function getWeeklyBasedRegularHours($employeeId, $startDate, $endDate)
    {
        $atSum = $this->getWeeklyBasedOvertimeSummary($employeeId, $startDate, $endDate);
        return round(($atSum['r'] / 60) / 60, 2);
    }

    public function getWeeklyBasedOvertimeHours($employeeId, $startDate, $endDate)
    {
        $atSum = $this->getWeeklyBasedOvertimeSummary($employeeId, $startDate, $endDate);
        return round(($atSum['o'] / 60) / 60, 2);
    }

    public function getWeeklyBasedOvertimeSummary($employeeId, $startDate, $endDate)
    {

        $attendance = new Attendance();
        $atTimeByWeek = array();

        //Find weeks starting from sunday and ending from saturday in day period

        $weeks = $this->getWeeklyDays($startDate, $endDate);
        foreach ($weeks as $k => $week) {
            $startTime = $week[0] . " 00:00:00";
            $endTime = $week[count($week) - 1] . " 23:59:59";
            $atts = $attendance->Find(
                "employee = ? and in_time >= ? and out_time <= ?",
                array($employeeId, $startTime, $endTime)
            );
            foreach ($atts as $atEntry) {
                if ($atEntry->out_time == "0000-00-00 00:00:00" || empty($atEntry->out_time)) {
                    continue;
                }
                if (!isset($atTimeByWeek[$k])) {
                    $atTimeByWeek[$k] = 0;
                }

                $diff = strtotime($atEntry->out_time) - strtotime($atEntry->in_time);
                if ($diff < 0) {
                    $diff = 0;
                }

                $atTimeByWeek[$k] += $diff;
            }
        }

        $overtimeStarts = SettingsManager::getInstance()->getSetting('Attendance: Overtime Start Hour');
        $overtimeStarts = (is_numeric($overtimeStarts)) ? floatval($overtimeStarts) * 60 * 60 * 5 : 0;
        $regTime = 0;
        $overTime = 0;
        foreach ($atTimeByWeek as $value) {
            if ($value > $overtimeStarts) {
                $regTime += $overtimeStarts;
                $overTime = $value - $overtimeStarts;
            } else {
                $regTime += $value;
            }
        }

        return array('r' => $regTime, 'o' => $overTime);
    }

    private function getWeeklyDays($startDate, $endDate)
    {
        $start = new \DateTime($startDate);
        $end = new \DateTime($endDate . ' 23:59');
        $interval = new \DateInterval('P1D');
        $dateRange = new \DatePeriod($start, $interval, $end);

        $weekNumber = 1;
        $weeks = array();
        /* @var \DateTime $date */
        foreach ($dateRange as $date) {
            $weeks[$weekNumber][] = $date->format('Y-m-d');
            if ($date->format('w') == 6) {
                $weekNumber++;
            }
        }

        return $weeks;
    }
}

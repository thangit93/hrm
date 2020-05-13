<?php


namespace Salary\Admin\Api;


use Attendance\Admin\Api\AttendanceUtil;
use Classes\CustomFieldManager;
use DateTime;
use Employees\Common\Model\Employee;
use Exception;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\EmployeeSalaryDeposit;

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

        if (!empty($from)) {
            $empSalaries = array_filter($empSalaries, function ($empSalary) use ($from) {
                return empty($empSalary->start_date) || $empSalary->start_date >= $from;
            });
        }

        if (!empty($to)) {
            $empSalaries = array_filter($empSalaries, function ($empSalary) use ($to) {
                return empty($empSalary->start_date) || $empSalary->start_date <= $to;
            });
        }

        $empSalaries = array_filter($empSalaries, function ($empSalary) use ($now) {
            $startDate = DateTime::createFromFormat('Y-m-d', $empSalary->start_date);
            return ($now >= $startDate || empty($empSalary->start_date) || ($empSalary->start_date == 'NULL'));
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

            return $baseSalary->amount;
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
        $data = [];

        while ($startDateObj <= $endDateObj) {
            $isFullWorkingDay = AttendanceUtil::isFullWorkingDay($employeeId, $startDateObj);

            if (!$isFullWorkingDay) {
                /** @var array $atts */
                $atts = AttendanceUtil::getAttendancesData($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'));

                if (empty($atts)) {
                    $startDateObj->add(\DateInterval::createFromDateString('1 day'));
                    continue;
                }

                $att = array_shift($atts);
                $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $att->in_time);
                $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $att->out_time);
                $atSum = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employeeId);
            } else {
                $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $startDateObj->format('Y-m-d') . " 09:00:00");
                $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $startDateObj->format('Y-m-d') . " 17:00:00");
                $atSum = 1;
            }

            $empSalary = self::getEmployeeSalaries($employeeId, $startDateObj->format('Y-m-d'), $startDateObj->format('Y-m-d'),
                $salaryComponents, true);
            $baseSalary = ((int)$empSalary->amount / (float)$totalWorkingDays) * (float)$atSum;
            $totalRealSalary += $baseSalary;

            $data[] = [
                'date' => $startDateObj->format('Y-m-d'),
                'checkIn' => $checkIn->format('Y-m-d Y:i:s'),
                'checkOut' => $checkOut->format('Y-m-d Y:i:s'),
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

        return (int)$totalRealSalary;
    }

    public function getSalaryDeposit($employeeId, $startDate, $endDate, $toArray = false)
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
            $totalSalaryDeposit += (int)$deposit->amount;
        }

        if (!empty($toArray)) {
            return $data;
        }

        return $totalSalaryDeposit;
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

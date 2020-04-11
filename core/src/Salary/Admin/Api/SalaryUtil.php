<?php


namespace Salary\Admin\Api;


use Attendance\Admin\Api\AttendanceUtil;
use Classes\CustomFieldManager;
use DateTime;
use Exception;
use Salary\Common\Model\EmployeeSalary;

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
    private static function getEmployeeSalaries(
        $employeeId,
        $from = null,
        $to = null,
        $components = [],
        $getOne = false
    ) {
        $model = new EmployeeSalary();
        $query = 'employee = ?';
        $queryParams = ['employee' => $employeeId];

        if (!empty($components)) {
            $query .= ' AND component IN (?)';
            $queryParams['component'] = implode(',', $components);
        }

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

    public function getRealSalary($employeeId, $startDate, $endDate, $salaryComponents = "")
    {
        $salaryComponents = $this->parseSalaryComponent($salaryComponents);
        /** @var array $atts */
        $atts = AttendanceUtil::getAttendancesData($employeeId, $startDate, $endDate);
        $totalWorkingDays = AttendanceUtil::getTotalWorkingDaysInMonth($employeeId, $startDate, $endDate);
        $totalRealSalary = 0;
//        $data = [];

        foreach ($atts as $att) {
            $checkIn = DateTime::createFromFormat('Y-m-d H:i:s', $att->in_time);
            $checkOut = DateTime::createFromFormat('Y-m-d H:i:s', $att->out_time);
            $atSum = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time);
            $empSalary = self::getEmployeeSalaries($employeeId, $startDate, $checkOut->format('Y-m-d'),
                $salaryComponents, true);
            /*$itemData = [
                'checkIn' => $att->in_time,
                'checkOut' => $att->out_time,
                'salaryComponents' => implode(',', $salaryComponents),
                'totalWorkingDays' => $totalWorkingDays,
                'atSum' => $atSum,
                'empSalary' => $empSalary->amount,
            ];*/

            $baseSalary = ((int)$empSalary->amount / (float)$totalWorkingDays) * (float)$atSum;
            $totalRealSalary += $baseSalary;
//            $itemData['baseSalary'] = $baseSalary;

//            $data[] = $itemData;
        }

        return $totalRealSalary;
    }

    /**
     * @param $salaryComponents
     * @return array|mixed
     */
    private function parseSalaryComponent($salaryComponents)
    {
        if (!empty($salaryComponents) && !empty(json_decode($salaryComponents, true))) {
            $salaryComponents = json_decode($salaryComponents, true);
        } else {
            $salaryComponents = [];
        }
        return $salaryComponents;
    }
}

<?php

namespace Data\Admin\Import;

use Attendance\Admin\Api\AttendanceUtil;
use Attendance\Common\Model\Attendance;
use Classes\BaseService;
use Data\Admin\Api\AbstractDataImporter;
use DateInterval;
use DateTime;
use DateTimeZone;
use Employees\Common\Model\Employee;
use Exception;
use Model\BaseModel;
use Utils\LogManager;

class AttendanceDataImporter extends AbstractDataImporter
{

    protected $processed = array();

    public function getModelObject()
    {
        return "\\Attendance\\Common\\Model\\Attendance";
    }

    public function fixBeforeSave($object, $data)
    {
        return $object;
    }

    public function isDuplicate($obj)
    {
        $old = new Attendance();
        $query = "employee = ? ";
        $queryData = [$obj->employee];

        if (!empty($obj->in_time)) {
            $query .= " and in_time = ? ";
            $queryData[] = $obj->in_time;
        }

        if (!empty($obj->out_time)) {
            $query .= " and out_time = ? ";
            $queryData[] = $obj->out_time;
        }

        $data = $old->Find(
            $query,
            $queryData
        );

        if (count($data) > 0) {
            return true;
        }

        return false;
    }

    public function process($data, $dataImportId)
    {
        $data = str_replace("\r", "\n", $data);
        $data = str_replace("\n\n", "\n", $data);

        $lines = str_getcsv($data, "\n");

        //remove unused line
        unset($lines[0]);

        $headerProcessed = false;

        $counter = 0;

        LogManager::getInstance()->info("Line Count: " . count($lines));

        $res = array();

        $lineMonth = array_shift($lines);
        $cells = str_getcsv($lineMonth, ",");
        $month = array_shift($cells);
        preg_match('/([\d]{2})\/([\d]{4})/', $month, $matches);
        list($full, $month, $year) = $matches;

        //remove unused lines
        array_shift($lines);
        array_shift($lines);
        array_shift($lines);

        $attendances = [];

        foreach ($lines as $line) {
            //init start/end date of the month
            $startDate = $this->getStartDate($year, $month);
            $endDate = $this->getEndDate($year, $month);

            //check diff days
            $diff = $startDate->diff($endDate);

            $cells = str_getcsv($line, ",");
            $employeeId = $cells[1];

            if (empty($employeeId)) {
                continue;
            }

            LogManager::getInstance()->info("Employee ID: " . $employeeId);

            //search employee by employee_id
            $employee = new Employee();
            $employee->Load("employee_id = ?", ['employee_id' => $employeeId]);

            if (empty($employee->employee_id)) {
                continue;
            }

            //first check in/out column in file
            $column = 3;
            $days = $diff->days;

            //loop from start date to end date
            while ($days > 0) {
                LogManager::getInstance()->info("[{$employee->id}] Date: " . $startDate->format('Y-m-d'));

                //create new attendance item
                $attendance = [
                    'employee' => $employee->id,
                    'in_time' => null,
                    'out_time' => null,
                ];
                //get check in/out time from file
                $checkInTime = $cells[$column];
                $checkOutTime = $cells[$column + 1];

                if (!empty($checkInTime) || !empty($checkOutTime)) {

                    //create check in time if not empty
                    if (!empty($checkInTime)) {
                        $checkInTime = DateTime::createFromFormat('Y-m-d H:i:s', $checkInTime);
                        $attendance['in_time'] = $startDate->setTime($checkInTime->format('H'), $checkInTime->format('i'), 0)->format('Y-m-d H:i:s');
                    }

                    //create check out time if not empty
                    if (!empty($checkOutTime)) {
                        $checkOutTime = DateTime::createFromFormat('Y-m-d H:i:s', $checkOutTime);
                        $attendance['out_time'] = $startDate->setTime($checkOutTime->format('H'), $checkOutTime->format('i'), 0)->format('Y-m-d H:i:s');
                    }

                    $workingDay = AttendanceUtil::calculateWorkingDay($attendance['in_time'], $attendance['out_time']);
                    $attendance['note'] = $workingDay;
                    $attendances[] = $attendance;
                }

                //increase to next day
                $column += 2;
                $startDate = $startDate->add(DateInterval::createFromDateString('1 day'));
                $days--;
            }

            $res[] = array($cells, ['imported']);

            $counter++;
        }

        foreach ($attendances as $attendance) {
            //if duplicated data, ignore
            $obj = new Attendance();

            foreach ($attendance as $key => $value) {
                $obj->$key = $value;
            }

            if ($this->isDuplicate($obj)) {
                continue;
            }

            $obj->Save();
        }

        return $res;
    }

    /**
     * @param $year
     * @param $month
     * @return DateTime
     * @throws Exception
     */
    private function getStartDate($year, $month)
    {
        $startDate = new DateTime('now', new DateTimeZone('Asia/Ho_Chi_Minh'));
        $startDate->setDate($year, $month, 26);
        $startDate->setTime(00, 00, 00);
        $startDate->sub(DateInterval::createFromDateString('1 month'));

        return $startDate;
    }

    /**
     * @param $year
     * @param $month
     * @return DateTime
     * @throws Exception
     */
    private function getEndDate($year, $month)
    {
        $endDate = new DateTime('now', new DateTimeZone('Asia/Ho_Chi_Minh'));
        $endDate->setDate($year, $month, 26);
        $endDate->setTime(0, 0, 0);
//        $endDate->add(DateInterval::createFromDateString('1 month'));

        return $endDate;
    }
}

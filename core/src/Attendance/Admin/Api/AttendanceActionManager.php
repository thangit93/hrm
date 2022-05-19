<?php
/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

namespace Attendance\Admin\Api;

use Attendance\Common\Model\Attendance;
use Classes\BaseService;
use Classes\IceResponse;
use Classes\LanguageManager;
use Classes\SubActionManager;
use Data\Admin\Import\AttendanceDataImporter;
use DateTime;
use Employees\Common\Model\Employee;
use Utils\LogManager;

class AttendanceActionManager extends SubActionManager
{

    public function savePunch($req)
    {
        $employee = $this->baseService->getElement('Employee', $req->employee, null, true);
        $outDate = $inDate = $req->date;
        $inDateTime = $req->in_time;
        $outDateTime = $req->out_time;
        $workingDay = 0;

        $helper = new AttendanceDataImporter();
        $helper->clearOldData($inDate, $employee->id);

        if (empty($inDateTime) && empty($outDateTime)) {
            return new IceResponse(IceResponse::SUCCESS);
        }

        $inDateTime = !empty($inDateTime) ? "{$inDate} {$inDateTime}:00" : "";
        $outDateTime = !empty($outDateTime) ? "{$outDate} {$outDateTime}:00" : "";

        if (!empty($inDateTime) && !empty($outDateTime)) {
            $workingDay = AttendanceUtil::calculateWorkingDay($inDateTime, $outDateTime);
        }

        $note = $workingDay;

        //check if dates are differnet
        if (!empty($outDate) && $inDate != $outDate) {
            return new IceResponse(
                IceResponse::ERROR,
                LanguageManager::tran('Attendance entry should be within a single day')
            );
        }

        //compare dates
        if (!empty($outDateTime) && strtotime($outDateTime) <= strtotime($inDateTime)) {
            return new IceResponse(IceResponse::ERROR, 'Punch-in time should be lesser than Punch-out time');
        }

        //Find all punches for the day
        $attendance = new Attendance();
        $attendanceList = $attendance->Find(
            "employee = ? and DATE_FORMAT( in_time,  '%Y-%m-%d' ) = ?",
            array($employee->id, $inDate)
        );

        foreach ($attendanceList as $attendance) {
            if (!empty($req->id) && $req->id == $attendance->id) {
                continue;
            }
            if (empty($attendance->out_time) || $attendance->out_time == "0000-00-00 00:00:00") {
                return new IceResponse(
                    IceResponse::ERROR,
                    "There is a non closed attendance entry for today. 
                    Please mark punch-out time of the open entry before adding a new one"
                );
            } elseif (!empty($outDateTime)) {
                if (strtotime($attendance->out_time) >= strtotime($outDateTime)
                    && strtotime($attendance->in_time) <= strtotime($outDateTime)) {
                    //-1---0---1---0 || ---0--1---1---0
                    return new IceResponse(IceResponse::ERROR, "Time entry is overlapping with an existing one");
                } elseif (strtotime($attendance->out_time) >= strtotime($inDateTime)
                    && strtotime($attendance->in_time) <= strtotime($inDateTime)) {
                    //---0---1---0---1 || ---0--1---1---0
                    return new IceResponse(IceResponse::ERROR, "Time entry is overlapping with an existing one");
                } elseif (strtotime($attendance->out_time) <= strtotime($outDateTime)
                    && strtotime($attendance->in_time) >= strtotime($inDateTime)) {
                    //--1--0---0--1--
                    return new IceResponse(IceResponse::ERROR, "Time entry is overlapping with an existing one");
                }
            } else {
                if (strtotime($attendance->out_time) >= strtotime($inDateTime)
                    && strtotime($attendance->in_time) <= strtotime($inDateTime)) {
                    //---0---1---0
                    return new IceResponse(IceResponse::ERROR, "Time entry is overlapping with an existing one");
                }
            }
        }

        $attendance = new Attendance();
        if (!empty($req->id)) {
            $attendance->Load("id = ?", array($req->id));
        }
        $attendance->in_time = !empty($inDateTime) ? $inDateTime : null;
        if (empty($outDateTime)) {
            $attendance->out_time = null;
        } else {
            $attendance->out_time = $outDateTime;
        }

        $attendance->employee = $req->employee;
        // Nhân viên kinh doanh, tính full lương
        if ($employee->job_title == 64 && (!empty($req->in_time) || !empty($req->out_time))) {
            $note = 1;
            $date = \DateTime::createFromFormat('Y-m-d', $req->date);
            if ($date->format('w') == 6) {
                $note = 0.5;
            }
        } 
        $attendance->note = $note;
        $ok = $attendance->Save();
        if (!$ok) {
            LogManager::getInstance()->info($attendance->ErrorMsg());
            return new IceResponse(IceResponse::ERROR, "Error occurred while saving attendance");
        }
        return new IceResponse(IceResponse::SUCCESS, $attendance);
    }

    public function getImages($req)
    {
        $attendance = BaseService::getInstance()->getElement(
            'Attendance',
            $req->id,
            '{"employee":["Employee","id","first_name+last_name"]}'
        );
        return new IceResponse(IceResponse::SUCCESS, $attendance);
    }

    public function getAttendanceReport($req)
    {
        $filterStr = $req->ft ?? null;
        $employeeId = null;
        $month = null;

        if (!empty($filterStr)) {
            $filter = json_decode($filterStr, true);
            $employeeId = !empty($filter['employee']) ? $filter['employee'] : null;
            $month = !empty($filter['in_time']) ? $filter['in_time'] : null;
        }

        if (empty($month)) {
            $month = new \DateTime();
        } else {
            $month = \DateTime::createFromFormat('Y-m', "{$month}");
        }

        $endDate = clone $month;
        $endDate->setDate($endDate->format('Y'), $endDate->format('m'), 25);

        $empModel = new Employee();
        $empQuery = '1 = 1 AND status = "Active"';
        $empQueryData = [];

        $attModel = new Attendance();

        if (!empty($employeeId)) {
            $empQuery .= " AND id = ?";
            $empQueryData[] = $employeeId;
        }

        $employees = $empModel->Find($empQuery, $empQueryData);

        $data = [];
        $dataHeader = [];
        $currentMonth = (int) $endDate->format('m');
        $startDate = (clone $endDate);
        $startDate->setDate($startDate->format('Y'), $currentMonth - 1, 26);
        while ($startDate <= $endDate) {
            $dataHeader[] = $startDate->format('Y-m-d');
            $startDate->add(\DateInterval::createFromDateString('1 day'));
        }

        $dataHeader[] = LanguageManager::tran('Total');

        foreach ($employees as $employee) {
            $startDate = (clone $endDate);
            $startDate->setDate($startDate->format('Y'), $currentMonth - 1, 26);
            $total = 0;

            while ($startDate <= $endDate) {
                $query = "((DATE_FORMAT(in_time, '%Y-%m-%d') = \"{$startDate->format("Y-m-d")}\") OR (DATE_FORMAT(out_time, '%Y-%m-%d') = \"{$startDate->format("Y-m-d")}\")) AND employee = \"{$employee->id}\"";
                /** @var array $atts */
                $atts = $attModel->Find($query);

                $att = array_shift($atts);
                $employeeDob = "";

                if ($employee->birthday) {
                    $employeeDob = DateTime::createFromFormat("Y-m-d", $employee->birthday)->format('Y');
                }

                $dataDay = [];
                $dataDay['employee_id'] = $employee->id;
                $dataDay['name'] = "{$employee->first_name} {$employee->last_name} {$employeeDob}";
                $dataDay['date'] = $startDate->format('Y-m-d');
                $dataDay['total'] = 0;

                if (!empty($att)) {
                    $checkInTime = "";
                    $checkOutTime = "";

                    if (!empty($att->in_time)) {
                        $checkIn = \DateTime::createFromFormat('Y-m-d H:i:s', $att->in_time);
                        $checkInTime = $checkIn->format('H:i');
                    }

                    if ($att->out_time) {
                        $checkOut = \DateTime::createFromFormat('Y-m-d H:i:s', $att->out_time);
                        $checkOutTime = $checkOut->format('H:i');
                    }

                    $dataDay['in'] = $checkInTime;
                    $dataDay['out'] = $checkOutTime;

                    if (!empty($att->in_time) && !empty($att->out_time)) {
                        $dataDay['total'] = AttendanceUtil::calculateWorkingDay($att->in_time, $att->out_time, $employee->id);
                    }

                    // Nhân viên kinh doanh, tính full lương
                    if ($employee->job_title == 64 && (!empty($att->in_time) || !empty($att->out_time))) {
                        $dataDay['total'] = 1;
                        if ($startDate->format('w') == 6) {
                            $dataDay['total'] = 0.5;

                        }
                    }
                } else {
                    $dataDay = array_merge($dataDay, [
                        'in' => '',
                        'out' => '',
                    ]);
                }

                if (AttendanceUtil::isFullWorkingDay($employee->id, $startDate) && $employee->job_title != 64) {
                    $dataDay['total'] = AttendanceUtil::calculateWorkingDay($startDate->format('Y-m-d H:i:s'), $startDate->format('Y-m-d H:i:s'), $employee->id);
                }

                $data[$employee->id][] = $dataDay;
                $total += $dataDay['total'];

                $startDate->add(\DateInterval::createFromDateString('1 day'));
            }

            $data[$employee->id][] = $total;
        }

        $responseData = [
            'header' => $dataHeader,
            'data' => $data,
        ];

        return new IceResponse(IceResponse::SUCCESS, $responseData);
    }

    public function updateAttendance($req)
    {
        $employee = $this->baseService->getElement('Employee', $req->employee_id, null, true);
        $date = $req->date;
        $dateObject = \DateTime::createFromFormat('Y-m-d', $req->date);
        $fieldname = $req->fieldname;
        $employee_id = $req->employee_id;
        $in = $req->in;
        $out = $req->out;

        $attendance = new Attendance();
        $attendance->Load('1=1 AND employee = ? AND (DATE_FORMAT( in_time,  \'%Y-%m-%d\' ) = ? OR DATE_FORMAT( out_time,  \'%Y-%m-%d\' ) = ?)', [$employee_id, $date, $date]);

        if (empty($attendance->employee)) {
            $attendance->employee = $employee_id;
        }

        $oldTotal = AttendanceUtil::calculateWorkingDay($attendance->in_time, $attendance->out_time, $attendance->employee);
        if ($employee->job_title == 64 && (!empty($attendance->in_time) || !empty($attendance->out_time))) {
            $oldTotal = 1;
            if ($dateObject->format('w') == 6) {
                $oldTotal = 0.5;
            }
        } 
        if ($fieldname == "in") {
            if (!empty($in)) {
                $attendance->in_time = "{$date} {$in}:00";
            } else {
                $attendance->in_time = null;
            }
        } elseif ($fieldname == "out") {
            if (!empty($out)) {
                $attendance->out_time = "{$date} {$out}:00";
            } else {
                $attendance->out_time = null;
            }
        }

        $total = 0;

        if (empty($attendance->in_time) && empty($attendance->out_time)) {
            $attendance->Delete();

            return new IceResponse(IceResponse::SUCCESS, [
                'employee_id' => $attendance->employee,
                'in' => $in,
                'out' => $out,
                'date' => $date,
                'total' => $total,
                'oldTotal' => $oldTotal,
            ]);
        }

        if (!empty($attendance->in_time) && !empty($attendance->out_time)) {
            $total = AttendanceUtil::calculateWorkingDay($attendance->in_time, $attendance->out_time, $attendance->employee);
        }

        // Nhân viên kinh doanh, tính full lương
        if ($employee->job_title == 64 && (!empty($attendance->in_time) || !empty($attendance->out_time))) {
            $total = 1;
            if ($dateObject->format('w') == 6) {
                $total = 0.5;
            }
        }

        $attendance->note = $total;
        $attendance->Save();

        return new IceResponse(IceResponse::SUCCESS, [
            'employee_id' => $attendance->employee,
            'in' => $in,
            'out' => $out,
            'date' => $date,
            'total' => $total,
            'oldTotal' => $oldTotal,
        ]);
    }
}

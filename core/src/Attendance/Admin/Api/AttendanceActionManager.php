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
        $attendance->in_time = !empty($inDateTime)? $inDateTime : null;
        if (empty($outDateTime)) {
            $attendance->out_time = null;
        } else {
            $attendance->out_time = $outDateTime;
        }

        $attendance->employee = $req->employee;
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
}

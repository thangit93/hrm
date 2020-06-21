<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 3:17 PM
 */

namespace Overtime\Admin\Api;

use Classes\Approval\ApproveAdminActionManager;
use Classes\IceResponse;
use Employees\Common\Model\Employee;
use Overtime\Common\Model\EmployeeOvertime;
use Overtime\Common\Model\OvertimeCategory;

class OvertimeActionManager extends ApproveAdminActionManager
{

    public function getModelClass()
    {
        return "EmployeeOvertime";
    }

    public function getItemName()
    {
        return "Overtime Request";
    }

    public function getModuleName()
    {
        return "Overtime Management";
    }

    public function getModuleTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabEmployeeOvertime";
    }

    public function getModuleSubordinateTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabSubordinateEmployeeOvertime";
    }

    public function getModuleApprovalTabUrl()
    {
        return "g=modules&n=overtime&m=module_Time_Management#tabEmployeeOvertimeApproval";
    }

    public function getLogs($req)
    {
        return parent::getLogs($req);
    }

    public function changeStatus($req)
    {
        return parent::changeStatus($req);
    }

    public function getReportOvertime($req)
    {
        $filters = $req->ft;
        $mEmployeeOvertime = new EmployeeOvertime();
        if (empty($filters)) {
            $overtimes = $mEmployeeOvertime->Find('status = \'Approved\'');
        } else {
            $overtimes = $mEmployeeOvertime->Find('status = \'Approved\' '
                .'and date_format(start_time, \'%Y-%m\') >= \''.$filters->date_start.'\' and date_format(start_time, \'%Y-%m\') <= \''.$filters->date_start.'\'');
        }
        $result = [];
        $mEmployee = new Employee();
//        $mCategory = new OvertimeCategory();
        foreach ($overtimes as $overtime) {
            $employee = $mEmployee->Find('id = ?', [$overtime->employee]);
            $result[] = [
                'id' => $overtime->id,
                'startTime' => date('d/m/Y H:i:s', strtotime($overtime->start_time)),
                'endTime' => date('d/m/Y H:i:s', strtotime($overtime->end_time)),
                'name' => $employee[0]->first_name . ' ' . $employee[0]->last_name,
                'totalTime' => $overtime->total_time,
                'notes' => $overtime->notes,
            ];
        }

        return new IceResponse(IceResponse::SUCCESS, $result);
    }
}

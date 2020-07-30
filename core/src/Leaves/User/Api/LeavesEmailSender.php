<?php


namespace Leaves\User\Api;


use Classes\LanguageManager;
use Employees\Common\Model\Employee;
use Users\Common\Model\User;

class LeavesEmailSender
{
    var $emailSender = null;
    var $subActionManager = null;

    public function __construct($emailSender, $subActionManager){
        $this->emailSender = $emailSender;
        $this->subActionManager = $subActionManager;
    }

    private function getEmployeeSupervisor($employee){

        if(empty($employee->supervisor)){
            error_log("Employee supervisor is empty");
            return null;
        }

        $sup = new Employee();
        $sup->Load("id = ?",array($employee->supervisor));
        if($sup->id != $employee->supervisor){
            error_log("Employee supervisor not found");
            return null;
        }

        return $sup;
    }

    private function getEmployeeById($id){
        $sup = new Employee();
        $sup->Load("id = ?",array($id));
        if($sup->id != $id){
            error_log("Employee not found");
            return null;
        }

        return $sup;
    }

    public function getUserById($id)
    {
        $user = new User();
        $user->load('employee = ?', array($id));
        if($user->employee != $id){
            error_log("User not found");
            return null;
        }

        return $user;
    }

    public function sendLeaveApplicationEmail($employee){

        $sup = $this->getEmployeeSupervisor($employee);
        if(empty($sup)){
            return false;
        }

        $params = array();
        $params['supervisor'] = $sup->first_name." ".$sup->last_name;
        $params['name'] = $employee->first_name." ".$employee->last_name;
        $params['url'] = CLIENT_BASE_URL;

        $email = $this->subActionManager->getEmailTemplate('leaveApplied.html');

        $user = $this->subActionManager->getCurrentProfileId($sup->id);

        $emailTo = null;
        if(!empty($user)){
            $emailTo = $user->email;
        }

        if(!empty($emailTo)){
            if(!empty($this->emailSender)){
                $this->emailSender->sendEmail(LanguageManager::tran("Leave Application Received"),$emailTo,$email,$params);
            }
        }else{
            error_log("[sendLeaveApplicationEmail] email is empty");
        }

    }

    public function sendLeaveApplicationSubmittedEmail($employee){


        $params = array();
        $params['name'] = $employee->first_name." ".$employee->last_name;

        $email = $this->subActionManager->getEmailTemplate('leaveSubmittedForReview.html');

        $user = $this->subActionManager->getCurrentProfileId($employee->id);

        $emailTo = null;
        if(!empty($user)){
            $emailTo = $user->email;
        }

        if($employee->private_email != null) {
            $emailTo = $employee->private_email;
        }

        if(!empty($emailTo)){
            if(!empty($this->emailSender)){
                $this->emailSender->sendEmail(LanguageManager::tran("Leave Application Submitted"),$emailTo,$email,$params);
            }
        }else{
            error_log("[sendLeaveApplicationSubmittedEmail] email is empty");
        }
    }

    public function sendLeaveStatusChangedEmail($employee, $leave){

        $emp = $this->getEmployeeById($leave->employee);

        $params = array();
        $params['name'] = $emp->first_name." ".$emp->last_name;
        $params['startdate'] = date('d/m/Y', strtotime($leave->date_start));
        $params['enddate'] = date('d/m/Y', strtotime($leave->date_end));
        $params['status'] = LanguageManager::tran($leave->status);

        $email = $this->subActionManager->getEmailTemplate('leaveStatusChanged.html');

        $user = $this->getUserById($emp->id);

        $emailTo = null;
        if(!empty($user)){
            $emailTo = $user->email;
        }

        if ($emp->private_email != null) {
            $emailTo = $emp->private_email;
        }

        if(!empty($emailTo)){
            if(!empty($this->emailSender)){
                $this->emailSender->sendEmail(LanguageManager::tran('Leave Application') . " "
                    . LanguageManager::tran($leave->status),$emailTo,$email,$params);
            }
        }else{
            error_log("[sendLeaveStatusChangedEmail] email is empty");
        }
    }
}
<?php


namespace Payroll\Admin\Api;


use Classes\LanguageManager;
use Employees\Common\Model\Employee;

class PayslipEmailSender
{
    var $emailSender = null;
    var $subActionManager = null;

    public function __construct($emailSender, $subActionManager)
    {
        $this->emailSender = $emailSender;
        $this->subActionManager = $subActionManager;
    }

    private function getEmployeeById($id)
    {
        $sup = new Employee();
        $sup->Load("id = ?", array($id));
        if ($sup->id != $id) {
            error_log("Employee not found");
            return null;
        }

        return $sup;
    }

    public function sendPayslipEmail($employeeId, $payslip, $payroll)
    {
        $employee = $this->getEmployeeById($employeeId);

        if (empty($employee)) {
            return false;
        }

        $fileName = $payslip[0];
        $content = file_get_contents(CLIENT_BASE_PATH . 'data/' . $fileName);

        $emailTo = null;
        $params = [
//            'receiver_name' => "{$employee->first_name} {$employee->last_name}",
//            'link' => CLIENT_BASE_URL . "service.php?file={$payslip[0]}&a=download&source=payslip",
//            'payroll_name' => $payroll->name,
//            'date_start' => $payroll->date_start,
//            'date_end' => $payroll->date_end,
            'content' => $content
        ];

        if ($employee->private_email != null) {
            $emailTo = $employee->private_email;
        }

        $email = $this->subActionManager->getEmailTemplate('payslip.html');

        if (!empty($emailTo)) {
            if (!empty($this->emailSender)) {
                $this->emailSender->sendEmail($payroll->name, $emailTo, $email, $params);
            }
        }
    }
}
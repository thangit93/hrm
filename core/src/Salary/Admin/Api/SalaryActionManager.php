<?php


namespace Salary\Admin\Api;


use Classes\IceResponse;
use Classes\LanguageManager;
use Classes\SubActionManager;
use DateTime;
use Employees\Common\Model\Employee;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\EmployeeSalaryBonus;
use Salary\Common\Model\EmployeeSalaryOvertime;
use Salary\Common\Model\SalaryComponent;

class SalaryActionManager extends SubActionManager
{
    public function getEmployeeSalaryReport()
    {
        $empModel = new Employee();
        $empQuery = '1 = 1 AND status = "Active"';
        $empQueryData = [];

        $employees = $empModel->Find($empQuery, $empQueryData);

        $salaryComponentModel = new SalaryComponent();
        $salaryComponents = $salaryComponentModel->Find('1 = 1');

        $headers = [];

        foreach ($salaryComponents as $salaryComponent) {
            $headers[] = LanguageManager::tran($salaryComponent->name);
        }
        $headers[] = LanguageManager::tran('Thưởng');
        $headers[] = LanguageManager::tran('Lương OT');

        $data = [];
        foreach ($employees as $employee) {
            $row = [];

            $employeeDob = "";

            if ($employee->birthday) {
                $employeeDob = DateTime::createFromFormat("Y-m-d", $employee->birthday)->format('Y');
            }

            $row[] = "{$employee->first_name} {$employee->last_name} {$employeeDob}";
            foreach ($salaryComponents as $salaryComponent) {
                $empSalary = SalaryUtil::getEmployeeSalaries($employee->id, null, null, [$salaryComponent->id], true);

                $row[] = $empSalary->amount ? number_format($empSalary->amount) : 0;
            }
            $row[] = $this->getEmployeeSalaryBonus($employee->id);
            $row[] = $this->getEmployeeSalaryOvertime($employee->id);
            $data[] = $row;
        }

        return new IceResponse(IceResponse::SUCCESS, [
            'header' => $headers,
            'data' => $data,
        ]);
    }

    private function getSalaryComponent($name)
    {
        $model = new SalaryComponent();
        /** @var array $salaryComponents */
        $salaryComponents = $model->Find('name = ?', ['name' => $name]);

        if (empty($salaryComponents)) {
            return false;
        }

        return array_shift($salaryComponents);
    }

    private function getEmployeeSalaryOvertime($employee_id)
    {
        $now = new DateTime();
        $startDate = (clone $now)->setDate($now->format('Y'), $now->format('m'), 26);
        $startDate->sub(\DateInterval::createFromDateString('1 month'));
        $endDate = (clone $now)->setDate($now->format('Y'), $now->format('m'), 25);

        $model = new EmployeeSalaryOvertime();
        /** @var array $salaries */
        $salaries = $model->Find('1 = 1 AND employee = ? AND DATE_FORMAT(`date`, "%Y-%m-%d") >= ? AND DATE_FORMAT(`date`, "%Y-%m-%d") <= ? ORDER BY date DESC', [$employee_id, $startDate->format('Y-m-d'), $endDate->format('Y-m-d')]);

        if (empty($salaries)) {
            return 0;
        }

        return number_format((array_shift($salaries))->amount);
    }

    private function getEmployeeSalaryBonus($employee_id)
    {
        $now = new DateTime();
        $startDate = (clone $now)->setDate($now->format('Y'), $now->format('m'), 26);
        $startDate->sub(\DateInterval::createFromDateString('1 month'));
        $endDate = (clone $now)->setDate($now->format('Y'), $now->format('m'), 25);

        $model = new EmployeeSalaryBonus();
        /** @var array $salaries */
        $salaries = $model->Find('1 = 1 AND employee = ? AND DATE_FORMAT(`date`, "%Y-%m-%d") >= ? AND DATE_FORMAT(`date`, "%Y-%m-%d") <= ? ORDER BY date DESC', [$employee_id, $startDate->format('Y-m-d'), $endDate->format('Y-m-d')]);

        if (empty($salaries)) {
            return 0;
        }

        return number_format((array_shift($salaries))->amount);
    }
}
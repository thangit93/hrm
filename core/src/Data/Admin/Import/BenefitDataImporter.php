<?php


namespace Data\Admin\Import;


use Employees\Common\Model\Employee;
use Metadata\Common\Model\CustomFieldValue;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\EmployeeSalaryBonus;
use Salary\Common\Model\EmployeeSalaryOvertime;
use Salary\Common\Model\SalaryComponent;
use Utils\LogManager;

class BenefitDataImporter extends \Data\Admin\Api\AbstractDataImporter
{

    public function getModelObject()
    {
        return EmployeeSalary::class;
    }

    public function isDuplicate($obj)
    {
        return false;
    }

    public function fixBeforeSave($object, $data)
    {
        return $object;
    }

    public function process($data, $dataImportId)
    {
        $data = str_replace("\r", "\n", $data);
        $data = str_replace("\n\n", "\n", $data);

        $lines = str_getcsv($data, "\n");

        LogManager::getInstance()->info("Line Count: " . count($lines));

        $lineMonth = array_shift($lines);
        $cells = str_getcsv($lineMonth, ",");
        $month = array_shift($cells);
        preg_match('/([\d]{1,2})\/([\d]{1,2})\/([\d]{4})/', $month, $matches);
        list($full, $day, $month, $year) = $matches;
        $date = \DateTime::createFromFormat('Y-m-d', "{$year}-{$month}-{$day}");
        $header = array_shift($lines);
        list($empId, $name, $baseSalaryComponentName, $jobTitleComponentName, $lunchComponentName, $phoneComponentName, $parkingComponentName, $bonusName) = explode(',', $header);

        $baseSalaryComponent = $this->getSalaryComponent($baseSalaryComponentName);
        $jobTitleComponent = $this->getSalaryComponent($jobTitleComponentName);
        $phoneComponent = $this->getSalaryComponent($phoneComponentName);
        $parkingComponent = $this->getSalaryComponent($parkingComponentName);
        $lunchComponent = $this->getSalaryComponent($lunchComponentName);

        foreach ($lines as $line) {
            list($employeeId, $name, $baseSalary, $jobTitleAllowance, $lunchAllowance, $phoneAllowance, $parkingAllowance, $bonus, $overtime) = explode(',', $line);
            $employee = $this->getEmployee($employeeId);

            // Save job title allowance
            if (!empty($jobTitleAllowance) || $jobTitleAllowance === "0" || $jobTitleAllowance === 0) {
                $jobTitleAllowance = $this->saveEmployeeSalary($employee, $jobTitleComponent, $jobTitleAllowance);
                $this->addCustomFieldValues($jobTitleAllowance->id, $date->format('Y-m-d'));
            }

            // Save job title allowance
            if (!empty($lunchAllowance) || $lunchAllowance === "0" || $lunchAllowance === 0) {
                $lunchAllowance = $this->saveEmployeeSalary($employee, $lunchComponent, $lunchAllowance);
                $this->addCustomFieldValues($lunchAllowance->id, $date->format('Y-m-d'));
            }

            // Save phone allowance
            if (!empty($phoneAllowance) || $phoneAllowance === "0" || $phoneAllowance === 0) {
                $phoneAllowance = $this->saveEmployeeSalary($employee, $phoneComponent, $phoneAllowance);
                $this->addCustomFieldValues($phoneAllowance->id, $date->format('Y-m-d'));
            }

            // Save parking allowance
            if (!empty($parkingAllowance) || $parkingAllowance === "0" || $parkingAllowance === 0) {
                $parkingAllowance = $this->saveEmployeeSalary($employee, $parkingComponent, $parkingAllowance);
                $this->addCustomFieldValues($parkingAllowance->id, $date->format('Y-m-d'));
            }

            // Save employee base salary
            if (!empty($baseSalary) || $baseSalary === "0" || $baseSalary === 0) {
                $employeeSalary = $this->saveEmployeeSalary($employee, $baseSalaryComponent, $baseSalary);
                $this->addCustomFieldValues($employeeSalary->id, $date->format('Y-m-d'));
            }

            // Save bonus
            if (!empty($bonus) || $bonus === "0" || $bonus === 0) {
                $this->addEmployeeSalaryBonus($employee, $bonus, $date->format('Y-m-d H:i:s'));
            }

            // Save bonus
            if (!empty($overtime) || $overtime === "0" || $overtime === 0) {
                $this->addEmployeeSalaryOvertime($employee, $overtime, $date->format('Y-m-d H:i:s'));
            }
        }
    }

    private function addEmployeeSalaryBonus($employee, $amount, $date)
    {
        $bonus = new EmployeeSalaryBonus();
        $bonus->employee = $employee->id;
        $bonus->amount = $amount;
        $bonus->date = $date;
        $bonus->Save();

        return $bonus;
    }

    private function addEmployeeSalaryOvertime($employee, $amount, $date)
    {
        $bonus = new EmployeeSalaryOvertime();
        $bonus->employee = $employee->id;
        $bonus->amount = $amount;
        $bonus->date = $date;
        $bonus->Save();

        return $bonus;
    }

    private function saveEmployeeSalary($employee, $component, $amount)
    {
        $employeeSalary = new EmployeeSalary();
        $employeeSalary->employee = $employee->id;
        $employeeSalary->component = $component->id;
        $employeeSalary->amount = $amount;
        $employeeSalary->Save();

        return $employeeSalary;
    }

    private function addCustomFieldValues($id, $value)
    {
        $customField = new CustomFieldValue();
        $customField->type = 'EmployeeSalary';
        $customField->name = 'start_date';
        $customField->object_id = $id;
        $customField->value = $value;
        $customField->Save();
    }

    private function getEmployee($employeeId)
    {
        $model = new Employee();
        /** @var array $employees */
        $employees = $model->Find('employee_id = ?', ['employee_id' => $employeeId]);

        if (empty($employees)) {
            return false;
        }

        return array_shift($employees);
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
}
<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 4:18 PM
 */

namespace Payroll\Admin\Api;

require dirname(dirname(dirname(dirname(dirname(__FILE__))))) . '/lib/composer/vendor/autoload.php';

use Classes\BaseService;
use Classes\IceResponse;
use Classes\LanguageManager;
use Classes\ReportHandler;
use Classes\SubActionManager;
use Company\Common\Model\CompanyStructure;
use DateTime;
use Employees\Common\Model\Employee;
use Exception;
use Payroll\Common\Model\Deduction;
use Payroll\Common\Model\Payroll;
use Payroll\Common\Model\PayrollCalculations;
use Payroll\Common\Model\PayrollColumn;
use Payroll\Common\Model\PayrollData;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\PayrollEmployee;
use Salary\Common\Model\SalaryComponent;
use stdClass;
use Utils\LogManager;
use Utils\Math\EvalMath;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Utils\StringHelper;

class PayrollActionManager extends SubActionManager
{

    const REG_HOURS_PER_WEEK = 40;

    protected $calCache = array();

    public function addToCalculationCache($key, $val)
    {
        $this->calCache[$key] = $val;
    }

    public function getFromCalculationCache($key)
    {
        if (isset($this->calCache[$key])) {
            return $this->calCache[$key];
        }

        return null;
    }

    public function calculatePayrollColumn(
        $col,
        $payroll,
        $employeeId,
        $payrollEmployeeId,
        $noColumnCalculations = false
    )
    {

        $val = $this->getFromCalculationCache($col->id . "-" . $payroll->id . "-" . $employeeId);
        if (!empty($val)) {
            return $val;
        }

        if (!empty($col->calculation_hook)) {
            $sum = BaseService::getInstance()->executeCalculationHook(
                array($employeeId, $payroll->date_start, $payroll->date_end, $col->salary_components),
                $col->calculation_hook,
                $col->calculation_function
            );
            $val = number_format(round($sum, 2), 2, '.', '');
            $this->addToCalculationCache($col->id . "-" . $payroll->id . "-" . $employeeId, $val);
            return $val;
        }

        $sum = 0;

        $payRollEmp = new PayrollEmployee();
        $payRollEmp->Load("id = ?", array($payrollEmployeeId));

        //Salary
        LogManager::getInstance()->info("salary components row:" . $col->salary_components);
        if (!empty($col->salary_components) &&
            !empty(json_decode($col->salary_components, true))) {
            $salaryComponent = new SalaryComponent();
            $salaryComponents = $salaryComponent->Find(
                "id in (" . implode(",", json_decode($col->salary_components, true)) . ")",
                array()
            );
            LogManager::getInstance()->info("salary components:" . $salaryComponents);
            foreach ($salaryComponents as $salaryComponent) {
                $sum += $this->getTotalForEmployeeSalaryByComponent($employeeId, $salaryComponent->id);
            }
        }

        //Deductions
        if (!empty($col->deductions) &&
            !empty(json_decode($col->deductions, true))) {
            $deduction = new Deduction();
            if (empty($payRollEmp->deduction_group)) {
                $deductions = $deduction->Find(
                    "id in (" . implode(",", json_decode($col->deductions, true)) . ")",
                    array()
                );
            } else {
                $deductions = $deduction->Find(
                    "deduction_group = ? and id in (" . implode(",", json_decode($col->deductions, true)) . ")",
                    array($payRollEmp->deduction_group)
                );
            }

            $allowedDeductions = $this->getAllowedDeductionsForEmployee($employeeId, $payRollEmp->deduction_group);
            foreach ($deductions as $deduction) {
                if (!in_array($deduction->id, $allowedDeductions)) {
                    continue;
                }
            }
            foreach ($deductions as $deduction) {
                $sum += $this->calculateDeductionValue($employeeId, $deduction, $payroll);
            }
        }

        if (!$noColumnCalculations) {
            $evalMath = new EvalMath();
            $evalMath->evaluate('max(x,y) = (y - x) * ceil(tanh(exp(tanh(y - x)) - exp(0))) + x');
            $evalMath->evaluate('min(x,y) = y - (y - x) * ceil(tanh(exp(tanh(y - x)) - exp(0)))');

            if (!empty($col->add_columns) &&
                !empty(json_decode($col->add_columns, true))) {
                $colIds = json_decode($col->add_columns, true);
                $payrollColumn = new PayrollColumn();
                $payrollColumns = $payrollColumn->Find("id in (" . implode(",", $colIds) . ")", array());
                foreach ($payrollColumns as $payrollColumn) {
                    $sum += $this->calculatePayrollColumn(
                        $payrollColumn,
                        $payroll,
                        $employeeId,
                        $payrollEmployeeId,
                        true
                    );
                }
            }

            if (!empty($col->sub_columns) &&
                !empty(json_decode($col->sub_columns, true))) {
                $colIds = json_decode($col->sub_columns, true);
                $payrollColumn = new PayrollColumn();
                $payrollColumns = $payrollColumn->Find("id in (" . implode(",", $colIds) . ")", array());
                foreach ($payrollColumns as $payrollColumn) {
                    $sum -= $this->calculatePayrollColumn(
                        $payrollColumn,
                        $payroll,
                        $employeeId,
                        $payrollEmployeeId,
                        true
                    );
                }
            }

            if (!empty($col->calculation_columns) &&
                !empty(json_decode($col->calculation_columns, true)) && !empty($col->calculation_function)) {
                $cc = json_decode($col->calculation_columns);
                $func = $col->calculation_function;
                foreach ($cc as $c) {
                    $value = $this->getFromCalculationCache($c->column . "-" . $payroll->id . "-" . $employeeId);
                    if (empty($value)) {
                        $value = 0.00;
                    }
                    $func = str_replace($c->name, $value, $func);
                }
                try {
                    $sum += $evalMath->evaluate($func);
                } catch (Exception $e) {
                    LogManager::getInstance()->info("Error:" . $e->getMessage());
                }
            }
        }

        //return $sum;
        $val = number_format(round($sum, 2), 2, '.', '');
        $this->addToCalculationCache($col->id . "-" . $payroll->id . "-" . $employeeId, $val);
        return $val;
    }

    private function calculateDeductionValue($employeeId, $deduction, $payroll)
    {

        $salaryComponents = array();
        if (!empty($deduction->componentType) && !empty(json_decode($deduction->componentType, true))) {
            $salaryComponent = new SalaryComponent();
            $salaryComponents = $salaryComponent->Find(
                "componentType in (" . implode(",", json_decode($deduction->componentType, true)) . ")",
                array()
            );
        }

        $salaryComponents2 = array();
        if (!empty($deduction->component) && !empty(json_decode($deduction->component, true))) {
            $salaryComponent = new SalaryComponent();
            $salaryComponents2 = $salaryComponent->Find(
                "id in (" . implode(",", json_decode($deduction->component, true)) . ")",
                array()
            );
        }

        $sum = 0;

        $salaryComponentIDs = array();
        foreach ($salaryComponents as $sc) {
            $salaryComponentIDs[] = $sc->id;
            $sum += $this->getTotalForEmployeeSalaryByComponent($employeeId, $sc->id);
        }

        foreach ($salaryComponents2 as $sc) {
            if (!in_array($sc->id, $salaryComponentIDs)) {
                $salaryComponents[] = $sc;
                $sum += $this->getTotalForEmployeeSalaryByComponent($employeeId, $sc->id);
            }
        }

        if (!empty($deduction->payrollColumn)) {
            $columnVal = $this->getFromCalculationCache($deduction->payrollColumn . "-" . $payroll->id . "-" . $employeeId);
            if (!empty($columnVal)) {
                $sum += $columnVal;
            }
        }

        $deductionFunction = $this->getDeductionFunction($deduction, $sum);
        if (empty($deductionFunction)) {
            LogManager::getInstance()->error("Deduction function not found");
            return 0;
        }

        $deductionFunction = str_replace("X", $sum, $deductionFunction);

        $evalMath = new EvalMath();
        $val = $evalMath->evaluate($deductionFunction);
        return floatval($val);
    }

    private function getDeductionFunction($deduction, $amount)
    {
        $amount = floatval($amount);
        $ranges = json_decode($deduction->rangeAmounts);
        foreach ($ranges as $range) {
            $lowerLimitPassed = false;
            if ($range->lowerCondition == "No Lower Limit") {
                $lowerLimitPassed = true;
            } elseif ($range->lowerCondition == "gt") {
                if (floatval($range->lowerLimit) < $amount) {
                    $lowerLimitPassed = true;
                }
            } elseif ($range->lowerCondition == "gte") {
                if (floatval($range->lowerLimit) <= $amount) {
                    $lowerLimitPassed = true;
                }
            }

            $upperLimitPassed = false;
            if ($range->upperCondition == "No Upper Limit") {
                $upperLimitPassed = true;
            } elseif ($range->upperCondition == "lt") {
                if (floatval($range->upperLimit) > $amount) {
                    $upperLimitPassed = true;
                }
            } elseif ($range->upperCondition == "lte") {
                if (floatval($range->upperLimit) >= $amount) {
                    $upperLimitPassed = true;
                }
            }

            if ($lowerLimitPassed && $upperLimitPassed) {
                return $range->amount;
            }
        }
        return null;
    }

    private function getTotalForEmployeeSalaryByComponent($employeeId, $salaryComponentId)
    {
        $empSalary = new EmployeeSalary();
        $list = $empSalary->Find("employee = ? and component =?", array($employeeId, $salaryComponentId));
        $sum = 0;
        foreach ($list as $empSalary) {
            $sum += floatval($empSalary->amount);
        }

        return $sum;
    }

    private function getAllowedDeductionsForEmployee($employeeId, $deductionGroup)
    {
        $payrollEmp = new PayrollEmployee();
        $payrollEmp->Load("employee = ?", array($employeeId));

        $allowed = array();
        $deduction = new Deduction();
        if (empty($payrollEmp->deduction_allowed) || empty(json_decode($payrollEmp->deduction_allowed, true))) {
            $allowed = $deduction->Find("deduction_group = ?", array($deductionGroup));
        } else {
            $allowedIds = json_decode($payrollEmp->deduction_allowed, true);
            $allowed = $deduction->Find("id in (" . implode(",", $allowedIds) . ")");
        }

        $allowedFiltered = array();
        $disallowedIds = json_decode($payrollEmp->deduction_exemptions, true);

        if (!empty($disallowedIds)) {
            foreach ($allowed as $item) {
                if (!in_array($item->id, $disallowedIds)) {
                    $allowedFiltered[] = $item;
                }
            }
        } else {
            $allowedFiltered = $allowed;
        }

        $allowedIds = array();
        foreach ($allowedFiltered as $item) {
            $allowedIds[] = $item->id;
        }

        return $allowedIds;
    }

    public function getAllData($req)
    {

        $cal = new PayrollCalculations();

        $rowTable = BaseService::getInstance()->getFullQualifiedModelClassName($req->rowTable);
        $columnTable = BaseService::getInstance()->getFullQualifiedModelClassName($req->columnTable);
        $valueTable = BaseService::getInstance()->getFullQualifiedModelClassName($req->valueTable);
        $save = $req->save;
        $export = $req->export;

        //Only select employees matching pay frequency

        $payroll = new Payroll();
        $payroll->Load("id = ?", array($req->payrollId));
        $columnList = json_decode($payroll->columns, true);

        //Get Child company structures
        $cssResp = CompanyStructure::getAllChildCompanyStructures($payroll->department);
        error_log(json_encode($cssResp));
        $css = $cssResp->getData();
        $cssIds = array();
        foreach ($css as $c) {
            $cssIds[] = $c->id;
        }

        $employeesById = array();
        $employeeNamesById = array();
        $empModel = $baseEmp = new Employee();
        $baseEmpList = $baseEmp->Find(
            "department in (" . implode(",", $cssIds) . ") and status = ?",
            array('Active')
        );
        $empIds = array();
        foreach ($baseEmpList as $baseEmp) {
            $baseEmp = $empModel->getBankAccount($baseEmp);
            $employeeNamesById[$baseEmp->id] = $baseEmp->first_name . " " . $baseEmp->last_name;
            $employeesById[$baseEmp->id] = $baseEmp;
            $empIds[] = $baseEmp->id;
        }

        $emp = new $rowTable();
        $emps = $emp->Find(
            "pay_frequency = ? and deduction_group = ? and employee in (" . implode(",", $empIds) . ")",
            array($payroll->pay_period, $payroll->deduction_group)
        );
        if (!$emps) {
            error_log("Error:" . $emp->ErrorMsg());
        } else {
            error_log("Employees:" . json_encode($emps));
        }

        $employees = array();
        foreach ($emps as $emp) {
            $empNew = new stdClass();
            $empNew->id = $emp->employee;
            $empNew->payrollEmployeeId = $emp->id;
            $empNew->name = $employeeNamesById[$emp->employee];
            $employees[] = $empNew;
        }

        $column = new $columnTable();
        $columns = $column->Find(
            "enabled = ? and id in (" . implode(",", $columnList) . ") order by colorder, id",
            array('Yes')
        );

        $cost = new $valueTable();
        $costs = $cost->Find("payroll = ?", array($req->payrollId));

        //Build value map
        $valueMap = array();
        foreach ($costs as $val) {
            if (!isset($valueMap[$val->employee])) {
                $valueMap[$val->employee] = array();
            }

            $valueMap[$val->employee][$val->payroll_item] = $val;
        }

        //Fill hours worked
        foreach ($employees as $e) {
            if ($payroll->status != "Completed") {
                foreach ($columns as $column) {
                    if (isset($valueMap[$e->id][$column->id]) && $column->editable == "Yes") {
                        $this->addToCalculationCache(
                            $column->id . "-" . $payroll->id . "-" . $e->id,
                            $valueMap[$e->id][$column->id]->amount
                        );
                        continue;
                    }
                    $item = new PayrollData();
                    $item->payroll = $req->payrollId;
                    $item->employee = $e->id;
                    $item->payroll_item = $column->id;
                    $item->amount = $this->calculatePayrollColumn($column, $payroll, $e->id, $e->payrollEmployeeId);
                    if ($item->amount == "") {
                        $item->amount = $column->default_value;
                    }
                    $valueMap[$e->id][$column->id] = $item;
                }
            }
        }

        $values = array();
        foreach ($valueMap as $key => $val) {
            $values = array_merge($values, array_values($val));
        }

        if ($save == "1") {
            foreach ($values as $value) {
                if (empty($value->id)) {
                    $value->Save();
                }
            }
        }

        if ($payroll->status == 'Processing') {
            $payroll->status = 'Completed';
            $payroll->Save();
        }

        if ($payroll->status == 'Completed') {
            $newCols = array();
            foreach ($columns as $col) {
                $col->editable = 'No';
                $newCols[] = $col;
            }
            $columns = $newCols;
        }

        $responseData = array($employees, $columns, $values);

        if ($export == "1") {
            try {
                $spreadsheet = new Spreadsheet();
                $sheet = $spreadsheet->getActiveSheet();
                $numOfColumns = count($columns) + 2;
                $alphas = range('A', 'Z');
                $endColumnName = $alphas[$numOfColumns - 1];

                //Set title
                $rowIndex = 1;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Payroll Table"));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                $rowIndex = 2;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("From") . " " . DateTime::createFromFormat('Y-m-d', $payroll->date_start)->format('d/m/Y') . " " . LanguageManager::tran("To") . " " . DateTime::createFromFormat('Y-m-d', $payroll->date_end)->format('d/m/Y'));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                //Set header
                $rowIndex = 3;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Employee Number"));
                $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Employee"));
                foreach ($columns as $colIndex => $column) {
                    $sheet->setCellValueByColumnAndRow($colIndex + 3, $rowIndex, $column->name);
                }

                //Set data
                $rowIndex++;
                foreach ($valueMap as $empId => $rowData) {
                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, $employeesById[$empId]->employee_id);
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, $employeeNamesById[$empId]);

                    foreach ($columns as $colIndex => $column) {
                        $endColumnName = $alphas[$colIndex - 1];
                        $sheet->getStyle("{$endColumnName}{$rowIndex}")->getNumberFormat()
                            ->setFormatCode(NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED3);
                        $sheet->setCellValueByColumnAndRow($colIndex + 3, $rowIndex, $rowData[$column->id]->amount);
                    }

                    $rowIndex++;
                }
                $payrollName = $this->removeSpecialChar($payroll->name);
                $filename = uniqid("{$payrollName}_");
                $filePath = CLIENT_BASE_PATH . "/data/payroll_{$filename}.xlsx";
                $fileUrl = CLIENT_BASE_URL . "/data/payroll_{$filename}.xlsx";
                $writer = new Xlsx($spreadsheet);
                $writer->save($filePath);
                $responseData['file'] = [
                    'url' => $fileUrl,
                    'name' => "{$filename}.xlsx"
                ];
            } catch (Exception $e) {var_dump($e);exit;
                LogManager::getInstance()->error("Export to EXCEL Error\r\n" . $e->getMessage() . "\r\n" . $e->getTraceAsString());
            }
        }

        switch ($export) {
            case 2:
            case 3:
                $exportCompany = 'Y VIET';
                break;
            case 4:
            case 5:
                $exportCompany = 'VMED';
                break;
            case 6:
            case 7:
                $exportCompany = 'SKB';
                break;
            default:
                $exportCompany = null;
        }

        if (in_array($export, ['2', '4', '6'])) {
            try {
                $spreadsheet = new Spreadsheet();
                $sheet = $spreadsheet->getActiveSheet();
                $numOfColumns = 8;
                $alphas = range('A', 'Z');
                $endColumnName = $alphas[$numOfColumns - 1];

                //Set title
                $rowIndex = 1;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Payment on Behalf") . " " . LanguageManager::tran("Month") . " " . DateTime::createFromFormat('Y-m-d', $payroll->date_end)->format('m/Y'));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                //Set header
                $rowIndex = 2;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("STT"));
                $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Employee"));
                $sheet->setCellValueByColumnAndRow(3, $rowIndex, LanguageManager::tran("Bank Account"));
                $sheet->setCellValueByColumnAndRow(4, $rowIndex, LanguageManager::tran("Amount"));
                $sheet->setCellValueByColumnAndRow(5, $rowIndex, LanguageManager::tran("Transfer Content"));
                $sheet->setCellValueByColumnAndRow(6, $rowIndex, LanguageManager::tran("CMND"));
                $sheet->setCellValueByColumnAndRow(7, $rowIndex, LanguageManager::tran("Employee Number"));
                $sheet->setCellValueByColumnAndRow(8, $rowIndex, LanguageManager::tran("Job Title"));

                //Set data
                $rowIndex++;
                $index = 1;
                $column = array_pop($columns);
                foreach ($valueMap as $empId => $rowData) {
                    $employee = $employeesById[$empId];
                    $employee = $empModel->getBankAccount($employee);
                    $company = strtoupper($empModel->getCompany($employee));

                    if (empty($employee) || $employee->bank_name != 'ACB' || (!empty($exportCompany) && $company != $exportCompany)) {
                        continue;
                    }

                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, $index);
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, StringHelper::convert_vi_to_en($employee->last_name . " " . $employee->middle_name . " " . $employee->first_name));
                    $sheet->setCellValueByColumnAndRow(3, $rowIndex, StringHelper::convert_vi_to_en($employee->bank_account));
                    $sheet->setCellValueByColumnAndRow(4, $rowIndex, StringHelper::convert_vi_to_en($rowData[$column->id]->amount));
                    $sheet->setCellValueByColumnAndRow(5, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(6, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(7, $rowIndex, StringHelper::convert_vi_to_en($employee->employee_id));
                    $sheet->setCellValueByColumnAndRow(8, $rowIndex, StringHelper::convert_vi_to_en($empModel->getJobTitle($employee)->job_title->name));
                    $sheet->getStyle("D{$rowIndex}")->getNumberFormat()
                        ->setFormatCode(NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED3);

                    $rowIndex++;
                    $index++;
                }
                $payrollName = $this->removeSpecialChar($payroll->name);
                $filename = uniqid("payment_on_behalf_ACB_{$payrollName}_");
                $filePath = CLIENT_BASE_PATH . "/data/payment_on_behalf_ACB_{$filename}.xlsx";
                $fileUrl = CLIENT_BASE_URL . "/data/payment_on_behalf_ACB_{$filename}.xlsx";
                $writer = new Xlsx($spreadsheet);
                $writer->save($filePath);
                $responseData['file'] = [
                    'url' => $fileUrl,
                    'name' => "{$filename}.xlsx"
                ];
            } catch (Exception $e) {
                LogManager::getInstance()->error("Export to EXCEL Error\r\n" . $e->getMessage() . "\r\n" . $e->getTraceAsString());
            }
        }

        if (in_array($export, ['3', '5', '7'])) {
            try {
                $spreadsheet = new Spreadsheet();
                $sheet = $spreadsheet->getActiveSheet();
                $numOfColumns = 12;
                $alphas = range('A', 'Z');
                $endColumnName = $alphas[$numOfColumns - 1];

                //Set title
                $rowIndex = 1;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("Payment on Behalf") . " " . LanguageManager::tran("Month") . " " . DateTime::createFromFormat('Y-m-d', $payroll->date_end)->format('m/Y'));
                $sheet->mergeCells("A{$rowIndex}:{$endColumnName}{$rowIndex}");
                $sheet->getStyle("A{$rowIndex}:{$endColumnName}{$rowIndex}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

                //Set header
                $rowIndex = 2;
                $sheet->setCellValueByColumnAndRow(1, $rowIndex, LanguageManager::tran("STT"));
                $sheet->setCellValueByColumnAndRow(2, $rowIndex, LanguageManager::tran("Employee"));
                $sheet->setCellValueByColumnAndRow(3, $rowIndex, LanguageManager::tran("Employee Number"));
                $sheet->setCellValueByColumnAndRow(4, $rowIndex, LanguageManager::tran("Job Title"));
                $sheet->setCellValueByColumnAndRow(5, $rowIndex, LanguageManager::tran("Amount"));
                $sheet->setCellValueByColumnAndRow(6, $rowIndex, LanguageManager::tran("Bank Code"));
                $sheet->setCellValueByColumnAndRow(7, $rowIndex, LanguageManager::tran("Bank Account"));
                $sheet->setCellValueByColumnAndRow(8, $rowIndex, LanguageManager::tran("CMND"));
                $sheet->setCellValueByColumnAndRow(9, $rowIndex, LanguageManager::tran("CMND Issued Date"));
                $sheet->setCellValueByColumnAndRow(10, $rowIndex, LanguageManager::tran("CMND Issued By"));
                $sheet->setCellValueByColumnAndRow(11, $rowIndex, LanguageManager::tran("Bank Card Number"));
                $sheet->setCellValueByColumnAndRow(12, $rowIndex, LanguageManager::tran("Transfer Content"));

                //Set data
                $rowIndex++;
                $index = 1;
                $column = array_pop($columns);
                foreach ($valueMap as $empId => $rowData) {
                    $employee = $employeesById[$empId];
                    $employee = $empModel->getBankAccount($employee);
                    $company = strtoupper($empModel->getCompany($employee));

                    if (empty($employee) || $employee->bank_name == 'ACB' || (!empty($exportCompany) && $company != $exportCompany)) {
                        continue;
                    }

                    $sheet->setCellValueByColumnAndRow(1, $rowIndex, $index);
                    $sheet->setCellValueByColumnAndRow(2, $rowIndex, StringHelper::convert_vi_to_en($employee->last_name . " " . $employee->middle_name . " " . $employee->first_name));
                    $sheet->setCellValueByColumnAndRow(3, $rowIndex, StringHelper::convert_vi_to_en($employee->employee_id));
                    $sheet->setCellValueByColumnAndRow(4, $rowIndex, StringHelper::convert_vi_to_en($empModel->getJobTitle($employee)->job_title->name));
                    $sheet->setCellValueByColumnAndRow(5, $rowIndex, StringHelper::convert_vi_to_en($rowData[$column->id]->amount));
                    $sheet->setCellValueByColumnAndRow(6, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(7, $rowIndex, StringHelper::convert_vi_to_en($employee->bank_account));
                    $sheet->setCellValueByColumnAndRow(8, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(9, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(10, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(11, $rowIndex, "");
                    $sheet->setCellValueByColumnAndRow(12, $rowIndex, StringHelper::convert_vi_to_en(LanguageManager::tran(strtoupper($company) . " - Payment on Behalf Content") . DateTime::createFromFormat('Y-m-d', $payroll->date_end)->format('m-Y')));
                    $sheet->getStyle("E{$rowIndex}")->getNumberFormat()
                        ->setFormatCode(NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED3);

                    $rowIndex++;
                    $index++;
                }

                $payrollName = $this->removeSpecialChar($payroll->name);
                $filename = uniqid("payment_on_behalf_{$payrollName}_");
                $filePath = CLIENT_BASE_PATH . "/data/payment_on_behalf_{$filename}.xlsx";
                $fileUrl = CLIENT_BASE_URL . "/data/payment_on_behalf_{$filename}.xlsx";
                $writer = new Xlsx($spreadsheet);
                $writer->save($filePath);
                $responseData['file'] = [
                    'url' => $fileUrl,
                    'name' => "{$filename}.xlsx"
                ];
            } catch (Exception $e) {
                LogManager::getInstance()->error("Export to EXCEL Error\r\n" . $e->getMessage() . "\r\n" . $e->getTraceAsString());
            }
        }

        return new IceResponse(IceResponse::SUCCESS, $responseData);
    }

    private function removeSpecialChar($str)
    {
        $str = str_replace("/","-", $str);
        $str = str_replace(" ","-", $str);
        return $str;
    }

    public function updateAllData($req)
    {

        $resp = $this->updateData($req);

        if ($resp->getStatus() == IceResponse::SUCCESS) {
            $payroll = new Payroll();
            $payroll->Load("id = ?", array($req->payrollId));
            $payroll->status = 'Processing';
            $ok = $payroll->Save();
            if (!$ok) {
                return new IceResponse(IceResponse::ERROR, $payroll->ErrorMsg());
            }
        }
        return $resp;
    }

    public function updateData($req)
    {
        $payroll = new Payroll();
        $payroll->Load("id = ?", array($req->payrollId));
        if ($payroll->status == 'Completed') {
            return new IceResponse(IceResponse::ERROR, true);
        }
        $valueTable = BaseService::getInstance()->getFullQualifiedModelClassName($req->valueTable);
        $payrollId = $req->payrollId;
        foreach ($req as $key => $val) {
            if (!is_array($val)) {
                continue;
            }
            $data = new $valueTable();
            $data->Load("payroll = ? and employee = ? and payroll_item = ?", array($payrollId, $val[1], $val[0]));
            if (empty($data->id)) {
                $data->payroll = $payrollId;
                $data->employee = $val[1];
                $data->payroll_item = $val[0];
            }
            $data->amount = $val[2];
            LogManager::getInstance()->info("Saving payroll data :" . json_encode($data));
            $ok = $data->Save();
            if (!$ok) {
                LogManager::getInstance()->error("Error saving payroll data:" . $data->ErrorMsg());
            }
        }

        return new IceResponse(IceResponse::SUCCESS, true);
    }

    public function sendPayslip($req)
    {
        $payroll = new Payroll();
        $payroll->Load("id = ?", array($req->payrollId));
        $review = $req->review ?? false;

        if (empty($payroll->id) || $payroll->status != 'Completed') {
            return new IceResponse(IceResponse::ERROR, "Payroll has not been finished yet!");
        }

        $request = [];
        $request['payroll'] = $req->payrollId;
        $request['id'] = 7;
        $request['t'] = 'UserReport';
        $request['a'] = 'add';

        $reportMgrClass = BaseService::getInstance()->getFullQualifiedModelClassName($request['t']);
        /* @var \Model\Report $report */
        $report = new $reportMgrClass();
        $report->Load("id = ?", array($request['id']));

        $className = '\\Reports\\User\\Reports\\PayslipReport';
        $cls = new $className();

        //Get Child company structures
        $cssResp = CompanyStructure::getAllChildCompanyStructures($payroll->department);
        error_log(json_encode($cssResp));
        $css = $cssResp->getData();
        $cssIds = array();
        foreach ($css as $c) {
            $cssIds[] = $c->id;
        }

        $baseEmp = new Employee();
        $baseEmpList = $baseEmp->Find(
            "department in (" . implode(",", $cssIds) . ") and status = ?",
            array('Active')
        );
        $empIds = array();
        foreach ($baseEmpList as $baseEmp) {
            $empIds[] = $baseEmp->id;
        }

        $emp = new PayrollEmployee();
        $emps = $emp->Find(
            "pay_frequency = ? and deduction_group = ? and employee in (" . implode(",", $empIds) . ")",
            array($payroll->pay_period, $payroll->deduction_group)
        );

        foreach ($emps as $emp) {
            $data = $cls->getData($report, $request, $emp->employee);

            if (!empty($data)) {
                $file = ReportHandler::generateReportFile($cls, $report, $data);

                if (!empty($this->emailSender) && $file) {
                    $payrollEmailSender = new PayslipEmailSender($this->emailSender, $this);
                    $payrollEmailSender->sendPayslipEmail($emp->employee, $file[1], $payroll, $review);
                }
            }
        }

        return new IceResponse(IceResponse::SUCCESS, $req);
    }
}

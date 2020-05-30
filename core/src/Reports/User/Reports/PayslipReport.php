<?php

namespace Reports\User\Reports;

use Attendance\Admin\Api\AttendanceUtil;
use Classes\BaseService;
use Classes\LanguageManager;
use DateTime;
use Leaves\Admin\Api\EmployeeLeaveUtil;
use Payroll\Common\Model\Payroll;
use Payroll\Common\Model\PayrollColumn;
use Payroll\Common\Model\PayrollData;
use Payroll\Common\Model\PayslipTemplate;
use Reports\Admin\Api\PDFReportBuilder;
use Reports\Admin\Api\PDFReportBuilderInterface;
use Salary\Admin\Api\SalaryUtil;
use Salary\Common\Model\SalaryComponent;

class PayslipReport extends PDFReportBuilder implements PDFReportBuilderInterface
{
    public function getData($report, $request)
    {
        $data = $this->getDefaultData();
        $employeeId = BaseService::getInstance()->getCurrentProfileId();
        $data['fields'] = array();

        $payroll = new Payroll();
        $payroll->Load("id = ?", array($request['payroll']));

        if (empty($payroll->payslipTemplate)) {
            return null;
        }

        $payslipTemplate = new PayslipTemplate();
        $payslipTemplate->Load("id = ?", array($payroll->payslipTemplate));

        if (empty($payslipTemplate->id)) {
            return null;
        }

        $fields = json_decode($payslipTemplate->data, true);

        $salaryUtil = new SalaryUtil();
        $payrollColumnModel = new PayrollColumn();
        $salaryComponentModel = new SalaryComponent();
        $separatorField = [
            "type" => "Separators",
            "payrollColumn" => "NULL",
            "label" => "",
            "text" => "",
            "status" => "Show",
            "id" => uniqid('data_')
        ];

        foreach ($fields as $field) {
            if ($field['type'] == 'Payroll Column') {
                $col = new PayrollColumn();
                $col->Load("id = ?", $field['payrollColumn']);
                if (empty($col->id)) {
                    continue;
                }
                $payrollData = new PayrollData();
                $payrollData->Load(
                    "payroll = ? and payroll_item = ? and employee = ?",
                    array(
                        $request['payroll'],
                        $col->id, $employeeId
                    )
                );

                if (empty($payrollData->id)) {
                    continue;
                }

                $field['value'] = number_format($payrollData->amount);
                $field['label'] = LanguageManager::tran($field['label']);

                if (empty($field['label'])) {
                    $field['label'] = $col->name;
                }

                if (!empty($field['payrollColumn'])) {
                    /** @var array $payrollColumns */
                    $payrollColumns = $payrollColumnModel->Find('id = ?', ['id' => $field['payrollColumn']]);
                    if (!empty($payrollColumns)) {
                        $payrollColumn = array_shift($payrollColumns);

                        //Real Salary
                        if ($payrollColumn->calculation_hook == 'SalaryUtil_getRealSalary') {
                            $salaryComponents = $salaryUtil->parseSalaryComponent($payrollColumn->salary_components);
                            $salaryComponent = $salaryComponents[0];
                            /** @var array $salaryComponentObjects */
                            $salaryComponentObjects = $salaryComponentModel->Find('id = ?', ['id' => $salaryComponent]);
                            $salaryComponentObject = array_shift($salaryComponentObjects);
                            $empSalaries = SalaryUtil::getEmployeeSalaries($employeeId, $payroll->date_start, $payroll->date_end, $salaryComponents);

                            $empBaseSalaryRows = [];
                            $additionalFields = [];

                            $empBaseSalaryRows[] = [
                                'id' => uniqid('data_'),
                                'type' => 'Payroll Column',
                                'status' => 'Show',
                                'value' => ' ',
                                'label' => LanguageManager::tran($salaryComponentObject->name)
                            ];

                            $additionalFields[] = [
                                'id' => uniqid('data_'),
                                'type' => 'Payroll Column',
                                'status' => 'Show',
                                'value' => ' ',
                                'label' => LanguageManager::tran($salaryComponentObject->name . ' ngày')
                            ];

                            foreach ($empSalaries as $index => $empSalary) {
                                $empBaseSalaryRow = [
                                    'id' => uniqid('data_'),
                                    'type' => 'Payroll Column',
                                    'status' => 'Show',
                                    'text' => '',
                                    'value' => number_format($empSalary->amount) . ' đ',
                                    'label' => (count($empSalaries) > 1) ? (LanguageManager::tran('From Date') . " ") : ' ',
                                ];

                                $startDate = $payroll->date_start;
                                if ($index < (count($empSalaries) - 1)) {
                                    $endDate = DateTime::createFromFormat('Y-m-d', $empSalaries[$index + 1]->start_date)
                                        ->sub(\DateInterval::createFromDateString('1 day'));
                                } else {
                                    $endDate = DateTime::createFromFormat('Y-m-d', $payroll->date_end);
                                }

                                if ((count($empSalaries) > 1)) {
                                    if (empty($empSalary->start_date)) {
                                        $empBaseSalaryRow['label'] .= DateTime::createFromFormat('Y-m-d', $payroll->date_start)->format('d/m/Y');
                                    } else {
                                        $startDate = $empSalary->start_date;
                                        $empBaseSalaryRow['label'] .= DateTime::createFromFormat('Y-m-d', $empSalary->start_date)->format('d/m/Y');
                                    }
                                }

                                $empBaseSalaryRows[] = $empBaseSalaryRow;

                                //
                                $realSalary = $salaryUtil->getRealSalary($employeeId, $startDate, $endDate->format('Y-m-d'), $payrollColumn->salary_components, true);
                                $baseSalary = $salaryUtil->getBaseSalary($employeeId, $startDate, $endDate->format('Y-m-d'), $payrollColumn->salary_components);
                                $fromDate = DateTime::createFromFormat('Y-m-d', $startDate)->format('d/m/Y');
                                $toDate = $endDate->format('d/m/Y');
                                $total = 0;
                                $totalWorkingDays = AttendanceUtil::getTotalWorkingDaysInMonth($employeeId, $payroll->date_start, $payroll->date_end);

                                foreach ($realSalary as $dateRealSalary) {
                                    $total += $dateRealSalary->baseSalary;
                                }

                                $additionalFields[] = [
                                    'id' => uniqid('data_'),
                                    'type' => 'Payroll Column',
                                    'status' => 'Show',
                                    'text' => '',
                                    'value' => number_format((int)$baseSalary / (float)$totalWorkingDays) . ' đ',
                                    'label' => LanguageManager::tran('From Date') . " {$fromDate} - " . LanguageManager::tran('To Date') . " {$toDate}",
                                ];
                            }

//                            $data['fields'][] = $separatorField;

                            foreach ($empBaseSalaryRows as $row) {
                                $data['fields'][] = $row;
                            }

                            $data['fields'][] = $separatorField;

                            foreach ($additionalFields as $row) {
                                $data['fields'][] = $row;
                            }

                            $data['fields'][] = $separatorField;
                        } elseif ($payrollColumn->calculation_hook == 'SalaryUtil_getSalaryDeposit') {
                            $depositSalaries = $salaryUtil->getSalaryDeposit($employeeId, $payroll->date_start, $payroll->date_end, true);

                            $data['fields'][] = [
                                'id' => uniqid('data_'),
                                'type' => 'Payroll Column',
                                'status' => 'Show',
                                'value' => ' ',
                                'label' => LanguageManager::tran('Tiền lương đã ứng kỳ trước')
                            ];

                            foreach ($depositSalaries as $depositSalary) {
                                $data['fields'][] = [
                                    'id' => uniqid('data_'),
                                    'type' => 'Payroll Column',
                                    'status' => 'Show',
                                    'value' => number_format($depositSalary->amount) . ' đ',
                                    'label' => DateTime::createFromFormat('Y-m-d H:i:s', $depositSalary->date)->format('d/m/Y')
                                ];
                            }
                            $data['fields'][] = $separatorField;
                        }  elseif ($payrollColumn->calculation_hook == 'SalaryUtil_getSalaryBonus') {
                            $bonusSalaries = $salaryUtil->getSalaryBonus($employeeId, $payroll->date_start, $payroll->date_end, true);

                            $data['fields'][] = [
                                'id' => uniqid('data_'),
                                'type' => 'Payroll Column',
                                'status' => 'Show',
                                'value' => ' ',
                                'label' => LanguageManager::tran('Tiền thưởng')
                            ];

                            foreach ($bonusSalaries as $bonusSalary) {
                                $data['fields'][] = [
                                    'id' => uniqid('data_'),
                                    'type' => 'Payroll Column',
                                    'status' => 'Show',
                                    'value' => number_format($bonusSalary->amount) . ' đ',
                                    'label' => DateTime::createFromFormat('Y-m-d H:i:s', $bonusSalary->date)->format('d/m/Y')
                                ];
                            }
                            $data['fields'][] = $separatorField;
                        } else {
                            $data['fields'][] = $separatorField;
                        }
                    }
                }
            }

            if ($field['status'] == 'Show') {
                $data['fields'][] = $field;
            }
        }
        $employee = BaseService::getInstance()->getElement(
            'Employee',
            BaseService::getInstance()->getCurrentProfileId(),
            null,
            true
        );
        $data['employeeName'] = $employee->first_name . ' ' . $employee->last_name;
        $data['payroll'] = $payroll;
        return $data;
    }

    public function getTemplate()
    {
        return "payslip.html";
    }
}

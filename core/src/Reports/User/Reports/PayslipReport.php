<?php

namespace Reports\User\Reports;

use Attendance\Admin\Api\AttendanceUtil;
use Classes\BaseService;
use Classes\LanguageManager;
use DateTime;
use Employees\Common\Model\Employee;
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
    public function getData($report, $request, $employeeId = null)
    {
        $data = $this->getDefaultData();
        $employeeId = empty($employeeId) ? BaseService::getInstance()->getCurrentProfileId() : $employeeId;
        $employee = new Employee();
        $employee->Load('id = ?', [$employeeId]);
        $data['fields'] = array();

        $payroll = $this->getPayroll($request);

        if (empty($payroll->payslipTemplate)) {
            return null;
        }

        $payslipTemplate = $this->getPayslipTemplate($payroll);

        if (empty($payslipTemplate->id)) {
            return null;
        }

        $salaryUtil = new SalaryUtil();
        $attendanceUtil = new AttendanceUtil();
        $salaryComponentModel = new SalaryComponent();
        $separatorField = [
            "type" => "Separators",
            "payrollColumn" => "NULL",
            "label" => "",
            "text" => "",
            "status" => "Show",
            "id" => uniqid('data_')
        ];

        $data['fields'][] = [
            "type" => "Company Logo",
            "payrollColumn" => "NULL",
            "label" => "",
            "text" => "",
            "status" => "Show",
            "id" => "data_2"
        ];
        $data['fields'][] = [
            "type" => "Company Name",
            "payrollColumn" => "NULL",
            "label" => "",
            "text" => "",
            "status" => "Show",
            "id" => "data_3"
        ];
        $data['fields'][] = $separatorField;

        $field = [
            'id' => uniqid('data_'),
            'type' => 'Payroll Column',
            'status' => 'Show',
            'text' => '',
            'value' => $attendanceUtil->getTotalWorkingDaysInMonth($employeeId, $payroll->date_start, $payroll->date_end),
            'label' => LanguageManager::tran("Số ngày công trong tháng"),
        ];
        $data['fields'][] = $field;
        $data['fields'][] = $separatorField;

        $field = [
            'id' => uniqid('data_'),
            'type' => 'Payroll Column',
            'status' => 'Show',
            'text' => '',
            'value' => $attendanceUtil->getDaysWorked($employeeId, $payroll->date_start, $payroll->date_end),
            'label' => LanguageManager::tran("Số ngày công thực tế"),
        ];
        $data['fields'][] = $field;
        $data['fields'][] = $separatorField;

        $employeeLeaveUtil = new EmployeeLeaveUtil();

        $field = [
            'id' => uniqid('data_'),
            'type' => 'Payroll Column',
            'status' => 'Show',
            'text' => '',
            'value' => $employeeLeaveUtil->calculateEmployeeLeave($employeeId, $payroll->date_start, $payroll->date_end),
            'label' => LanguageManager::tran("Số ngày nghỉ có tính lương"),
        ];
        $data['fields'][] = $field;
        $data['fields'][] = $separatorField;

        $salaryComponents = $salaryComponentModel->Find('1 = 1 ORDER BY id ASC');
        $salaryComponentIds = [];

        foreach ($salaryComponents as $salaryComponent) {
            $payrollColumn = new PayrollColumn();
            $payrollData = new PayrollData();
            $salaryComponentIds[] = $salaryComponent->id;
            $payrollColumn->Load('salary_components = ?', [
                "[\"{$salaryComponent->id}\"]"
            ]);

            if (empty($payrollColumn->id)) {
                continue;
            }

            $payrollData->Load('payroll_item = ? and employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (empty($payrollData->id)) {
                continue;
            }

            if ($payrollColumn->calculation_hook == 'SalaryUtil_getRealSalary') {
                $salaries = SalaryUtil::getEmployeeSalaries($employeeId, $payroll->date_start, $payroll->date_end, [$salaryComponent->id]);
            } else {
                $salaries = SalaryUtil::getEmployeeSalaries($employeeId, $payroll->date_start, $payroll->date_end, [$salaryComponent->id], true);
                $salaries = [$salaries];
            }
            $payrollStartDate = DateTime::createFromFormat('Y-m-d', $payroll->date_start);

            foreach ($salaries as $index => $salary) {
                $salaryStartDate = DateTime::createFromFormat('Y-m-d', $salary->start_date);
                $startDate = $salaryStartDate;

                if ($salaryStartDate < $payrollStartDate) {
                    $startDate = $payrollStartDate;
                }

                if ($startDate->format('Y-m-d') == $salaries[$index + 1]->start_date) {
                    unset($salaries[$index]);
                }
            }

            $salaries = array_values($salaries);

            if (count($salaries) > 2) {
                $unusedIds = [];
                for ($i = 1; $i < count($salaries); $i++) {
                    if ($salaries[$i]->amount == $salaries[$i - 1]->amount) {
                        $unusedIds[] = $i;
                    } elseif ($salaries[$i]->start_date == $salaries[$i - 1]->start_date) {
                        $unusedIds[] = $i - 1;
                    }
                }
                foreach ($unusedIds as $id) {
                    unset($salaries[$id]);
                }
            } elseif (count($salaries) > 1) {
                $first = $salaries[0];
                $second = $salaries[1];

                $firstDate = DateTime::createFromFormat('Y-m-d', $first->start_date);
                $secondDate = DateTime::createFromFormat('Y-m-d', $second->start_date);

                if ($salaries[1]->amount == $salaries[0]->amount) {
                    unset($salaries[1]);
                } elseif ($salaries[1]->start_date == $salaries[0]->start_date ||
                    ($secondDate == $payrollStartDate && $firstDate < $payrollStartDate)) {
                    unset($salaries[0]);
                }
            }

            if (count($salaries) > 1) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => ' ',
                    'label' => LanguageManager::tran($salaryComponent->name),
                ];
                $data['fields'][] = $field;

                foreach ($salaries as $index => $salary) {
                    $salaryStartDate = DateTime::createFromFormat('Y-m-d', $salary->start_date);
                    $startDate = $salaryStartDate;

                    if ($salaryStartDate < $payrollStartDate) {
                        $startDate = $payrollStartDate;
                    }

                    $field = [
                        'id' => uniqid('data_'),
                        'type' => 'Payroll Column',
                        'status' => 'Show',
                        'text' => '',
                        'value' => number_format($salary->amount) . ' đ',
                        'label' => LanguageManager::tran("From Date") . " " . $startDate->format('d/m/Y'),
                    ];

                    $data['fields'][] = $field;
                }
            } else {
                $salary = array_shift($salaries);
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($salary->amount) . ' đ',
                    'label' => LanguageManager::tran($salaryComponent->name),
                ];
                $data['fields'][] = $field;
            }
            $data['fields'][] = $separatorField;

            $unit = in_array($payrollColumn->calculation_hook, [
                'AttendanceUtil_getTotalWorkingDaysInMonth',
                'AttendanceUtil_getDaysWorked',
                'OvertimePayrollUtils_getApprovedTimeInRequests',
                'EmployeeLeaveUtil_getEmployeeLeave',
            ]) ? '' : ' đ';

            if ($payrollColumn->calculation_hook == 'SalaryUtil_getRealSalary') {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Total Amount') . " " . $salaryComponent->name,
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        //Calculate salary deposit
        $payrollColumn = new PayrollColumn();
        $payrollColumn->Load('calculation_hook = ?', ['SalaryUtil_getSalaryDeposit']);

        if (!empty($payrollColumn)) {
            $payrollData = new PayrollData();
            $payrollData->Load('payroll_item = ? AND employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (!empty($payrollData)) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Tổng tiền lương đã ứng'),
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        //Calculate salary bonus
        $payrollColumn = new PayrollColumn();
        $payrollColumn->Load('calculation_hook = ?', ['SalaryUtil_getSalaryBonus']);

        if (!empty($payrollColumn)) {
            $payrollData = new PayrollData();
            $payrollData->Load('payroll_item = ? AND employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (!empty($payrollData)) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Tiền thưởng'),
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        //Calculate salary overtime
        $payrollColumn = new PayrollColumn();
        $payrollColumn->Load('calculation_hook = ?', ['SalaryUtil_getSalaryOvertime']);

        if (!empty($payrollColumn)) {
            $payrollData = new PayrollData();
            $payrollData->Load('payroll_item = ? AND employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (!empty($payrollData)) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Tiền làm thêm giờ'),
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        //Calculate 13rd salary
        $payrollColumn = new PayrollColumn();
        $payrollColumn->Load('name LIKE ?', ['Lương tháng 13']);

        if (!empty($payrollColumn)) {
            $payrollData = new PayrollData();
            $payrollData->Load('payroll_item = ? AND employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (!empty($payrollData) && $payrollData->amount > 0) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Lương tháng 13'),
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        //Calculate net salary
        $payrollColumn = new PayrollColumn();
        $payrollColumn->Load('name LIKE ?', ['Lương thực lãnh%']);

        if (!empty($payrollColumn)) {
            $payrollData = new PayrollData();
            $payrollData->Load('payroll_item = ? AND employee = ? and payroll = ?', [$payrollColumn->id, $employeeId, $payroll->id]);

            if (!empty($payrollData)) {
                $field = [
                    'id' => uniqid('data_'),
                    'type' => 'Payroll Column',
                    'status' => 'Show',
                    'text' => '',
                    'value' => number_format($payrollData->amount) . $unit,
                    'label' => LanguageManager::tran('Lương thực lãnh'),
                ];
                $data['fields'][] = $field;
                $data['fields'][] = $separatorField;
            }
        }

        $field = [
            'id' => uniqid('data_'),
            'type' => 'Text',
            'status' => 'Show',
//            'text' => '',
            'value' => ' ',
            'text' => 'Vui lòng không chia sẻ mức lương, thưởng với các bạn khác. Mọi thắc mắc về lương xin vui lòng liên hệ Chân - 0986852411',
        ];
        $data['fields'][] = $field;

        $payroll->date_start = DateTime::createFromFormat('Y-m-d', $payroll->date_start)->format('d/m/Y');
        $payroll->date_end = DateTime::createFromFormat('Y-m-d', $payroll->date_end)->format('d/m/Y');
        $data['employeeName'] = $employee->first_name . ' ' . $employee->last_name;
        $data['payroll'] = $payroll;
        $data['PeriodText'] = LanguageManager::tran('Period Salary');
        $data['EmployeeText'] = LanguageManager::tran('Employee');
        $data['EmployeeIdText'] = LanguageManager::tran('Employee Number');
        $data['employeeId'] = $employee->employee_id;
        return $data;
    }

    public function getData_bk($report, $request)
    {
        $data = $this->getDefaultData();
        $employeeId = BaseService::getInstance()->getCurrentProfileId();
        $data['fields'] = array();

        $payroll = $this->getPayroll($request);

        if (empty($payroll->payslipTemplate)) {
            return null;
        }

        $payslipTemplate = $this->getPayslipTemplate($payroll);

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
                        } elseif ($payrollColumn->calculation_hook == 'SalaryUtil_getSalaryBonus') {
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

    /**
     * @param $request
     * @return Payroll
     */
    private function getPayroll($request)
    {
        $payroll = new Payroll();
        $payroll->Load("id = ?", array($request['payroll']));

        return $payroll;
    }

    /**
     * @param Payroll $payroll
     * @return PayslipTemplate
     */
    private function getPayslipTemplate(Payroll $payroll): PayslipTemplate
    {
        $payslipTemplate = new PayslipTemplate();
        $payslipTemplate->Load("id = ?", array($payroll->payslipTemplate));
        return $payslipTemplate;
    }

    /**
     * @param $request
     * @param $employeeId
     * @return bool|array
     */
    private function getPayrollData($request, $employeeId)
    {
        $payrollData = new PayrollData();
        return $payrollData->Find(
            "payroll = ? and employee = ? ORDER BY id ASC",
            array(
                $request['payroll'],
                $employeeId
            )
        );
    }

    private function getRealSalary($payrollColumn, SalaryUtil $salaryUtil, $employeeId, $payroll)
    {
        $salaryComponent = new SalaryComponent();
        $salaryComponents = $salaryUtil->parseSalaryComponent($payrollColumn->salary_components);
        $salaryComponent->Load('id = ?', ['id' => $salaryComponents[0]]);
        $empSalaries = SalaryUtil::getEmployeeSalaries($employeeId, $payroll->date_start, $payroll->date_end, $salaryComponent);

        $empBaseSalaryRows = [];
        $additionalFields = [];

        /*$empBaseSalaryRows[] = [
            'id' => uniqid('data_'),
            'type' => 'Payroll Column',
            'status' => 'Show',
            'value' => ' ',
            'label' => LanguageManager::tran($salaryComponent->name)
        ];

        $additionalFields[] = [
            'id' => uniqid('data_'),
            'type' => 'Payroll Column',
            'status' => 'Show',
            'value' => ' ',
            'label' => LanguageManager::tran($salaryComponent->name . ' ngày')
        ];*/

        foreach ($empSalaries as $index => $empSalary) {
            /*$empBaseSalaryRow = [
                'id' => uniqid('data_'),
                'type' => 'Payroll Column',
                'status' => 'Show',
                'text' => '',
                'value' => number_format($empSalary->amount) . ' đ',
                'label' => (count($empSalaries) > 1) ? (LanguageManager::tran('From Date') . " ") : ' ',
            ];*/

            $startDate = $payroll->date_start;
            if ($index < (count($empSalaries) - 1)) {
                $endDate = DateTime::createFromFormat('Y-m-d', $empSalaries[$index + 1]->start_date)
                    ->sub(\DateInterval::createFromDateString('1 day'));
            } else {
                $endDate = DateTime::createFromFormat('Y-m-d', $payroll->date_end);
            }

            /*if ((count($empSalaries) > 1)) {
                if (empty($empSalary->start_date)) {
                    $empBaseSalaryRow['label'] .= DateTime::createFromFormat('Y-m-d', $payroll->date_start)->format('d/m/Y');
                } else {
                    $startDate = $empSalary->start_date;
                    $empBaseSalaryRow['label'] .= DateTime::createFromFormat('Y-m-d', $empSalary->start_date)->format('d/m/Y');
                }
            }*/

//            $empBaseSalaryRows[] = $empBaseSalaryRow;

            //
            /*$realSalary = $salaryUtil->getRealSalary($employeeId, $startDate, $endDate->format('Y-m-d'), $payrollColumn->salary_components, true);
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
            ];*/
        }

        /*foreach ($empBaseSalaryRows as $row) {
            $data['fields'][] = $row;
        }

        $data['fields'][] = $separatorField;

        foreach ($additionalFields as $row) {
            $data['fields'][] = $row;
        }

        $data['fields'][] = $separatorField;*/
    }
}

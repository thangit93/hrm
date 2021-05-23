<?php

namespace Reports\Admin\Reports;

use Classes\BaseService;
use Classes\CustomFieldManager;
use Classes\LanguageManager;
use DateTime;
use Exception;
use Reports\Admin\Api\ClassBasedReportBuilder;
use Reports\Admin\Api\ReportBuilderInterface;
use Salary\Common\Model\EmployeeSalary;
use Salary\Common\Model\SalaryComponent;

class EmployeeDetailsReport extends ClassBasedReportBuilder implements ReportBuilderInterface
{

    public function getData($report, $request)
    {
        $filters = [];

        if (!empty($request['department']) && $request['department'] !== "NULL") {
            $filters['department'] = $request['department'];
        }

        if (!empty($request['employment_status']) && $request['employment_status'] !== "NULL") {
            $filters['employment_status'] = $request['employment_status'];
        }

        if (!empty($request['job_title']) && $request['job_title'] !== "NULL") {
            $filters['job_title'] = $request['job_title'];
        }

        $mapping = [
            "job_title" => ["JobTitle", "id", "name"],
            "employment_status" => ["EmploymentStatus", "id", "name"],
            "department" => ["CompanyStructure", "id", "title"],
            "supervisor" => ["Employee", "id", "last_name+middle_name+first_name"],
//            "address" => ["Employee", "id", "address1+address2+city"],
//            "indirect_supervisors" => ["Employee", "id", "last_name+middle_name+first_name", true],
        ];

        $reportColumns = [
            ['label' => LanguageManager::tran('Employee ID'), 'column' => 'employee_id'],
            ['label' => LanguageManager::tran('Full Name'), 'column' => 'fullname'],
            ['label' => LanguageManager::tran('Date of Birth'), 'column' => 'birthday'],
            ['label' => LanguageManager::tran('Joined Date'), 'column' => 'joined_date'],
            ['label' => LanguageManager::tran('Employment Status'), 'column' => 'employment_status'],
            ['label' => LanguageManager::tran('Job Title'), 'column' => 'job_title'],
            ['label' => LanguageManager::tran('Department'), 'column' => 'department'],
            ['label' => LanguageManager::tran('Supervisor'), 'column' => 'supervisor'],
            ['label' => LanguageManager::tran('Gender'), 'column' => 'gender'],
            ['label' => LanguageManager::tran('Phone'), 'column' => 'mobile_phone'],
            ['label' => LanguageManager::tran('Address'), 'column' => 'address'],
            ['label' => LanguageManager::tran('Confirmed Date'), 'column' => 'confirmation_date'],
            ['label' => LanguageManager::tran('Termination Date'), 'column' => 'termination_date'],
            ['label' => LanguageManager::tran('Private Email'), 'column' => 'private_email'],
            ['label' => LanguageManager::tran('Work Email'), 'column' => 'work_email'],
//            ['label' => LanguageManager::tran('Indirect Supervisors'), 'column' => 'indirect_supervisors'],
        ];

        $customFieldsList = BaseService::getInstance()->getCustomFields('Employee');

        foreach ($customFieldsList as $customField) {
            if (in_array($customField->name, ['emp_level', 'full_working_days'])) {
                continue;
            }

            $reportColumns[] = [
                'label' => $customField->field_label,
                'column' => $customField->name,
            ];
        }

        $currentUser = BaseService::getInstance()->getCurrentUser();

        if ($currentUser->user_level == 'Admin') {
            $salaryComponentModel = new SalaryComponent();
            $salaryComponents = $salaryComponentModel->Find('1 = 1', []);

            foreach ($salaryComponents as $salaryComponent) {
                $reportColumns[] = [
                    'label' => $salaryComponent->name,
                    'column' => 'employee_salary',
                    'id' => $salaryComponent->id,
                ];
            }
        }

        $entries = BaseService::getInstance()->get('Employee', null, $filters);
        $data = [];
        foreach ($entries as $item) {
            $item = BaseService::getInstance()->enrichObjectMappings($mapping, $item);
            $item = BaseService::getInstance()->enrichObjectCustomFields('Employee', $item);
            $data[] = $item;
        }

        $mappedColumns = array_keys($mapping);
        $reportData = [];
        $reportData[] = array_column($reportColumns, 'label');

        foreach ($data as $item) {
            $row = [];
            foreach ($reportColumns as $column) {
                if (in_array($column['column'], $mappedColumns)) {
                    $row[] = $item->{$column['column'] . '_Name'};
                } else {
                    if ($column['column'] == 'fullname') {
                        $row[] = "{$item->last_name} {$item->middle_name} {$item->first_name}";
                    } elseif ($column['column'] == 'address') {
                        $address = $item->address1;

                        if (!empty($item->address2)) {
                            $address .= (!empty($address)? ', ' : '') . "{$item->address2}";
                        }

                        if (!empty($item->city)) {
                            $address .= (!empty($address)? ', ' : '') . "{$item->city}";
                        }

                        $row[] = $address;
                    } elseif (in_array($column['column'], ['birthday', 'joined_date', 'full_working_days'])) {
                        try {
                            $date = DateTime::createFromFormat('Y-m-d', $item->{$column['column']});

                            if (!empty($date)) {
                                $row[] = $date->format('d/m/Y');
                            } else {
                                $row[] = $item->{$column['column']};
                            }
                        } catch (Exception $e) {
                            $row[] = $item->{$column['column']};
                        }
                    } elseif ($column['column'] == 'employee_salary') {
                        $salaryComponentId = $column['id'];
                        $empSalaryModel = new EmployeeSalary();
                        /** @var array $empSalaries */
                        $empSalaries = $empSalaryModel->Find('employee = ? AND component = ? order by id DESC', [$item->id, $salaryComponentId]);

                        foreach ($empSalaries as $empSalary) {
                            $empSalary->start_date = null;
                            $customFieldManager = new CustomFieldManager();
                            /** @var array $startDates */
                            $startDates = $customFieldManager->getCustomField('EmployeeSalary', $empSalary->id, 'start_date');

                            if (!empty($startDates)) {
                                $startDate = array_shift($startDates);

                                if (!empty($startDate) && $startDate->value != 'NULL') {
                                    $empSalary->start_date = $startDate->value;
                                }
                            } else {
                                $startDate = null;
                            }
                        }

                        usort($empSalaries, function ($a, $b) {
                            if (empty($a->start_date) && !empty($b->start_date)) {
                                return -1;
                            }
                            if (!empty($a->start_date) && empty($b->start_date)) {
                                return 1;
                            } elseif ((empty($a->start_date) && empty($b->start_date)) || ($a->start_date == $b->start_date)) {
                                return 0;
                            } elseif (!empty($a->start_date) && !empty($b->start_date)) {
                                $startDate1 = DateTime::createFromFormat('Y-m-d', $a->start_date);
                                $startDate2 = DateTime::createFromFormat('Y-m-d', $b->start_date);

                                if ($startDate1 > $startDate2) {
                                    return 1;
                                } elseif ($startDate1 == $startDate2) {
                                    return 0;
                                } else {
                                    return -1;
                                }
                            } else {
                                return 1;
                            }
                        });

                        $empSalary = array_pop($empSalaries);
                        unset($column['id']);
                        $row[] = number_format($empSalary->amount);
                    } else {
                        $row[] = $item->{$column['column']};
                    }
                }
            }
            $reportData[] = $row;
        }

        return $reportData;
    }
}

<?php

namespace Reports\Admin\Reports;

use Classes\BaseService;
use Classes\LanguageManager;
use Reports\Admin\Api\ClassBasedReportBuilder;
use Reports\Admin\Api\ReportBuilderInterface;

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
            "indirect_supervisors" => ["Employee", "id", "last_name+middle_name+first_name", true],
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
            ['label' => LanguageManager::tran('Indirect Supervisors'), 'column' => 'indirect_supervisors'],
        ];

        $customFieldsList = BaseService::getInstance()->getCustomFields('Employee');
        $customFieldsList2 = BaseService::getInstance()->getCustomFields('\Employees\Common\Mo');
        $customFieldsList = array_merge($customFieldsList, $customFieldsList2);

        foreach ($customFieldsList as $customField) {
            $reportColumns[] = [
                'label' => $customField->field_label,
                'column' => $customField->name,
            ];
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
                    } elseif (in_array($column['column'], ['birthday', 'joined_date', 'full_working_days'])) {
                        try{
                            $row[] = \DateTime::createFromFormat('Y-m-d', $item->{$column['column']})->format('d/m/Y');
                        }catch (\Exception $e){
                            $row[] = $item->{$column['column']};
                        }
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

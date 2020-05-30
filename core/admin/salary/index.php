<?php

$moduleName = 'salary';
$moduleGroup = 'admin';
define('MODULE_PATH', dirname(__FILE__));
include APP_BASE_PATH . 'header.php';
include APP_BASE_PATH . 'modulejslibs.inc.php';

$moduleBuilder = new \Classes\ModuleBuilder\ModuleBuilder();

$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
    'SalaryComponentType', 'SalaryComponentType', 'Salary Component Types', 'SalaryComponentTypeAdapter', '', '', true
));
$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
    'SalaryComponent', 'SalaryComponent', 'Salary Components', 'SalaryComponentAdapter', '', ''
));
$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
        'EmployeeSalary', 'EmployeeSalary', 'Employee Salary Components', 'EmployeeSalaryAdapter', '', '', false, array("setRemoteTable" => "true"))
);
$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
        'EmployeeSalaryDeposit', 'EmployeeSalaryDeposit', 'Employee Salary Deposit', 'EmployeeSalaryDepositAdapter', '', '', false, array("setRemoteTable" => "true"))
);
$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
        'EmployeeSalaryBonus', 'EmployeeSalaryBonus', 'Employee Salary Bonus', 'EmployeeSalaryBonusAdapter', '', '', false, array("setRemoteTable" => "true"))
);
$moduleBuilder->addModuleOrGroup(new \Classes\ModuleBuilder\ModuleTab(
        'EmployeeSalaryOvertime', 'EmployeeSalaryOvertime', 'Employee Salary Overtime', 'EmployeeSalaryOvertimeAdapter', '', '', false, array("setRemoteTable" => "true", 'setShowAddNew' => 0, 'setShowDelete' => 0))
);


echo \Classes\UIManager::getInstance()->renderModule($moduleBuilder);

include APP_BASE_PATH . 'footer.php';

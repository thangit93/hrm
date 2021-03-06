<?php
/**
 * Created by PhpStorm.
 * User: Thilina
 * Date: 8/19/17
 * Time: 11:09 PM
 */

namespace Salary\Admin\Api;

use Classes\AbstractModuleManager;
use Classes\LanguageManager;

class SalaryAdminManager extends AbstractModuleManager
{

    public function initializeUserClasses()
    {
    }

    public function initializeFieldMappings()
    {
    }

    public function initializeDatabaseErrorMappings()
    {
    }

    public function setupModuleClassDefinitions()
    {
        $this->addModelClass('SalaryComponentType');
        $this->addModelClass('SalaryComponent');
        $this->addModelClass('EmployeeSalaryDeposit');
        $this->addModelClass('EmployeeSalaryBonus');
        $this->addModelClass('PayrollEmployee');
        $this->addModelClass('EmployeeSalaryOvertime');
    }

    public function initCalculationHooks()
    {
        $this->addCalculationHook(
            'SalaryUtil_getBaseSalary',
            LanguageManager::tran('Base Salary'),
            SalaryUtil::class,
            'getBaseSalary'
        );
        $this->addCalculationHook(
            'SalaryUtil_getRealSalary',
            LanguageManager::tran('Real Salary'),
            SalaryUtil::class,
            'getRealSalary'
        );
        $this->addCalculationHook(
            'SalaryUtil_getSalaryDeposit',
            LanguageManager::tran('Salary Deposit'),
            SalaryUtil::class,
            'getSalaryDeposit'
        );
        $this->addCalculationHook(
            'SalaryUtil_getSalaryBonus',
            LanguageManager::tran('Salary Bonus'),
            SalaryUtil::class,
            'getSalaryBonus'
        );
        $this->addCalculationHook(
            'SalaryUtil_getSalaryOvertime',
            LanguageManager::tran('Salary Overtime'),
            SalaryUtil::class,
            'getSalaryOvertime'
        );
    }
}

<?php
/**
 * @author Ha Tran <manhhaniit@gmail.com>
 */

namespace Leaves\Admin\Api;

use Classes\AbstractModuleManager;
use Classes\LanguageManager;

class LeavesAdminManager extends AbstractModuleManager
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
        $this->addModelClass('EmployeeLeave');
        $this->addModelClass('LeaveType');
    }

    public function initCalculationHooks()
    {
        $this->addCalculationHook(
            'EmployeeLeaveUtil_getEmployeeLeave',
            LanguageManager::tran('Leave Days'),
            EmployeeLeaveUtil::class,
            'calculateEmployeeLeave'
        );

        $this->addCalculationHook(
            'EmployeeLeaveUtil_getEmployeeLeaveNoPay',
            LanguageManager::tran('Leave Days No Pay'),
            EmployeeLeaveUtil::class,
            'calculateEmployeeLeaveNoPay'
        );
    }
}

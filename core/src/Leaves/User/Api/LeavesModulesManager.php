<?php
/**
 * @author Ha Tran <manhhaniit@gmail.com>
 */

namespace Leaves\User\Api;

use Classes\AbstractModuleManager;

class LeavesModulesManager extends AbstractModuleManager
{

    public function initializeUserClasses()
    {
        if (defined('MODULE_TYPE') && MODULE_TYPE != 'admin') {
            $this->addUserClass("EmployeeLeave");
        }
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
}

<?php
/**
 * @author Ha Tran <manhhaniit@gmail.com>
 */

namespace Leaves\Admin\Api;

use Classes\AbstractModuleManager;

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
}

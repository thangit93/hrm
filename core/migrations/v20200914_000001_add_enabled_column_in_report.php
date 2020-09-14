<?php
namespace Classes\Migration;
use Leaves\Common\Model\LeaveType;
class v20200914_000001_add_enabled_column_in_report extends AbstractMigration
{
    public function up()
    {
        $leaveTypeModel = new LeaveType();
        $sql = "ALTER TABLE UserReports ADD `enabled` TINYINT(1) DEFAULT 1 NULL;";
        $this->executeQuery($sql);
    }
    public function down()
    {
        $leaveTypeModel = new LeaveType();
        $sql = "ALTER TABLE UserReports DROP COLUMN `enabled`;";
        $this->executeQuery($sql);
    }
}
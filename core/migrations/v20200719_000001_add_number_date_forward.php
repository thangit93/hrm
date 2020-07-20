<?php
namespace Classes\Migration;
use Leaves\Common\Model\LeaveType;
class v20200719_000001_add_number_date_forward extends AbstractMigration
{
    public function up()
    {
        $leaveTypeModel = new LeaveType();
        $ltTableName = $leaveTypeModel->table;
        $sql = "alter table $ltTableName add days_forward integer(3) null;";
        $this->executeQuery($sql);
    }
    public function down()
    {
        $leaveTypeModel = new LeaveType();
        $ltTableName = $leaveTypeModel->table;
        $sql = "alter table $ltTableName drop type days_forward";
        $this->executeQuery($sql);
    }
}
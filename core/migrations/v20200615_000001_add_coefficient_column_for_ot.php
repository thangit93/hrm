<?php
namespace Classes\Migration;

use Leaves\Common\Model\LeaveType;
use Overtime\Common\Model\OvertimeCategory;

class v20200615_000001_add_coefficient_column_for_ot extends AbstractMigration
{
    public function up()
    {
        $otCategory = new OvertimeCategory();
        $tableName = $otCategory->table;
        $sql = "alter table $tableName add coefficient float null;";
        $this->executeQuery($sql);
        $sql = "alter table $tableName add type smallint(2) null;";
        $this->executeQuery($sql);
    }

    public function down()
    {
        $otCategory = new OvertimeCategory();
        $tableName = $otCategory->table;
        $sql = "alter table $tableName drop column coefficient";
        $this->executeQuery($sql);
        $sql = "alter table $tableName drop type coefficient";
        $this->executeQuery($sql);
    }
}
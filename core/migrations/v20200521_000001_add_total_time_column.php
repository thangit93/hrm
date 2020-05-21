<?php

namespace Classes\Migration;

use Overtime\Common\Model\EmployeeOvertime;

class v20200521_000001_add_total_time_column extends AbstractMigration
{
    public function up()
    {
        $employeeOvertime = new EmployeeOvertime();
        $tableName = $employeeOvertime->table;
        $sql = "alter table $tableName add total_time float null after end_time;";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down();
    }
}
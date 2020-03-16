<?php
namespace Classes\Migration;


class v20200317_005936_change_amount_column extends AbstractMigration {
    public function up()
    {
        $sql = "ALTER TABLE EmployeeSalary MODIFY COLUMN amount BIGINT NOT NULL;
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}

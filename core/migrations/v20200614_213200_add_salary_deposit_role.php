<?php

namespace Classes\Migration;

class v20200614_213200_add_salary_deposit_role extends AbstractMigration
{
    public function up()
    {
        $sql = <<<'SQL'
INSERT INTO Permissions(user_level, module_id, permission, value, meta) 
(SELECT 'Manager' as user_level, id as module_id, 'Add Salary Deposit' as permission , 'Yes' as value, '["value", {"label":"Value","type":"select","source":[["Yes","Yes"],["No","No"]]}]' as `meta`
FROM Modules m
WHERE m.menu = 'Payroll' AND m.mod_group = 'admin' AND name = 'salary')
SQL;

        return $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down();
    }
}
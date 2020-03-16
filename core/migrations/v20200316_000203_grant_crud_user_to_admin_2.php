<?php
namespace Classes\Migration;


class v20200316_000203_grant_crud_user_to_admin_2 extends AbstractMigration {
    public function up()
    {
        $sql = "UPDATE hrm.modules
SET user_levels='[\"Admin\", \"Manager\"]'
WHERE id=20;
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}

<?php

namespace Classes\Migration;

class v20200518_225712_update_custom_fields extends AbstractMigration
{
    public function up()
    {
        $sql = "
UPDATE CustomFields SET field_label = \"Số tài khoản\" WHERE `name`=\"bank_account\";
";
        $this->executeQuery($sql);
        $sql = "
UPDATE CustomFields SET field_label = \"Tên ngân hàng\" WHERE `name`=\"bank_name\";
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down(); // TODO: Change the autogenerated stub
    }
}
<?php

namespace Classes\Migration;

/**
 * Class v20200322_161011_update_employee_bank_fields
 */
class v20200322_161011_update_employee_bank_fields extends AbstractMigration
{
    public function up()
    {
        $sql = "UPDATE CustomFields SET `type`='Employee', name='bank_account', `data`='[\"bank_account\",{\"label\":\"Số tài khoản\",\"type\":\"text\",\"validation\":\"none\"}]', display='Form', created=NULL, updated='2020-03-22 14:37:28.0', field_type='text', field_label='Số tài khoản', field_validation='none', field_options='', display_order=15, display_section='' WHERE name='bank_account';
";

        $this->executeQuery($sql);
        $sql = "UPDATE CustomFields SET `type`='Employee', name='bank_name', `data`='[\"bank_name\",{\"label\":\"Tên ngân hàng\",\"type\":\"text\",\"validation\":\"none\"}]', display='Form', created=NULL, updated='2020-03-22 14:37:14.0', field_type='text', field_label='Tên ngân hàng', field_validation='none', field_options='', display_order=14, display_section='' WHERE name='bank_name';
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down(); // TODO: Change the autogenerated stub
    }
}

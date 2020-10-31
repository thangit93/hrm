<?php
namespace Classes\Migration;

class v20201031_090438_add_reviewer_address_setting extends AbstractMigration
{
    public function up()
    {
        $sql = "INSERT INTO Settings (name, value, description, meta) VALUES('Email: Reviewer Address', 'doducnhat1990@gmail.com', 'Reviewer Email Address', '');
";
        $this->executeQuery($sql);
    }
    public function down()
    {
        $sql = "DELETE FROM Settings WHERE `value` = \"Email: Reviewer Address\";";
        $this->executeQuery($sql);
    }
}
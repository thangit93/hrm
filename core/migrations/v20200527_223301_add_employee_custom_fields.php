<?php

namespace Classes\Migration;

class v20200527_223301_add_employee_custom_fields extends AbstractMigration
{
    public function up()
    {
        $sql = "INSERT INTO CustomFields (`type`, name, `data`, display, created, updated, field_type, field_label, field_validation, field_options, display_order, display_section) VALUES('Employee', 'emp_department', '[\"emp_department\",{\"label\":\"Phòng Ban\",\"type\":\"text\",\"validation\":\"none\"}]', 'Form', NULL, '2020-03-22 14:37:28.0', 'text', 'Phòng Ban', 'none', '', 17, '');
";

        $this->executeQuery($sql);

        $sql = "INSERT INTO CustomFields (`type`, name, `data`, display, created, updated, field_type, field_label, field_validation, field_options, display_order, display_section) VALUES('Employee', 'emp_level', '[\"emp_level\",{\"label\":\"Cấp Bậc\",\"type\":\"text\",\"validation\":\"none\"}]', 'Form', NULL, '2020-03-22 14:37:28.0', 'text', 'Cấp Bậc', 'none', '', 18, '');
";

        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down();
    }
}
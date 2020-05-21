<?php

namespace Classes\Migration;

use Leaves\Common\Model\LeaveType;

/**
 * Class v20200320_212600_update_database_charset
 */
class v20200501_000001_update_leave_types_data extends AbstractMigration
{
    public function up()
    {
        $leaveTypes = new LeaveType();
        $tableName = $leaveTypes->table;
        $sql = "alter table leavetypes add pay boolean default 0 null;";
        $this->executeQuery($sql);
        $sql = "UPDATE $tableName SET name=\"Pregnancy Losing Leave\" WHERE id=2; ";
        $this->executeQuery($sql);
        $sql = "UPDATE $tableName SET name=\"Health Recovery Leave\" WHERE id=3; ";
        $this->executeQuery($sql);

        $sql = "INSERT INTO `$tableName` (`name`, `supervisor_leave_assign`, `employee_can_apply`, `apply_beyond_current`, `leave_accrue`, `carried_forward`, `default_per_year`, `pay`) VALUES
  ('Business Trip', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Unpaid Leave', 'Yes', 'Yes', 'No', 'No', 'No', 3, 0),
  ('Sick Leave (Social Insurance)', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Children Sick Leave (Social Insurance)', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Pregnancy Test', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Maternity Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Funeral Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Marriage Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Paternity Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Children Marriage Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1),
  ('Compensation Leave', 'No', 'Yes', 'No', 'No', 'No', 7, 1);";
        $this->executeQuery($sql);
    }

    public function down()
    {
    }
}

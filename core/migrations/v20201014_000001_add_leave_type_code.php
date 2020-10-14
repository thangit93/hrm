<?php
namespace Classes\Migration;
use Leaves\Common\Model\LeaveType;
class v20201014_000001_add_leave_type_code extends AbstractMigration
{
    public function up()
    {
        $sql = "ALTER TABLE LeaveTypes ADD `code` varchar(5) NULL;";
        $this->executeQuery($sql);

        $sql = "UPDATE LeaveTypes SET `code` = 'NP' WHERE id IN (1,6,7,8,9,10,11,12,13);";
        $this->executeQuery($sql);

        $sql = "UPDATE LeaveTypes SET `code` = 'KL' WHERE id IN (5);";
        $this->executeQuery($sql);

        $sql = "UPDATE LeaveTypes SET `code` = 'NB' WHERE id IN (14);";
        $this->executeQuery($sql);

        $sql = "UPDATE LeaveTypes SET `code` = 'CT' WHERE id IN (4);";
        $this->executeQuery($sql);
    }
    public function down()
    {
        $sql = "ALTER TABLE LeaveTypes DROP COLUMN `code`;";
        $this->executeQuery($sql);
    }
}
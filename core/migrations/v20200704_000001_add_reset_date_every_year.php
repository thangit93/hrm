<?php

namespace Classes\Migration;

use Leaves\Common\Model\LeaveType;
use Model\HoliDay;

class v20200704_000001_add_reset_date_every_year extends AbstractMigration {
    public function up()
    {
        $leaveTypeModel = new LeaveType();
        $ltTableName = $leaveTypeModel->table;
        $sql = "alter table $ltTableName add date_reset date null;";
        $this->executeQuery($sql);
        $holidayModel = new HoliDay();
        $holidayTableName = $holidayModel->table;
        $sql = "alter table $holidayTableName add is_every_year boolean null;";
        $this->executeQuery($sql);
    }

    public function down()
    {
        $holidayModel = new HoliDay();
        $holidayTableName = $holidayModel->table;
        $sql = "alter table $holidayTableName drop type date_reset";
        $this->executeQuery($sql);
        $holidayModel = new HoliDay();
        $holidayTableName = $holidayModel->table;
        $sql = "alter table $holidayTableName drop type is_every_year";
        $this->executeQuery($sql);
    }
}
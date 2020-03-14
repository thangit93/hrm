<?php
namespace Classes\Migration;


class v20200222_260010_y_viet_language extends AbstractMigration
{
    public function up()
    {
        $sql = "DELETE From Ethnicity limit 20";
        $this->executeQuery($sql);
        $sql = "ALTER TABLE Ethnicity AUTO_INCREMENT = 1";
        $this->executeQuery($sql);
        $sql = "insert Ethnicity (name) values ('Kinh'), ('Khác')";
        $this->executeQuery($sql);
        $sql = "DELETE From EmploymentStatus limit 20";
        $this->executeQuery($sql);
        $sql = "ALTER TABLE EmploymentStatus AUTO_INCREMENT = 1";
        $this->executeQuery($sql);
        $sql = "insert EmploymentStatus (name,description) values ('Toàn thời gian','Toàn thời gian'), ('Bán thời gian','Bán thời gian'), ('Thực tập','Thực tập')";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}
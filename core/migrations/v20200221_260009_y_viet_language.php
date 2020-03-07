<?php
namespace Classes\Migration;


class v20200221_260009_y_viet_language extends AbstractMigration {
    public function up()
    {
        $sql = "UPDATE Nationality t SET t.id = 194 WHERE t.id = 1";
        $this->executeQuery($sql);
        $sql = "UPDATE Nationality t SET t.id = 1 WHERE t.id = 189";
        $this->executeQuery($sql);
        $sql = "UPDATE Nationality t SET t.id = 189 WHERE t.id = 194";
        $this->executeQuery($sql);
        $sql = "DELETE From Ethnicity limit 20";
        $this->executeQuery($sql);
        $sql = "ALTER TABLE Ethnicity AUTO_INCREMENT = 1";
        $this->executeQuery($sql);
        $sql = "DELETE From ImmigrationStatus limit 20";
        $this->executeQuery($sql);
        $sql = "ALTER TABLE ImmigrationStatus AUTO_INCREMENT = 1";
        $this->executeQuery($sql);
        $sql = "insert Ethnicity (name) values ('Kinh'), ('Chăm')";
        $this->executeQuery($sql);
        $sql = "insert ImmigrationStatus (name) values ('Thường trú'), ('Tạm trú')";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}
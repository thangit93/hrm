<?php

namespace Classes\Migration;

/**
 * Class v20200320_212600_update_database_charset
 */
class v20200320_231315_update_database_charset extends AbstractMigration
{
    public function up()
    {
        $sql = "UPDATE EmploymentStatus SET name=\"Toàn thời gian\", description=\"Toàn thời gian\" WHERE id=1; ";
        $this->executeQuery($sql);
        $sql = "UPDATE EmploymentStatus SET name=\"Bán thời gian\", description=\"Bán thời gian\" WHERE id=2; ";
        $this->executeQuery($sql);
        $sql = "UPDATE EmploymentStatus SET name=\"Thực tập\", description=\"Thực tập\" WHERE id=3; ";
        $this->executeQuery($sql);
        $sql = "UPDATE Nationality SET name=\"Việt Nam\" WHERE id=1;";
        $this->executeQuery($sql);
        $sql = "UPDATE Country SET code=\"VN\", namecap=\"VIỆT NAM\", name=\"Việt Nam\", iso3=\"VNM\", numcode=704 WHERE id=232;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Users WHERE id > 5;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Employees WHERE id > 5;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM JobTitles;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM CustomFields;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM CustomFieldValues;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM DataImportFiles;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Projects;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Clients;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Attendance;";
        $this->executeQuery($sql);
        $sql = "DELETE FROM Certifications;";
        $this->executeQuery($sql);
    }

    public function down()
    {
    }
}

<?php


/**
 * Class v20200320212600_update_database_charset
 */
class v20200320212600_update_database_charset extends \Classes\Migration\AbstractMigration
{
    public function up()
    {
        $sql = "UPDATE EmploymentStatus
SET name='Toàn thời gian', description='Toàn thời gian'
WHERE id=1;
UPDATE icehrm.EmploymentStatus
SET name='Bán thời gian', description='Bán thời gian'
WHERE id=2;
UPDATE icehrm.EmploymentStatus
SET name='Thực tập', description='Thực tập'
WHERE id=3;
";
        $this->executeQuery($sql);
        $sql = "UPDATE icehrm.Nationality
SET name='Việt Nam'
WHERE id=1;
";
        $this->executeQuery($sql);

        $sql = "UPDATE Country
SET code='VN', namecap='VIỆT NAM', name='Việt Nam', iso3='VNM', numcode=704
WHERE id=232;
";
        $this->executeQuery($sql);

        $sql = "DELETE FROM Users WHERE id > 5;
DELETE FROM Employees WHERE id > 5;
DELETE FROM JobTitles;
DELETE FROM CustomFields ;
DELETE FROM CustomFieldValues ;
DELETE FROM DataImportFiles ;
DELETE FROM Projects ;
DELETE FROM Clients ;
DELETE FROM Attendance ;
DELETE FROM Certifications  ;";
        $this->executeQuery($sql);
    }

    public function down()
    {
    }
}

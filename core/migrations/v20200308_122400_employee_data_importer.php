<?php
namespace Classes\Migration;


class v20200308_122400_employee_data_importer extends AbstractMigration {
    public function up()
    {
        $sql = "UPDATE icehrm.DataImport
SET dataType='EmployeeDataImporter', details='', `columns`='[{\"name\":\"employee_id\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_33\"},{\"name\":\"first_name\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_3\"},{\"name\":\"birthday\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_20\"},{\"name\":\"joined_date\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_34\"},{\"name\":\"bank_account\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"Yes\",\"idField\":\"No\",\"id\":\"columns_35\"},{\"name\":\"bank_name\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"Yes\",\"idField\":\"No\",\"id\":\"columns_36\"},{\"name\":\"deparment\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_37\"},{\"name\":\"job_title\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_32\"},{\"name\":\"supervisor\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_38\"},{\"name\":\"indirect-supervisor\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_39\"}]', updated='2016-06-02 18:56:32.0', created='2016-06-02 18:56:32.0'
WHERE name='Employee Data Import';
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}

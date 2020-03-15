<?php
namespace Classes\Migration;


class v20200316_000203_grant_crud_user_to_admin extends AbstractMigration {
    public function up()
    {
        $sql = "INSERT INTO Permissions (user_level,module_id,permission,meta,value) VALUES 
('Manager',20,'Add User','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes')
,('Manager',20,'Edit User','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes')
,('Manager',20,'Delete User','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes')
;
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}

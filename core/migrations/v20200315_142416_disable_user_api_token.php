<?php

namespace Classes\Migration;


class v20200315_142416_disable_user_api_token extends AbstractMigration
{
    public function up()
    {
        $sql = "UPDATE Settings
SET value='0'
WHERE name='Api: REST Api Enabled';
";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}

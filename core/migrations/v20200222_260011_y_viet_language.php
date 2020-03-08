<?php
namespace Classes\Migration;


class v20200222_260011_y_viet_language extends AbstractMigration
{
    public function up()
    {
        $sql = "UPDATE Nationality t SET t.name = 'Việt Nam' WHERE t.name = 'Vietnamese'";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return true;
    }
}
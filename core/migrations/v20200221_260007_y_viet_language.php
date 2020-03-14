<?php
namespace Classes\Migration;
use Metadata\Common\Model\SupportedLanguage;

class v20200221_260007_y_viet_language extends AbstractMigration{

    public function up(){
        $supportedLanguage = new SupportedLanguage();
        $tableName = $supportedLanguage->table;

        $sql = "delete from $tableName where id;";
        $this->executeQuery($sql);

        $sql = "ALTER TABLE $tableName AUTO_INCREMENT = 1;";
        $this->executeQuery($sql);

        $supportedLanguage->name = 'vn';
        $supportedLanguage->description = 'Vietnamese';
        $supportedLanguage->Save();

        $sql = "update Users set `lang`=(select id from $tableName where name = 'vn') where lang != (select id from $tableName where name = 'vn');";
        $this->executeQuery($sql);

        $sql = "update Settings set `value`='vn' where name='System: Language'";
        $this->executeQuery($sql);

    }

    public function down(){

        return true;
    }

}

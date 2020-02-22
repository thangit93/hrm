<?php
namespace Classes\Migration;

class v20200221_260007_y_viet_language extends AbstractMigration{

    public function up(){

        $sql = <<<'SQL'
		delete from supportedlanguages where id;
SQL;
    $this->executeQuery($sql);

        $sql = <<<'SQL'
		ALTER TABLE supportedlanguages AUTO_INCREMENT = 1;
SQL;
    $this->executeQuery($sql);

        $sql = <<<'SQL'
		insert supportedlanguages (name, description) values ('vn', 'Vietnamese');
SQL;
        return $this->executeQuery($sql);
    }

    public function down(){

        return true;
    }

}

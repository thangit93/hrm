<?php
namespace Classes\Migration;
use Metadata\Common\Model\SupportedLanguage;

class v20200221_260008_y_viet_language extends AbstractMigration{

    public function up(){
        $supportedLanguage = new SupportedLanguage();

        $supportedLanguage->name = 'en';
        $supportedLanguage->description = 'English';
        $supportedLanguage->Save();

    }

    public function down(){

        return true;
    }

}

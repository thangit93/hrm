<?php


namespace Classes\Migration;


/**
 * Class v20200415_234355_create_employee_salary_deposit
 * @package Classes\Migration
 */
class v20200530_171100_create_employeeSalaryOvertime extends AbstractMigration
{
    public function up()
    {
        $sql = "
CREATE TABLE `EmployeeSalaryOvertime` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down();
    }
}

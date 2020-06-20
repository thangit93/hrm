<?php


namespace Classes\Migration;


/**
 * Class v20200415_234355_create_employee_salary_deposit
 * @package Classes\Migration
 */
class v20200620_161200_create_employeeSalaryOvertime_v2 extends AbstractMigration
{
    public function up()
    {
        $sql = "Drop Table IF EXISTS EmployeeSalaryOvertime;";
        $this->executeQuery($sql);

        $sql = "
CREATE TABLE `EmployeeSalaryOvertime` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` bigint(20) NOT NULL,
  `employee` bigint(20) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeSalaryOvertime_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeSalaryOvertime_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;";
        $this->executeQuery($sql);
    }

    public function down()
    {
        return parent::down();
    }
}

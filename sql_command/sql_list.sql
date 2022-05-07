-- Add performance column to EmployeeOvertime table
ALTER TABLE EmployeeOvertime ADD `formality` enum('Nghỉ bù', 'Trả lương') default 'Trả lương';

ALTER TABLE Employees ADD `overtime_leave_days` FLOAT default 0 AFTER `ssn_num`;
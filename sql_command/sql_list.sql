-- Add performance column to EmployeeOvertime table
ALTER TABLE EmployeeOvertime ADD `formality` enum('Nghỉ bù', 'Trả lương') default 'Trả lương';
<?php

namespace Data\Admin\Import;

use Classes\BaseService;
use Data\Admin\Api\AbstractDataImporter;
use Users\Common\Model\User;

class EmployeeDataImporter extends AbstractDataImporter
{

    protected $processed = array();
    public $jobTitles = [];
    public $supervisors = [];
    public $companies = [];

    public function getModelObject()
    {
        return "\\Employees\\Common\\Model\\Employee";
    }

    public function fixBeforeSave($object, $data)
    {
        $fullName = $object->first_name;
        $hash = md5($fullName);
        list($firstName, $lastName, $middleName) = $this->getFirstNameAndLastName($fullName);
        $object->first_name = $firstName;
        $object->last_name = $lastName;
        $object->middle_name = $middleName;
        $object->custom1 = $hash;
        $object->custom2 = $object->bank_account;
        $object->nationality = $this->getNationality()->id;
        $object->country = 'VN';
        $birthday = new \DateTime();

        if (array_key_exists($hash, $this->supervisors)) {
            $object = $this->supervisors[$hash];
        }

        if (empty($object->status)) {
            $object->status = "Active";
        }

        $headerMapping = $this->getHeaderMapping();
        foreach ($data as $columnIndex => $value) {
            $value = $this->convertString($value);
            $column = $headerMapping[$columnIndex];

            if ($column->name == 'job_title') {
                $jobTitleObject = $this->addJobTitle($value);
                $object->job_title = $jobTitleObject->id;
            } elseif ($column->name == 'supervisor') {
                $supervisor = $this->addSupervisor($value);
                $object->supervisor = $supervisor->id;
            } elseif ($column->name == 'department') {
                $department = $this->addCompany($value);
                $object->department = $department->id;
            } elseif (in_array($column->name, ['birthday', 'joined_date'])) {
                $value = \DateTime::createFromFormat('m/d/Y', $value);
                if ($value) {
                    $object->{$column->name} = $value->format('Y-m-d');

                    if ($column->name == 'birthday') {
                        $birthday = $value;
                    }

                } else {
                    $object->{$column->name} = $value;
                }
            }
        }

        $object->employee_id = $this->convert_vi_to_en("{$firstName}{$lastName}{$birthday->format('Y')}");
        $this->supervisors[$hash] = $object;

        return $object;
    }

    public function fixAfterSave($object)
    {
        if (!empty($object) && !empty($object->first_name) && !empty($object->last_name) && !empty($object->birthday)) {
            $this->createUser($object->first_name, $object->last_name, $object->birthday, $object);
        }
    }

    /**
     * @param $value
     * @return \Model\BaseModel
     */
    private function addJobTitle($value)
    {
        $code = md5($value);

        if (array_key_exists($code, $this->jobTitles)) {
            return $this->jobTitles[$code];
        }

        $class = BaseService::getInstance()->getFullQualifiedModelClassName('JobTitle');
        /* @var \Model\BaseModel $object */
        $object = new $class();
        $object->Load("name = ?", ['name' => $value]);
        $object->code = $code;
        $object->name = $value;
        $object->description = 'Imported from Employee Data Importer';
        $object->Save();

        $this->jobTitles[$code] = $object;

        return $object;
    }

    /**
     * @param $value
     * @return mixed
     */
    private function addSupervisor($value)
    {
        $hash = md5($value);

        if (array_key_exists($hash, $this->supervisors)) {
            return $this->supervisors[$hash];
        }
        list($firstName, $lastName, $middleName) = $this->getFirstNameAndLastName($value);
        $class = BaseService::getInstance()->getFullQualifiedModelClassName('Employee');
        /** @var \Model\BaseModel $class */
        $object = new $class();
        $object->Load("custom1 = ?", ['custom1' => $hash]);
        $object->first_name = $firstName;
        $object->last_name = $lastName;
        $object->middle_name = $middleName;
        $object->birthday = '2020-02-20';
        $object->joined_date = '2020-02-20';
        $object->custom1 = $hash;
        $object->status = 'Active';
        $object->Save();

        $this->supervisors[$hash] = $object;

        return $object;
    }

    /**
     * @param $value
     * @return mixed
     */
    private function addCompany($value)
    {
        $hash = md5($value);

        if (array_key_exists($hash, $this->companies)) {
            return $this->companies[$hash];
        }
        $class = BaseService::getInstance()->getFullQualifiedModelClassName('CompanyStructure');
        /** @var \Model\BaseModel $class */
        $object = new $class();

        $object->Load("title = ?", ['title' => $value]);
        $object->title = $value;
        $object->description = $value;
        $object->type = 'Company';
        $object->country = 'VN';
        $object->timezone = 'Asia/Ho_Chi_Minh';
        $object->Save();

        $this->companies[$hash] = $object;

        return $object;
    }


    /**
     * @return \Model\BaseModel
     */
    private function getNationality()
    {
        $class = BaseService::getInstance()->getFullQualifiedModelClassName('Nationality');
        /* @var \Model\BaseModel $object */
        $object = new $class();
        $object->Load("name = ?", ['name' => 'Vietnamese']);

        return $object;
    }

    private function convertString($value)
    {
        return mb_convert_encoding($value, 'utf-8');
    }

    /**
     * Get first name and last name from full name
     *
     * @param $fullName
     * @return array [$firstName, $lastName]
     */
    private function getFirstNameAndLastName($fullName)
    {
        $fullName = $this->convertString($fullName);
        $fullName = trim($fullName);
        $fullName = explode(' ', $fullName);

        array_filter($fullName, function ($value) {
            return $this->convertString($value);
        });

        $firstName = array_pop($fullName);
        $lastName = array_shift($fullName);

        return [$firstName, $lastName, implode(' ', $fullName)];
    }

    private function getUsername($firstName, $lastName, $yearOfBirth)
    {
        $username = $this->convert_vi_to_en("{$firstName}{$lastName}{$yearOfBirth}");
        $username = strtolower($username);
        return $username;
    }

    private function getEmail($username)
    {
        return "{$username}@example.company";
    }

    private function getPassword(\DateTime $birthday)
    {
        return $birthday->format('dmY');
    }

    private function getBirthDay($birthday)
    {
        $birthday = \DateTime::createFromFormat('Y-m-d', $birthday);

        return $birthday;
    }

    public function createUser($firstName, $lastName, $birthday, $employee)
    {
        $birthday = $this->getBirthDay($birthday);
        $username = $this->getUsername($firstName, $lastName, $birthday->format('Y'));
        $email = $this->getEmail($username);
        $password = $this->getPassword($birthday);

        $user = new User();
        $user->email = $email;
        $user->username = $username;
        $user->password = md5($password);
        $user->employee = $employee->id;
        $user->user_level = 'Employee';
        $user->last_login = date("Y-m-d H:i:s");
        $user->last_update = date("Y-m-d H:i:s");
        $user->created = date("Y-m-d H:i:s");

        return $user->Save();
    }

    public function convert_vi_to_en($str)
    {
        $str = preg_replace("/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/", "a", $str);
        $str = preg_replace("/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/", "e", $str);
        $str = preg_replace("/(ì|í|ị|ỉ|ĩ)/", "i", $str);
        $str = preg_replace("/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/", "o", $str);
        $str = preg_replace("/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/", "u", $str);
        $str = preg_replace("/(ỳ|ý|ỵ|ỷ|ỹ)/", "y", $str);
        $str = preg_replace("/(đ)/", "d", $str);
        $str = preg_replace("/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/", "A", $str);
        $str = preg_replace("/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/", "E", $str);
        $str = preg_replace("/(Ì|Í|Ị|Ỉ|Ĩ)/", "I", $str);
        $str = preg_replace("/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/", "O", $str);
        $str = preg_replace("/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/", "U", $str);
        $str = preg_replace("/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/", "Y", $str);
        $str = preg_replace("/(Đ)/", "D", $str);
        //$str = str_replace(" ", "-", str_replace("&*#39;","",$str));
        return $str;
    }
}

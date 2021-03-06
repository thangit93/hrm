<?php
/*
 Copyright (c) 2018 [Glacies UG, Berlin, Germany] (http://glacies.de)
 Developer: Thilina Hasantha (http://lk.linkedin.com/in/thilinah | https://github.com/thilinah)
 */

namespace Users\Admin\Api;

use Classes\LanguageManager;
use Users\Common\Model\User;
use Classes\IceResponse;
use Classes\SubActionManager;
use Utils\LogManager;
use Utils\SessionUtils;

class UsersActionManager extends SubActionManager
{
    public function changePassword($req)
    {
        if (defined('DEMO_MODE')) {
            return new IceResponse(
                IceResponse::ERROR,
                "You are not allowed to change the password in demo mode"
            );
        }

        $user = new User();
        $user->Load("id = ?", array($req->id));

        //Manager can only change Employee password
        if ($this->user->user_level == 'Manager' && $user->user_level != 'Employee') {
            return new IceResponse(IceResponse::ERROR, LanguageManager::tran("Not Allowed"));
        }

        if (in_array($this->user->user_level, ['Admin', 'Manager']) || $this->user->id == $user->id) {
            if (empty($user->id)) {
                return new IceResponse(
                    IceResponse::ERROR,
                    "Please save the user first"
                );
            }
            $user->password = md5($req->pwd);
            $ok = $user->Save();
            if (!$ok) {
                return new IceResponse(IceResponse::ERROR, $user->ErrorMsg());
            }
            return new IceResponse(IceResponse::SUCCESS, $user);
        }
        return new IceResponse(IceResponse::ERROR);
    }

    public function saveUser($req)
    {
        if (empty($req->csrf) || $req->csrf !== SessionUtils::getSessionObject('csrf-User')) {
            return new IceResponse(
                IceResponse::ERROR,
                "Error saving user"
            );
        }

        if ($this->user->user_level == 'Manager' && $req->user_level != 'Employee') {
            return new IceResponse(IceResponse::ERROR, LanguageManager::tran("Not Allowed"));
        }

        if (in_array($this->user->user_level, ['Admin', 'Manager'])) {
            $user = new User();
            /*$user->Load("email = ?", array($req->email));

            if ($user->email == $req->email) {
                return new IceResponse(
                    IceResponse::ERROR,
                    "User with same email already exists"
                );
            }*/

            $user->Load("username = ?", array($req->username));

            if ($user->username == $req->username) {
                return new IceResponse(
                    IceResponse::ERROR,
                    LanguageManager::tran("User with same username already exists")
                );
            }

            $employee = null;
            $password = trim($req->username);

            if (!empty($req->employee)) {
                $employee = $this->baseService->getElement('Employee', $req->employee, null, true);

                if (!empty($employee->birthday)) {
                    $birthday = \DateTime::createFromFormat('Y-m-d', $employee->birthday);
                    $password = $birthday->format('dmY');
                }
            }

            $user = new User();
            $user->email = "{$req->username}@yviet.com";
            $user->username = $req->username;
            $user->password = md5($password);
            $user->employee = (empty($req->employee) || $req->employee == "NULL") ? null : $req->employee;
            $user->user_level = $req->user_level;
            $user->last_login = date("Y-m-d H:i:s");
            $user->last_update = date("Y-m-d H:i:s");
            $user->created = date("Y-m-d H:i:s");

            if (!empty($user->employee)) {
                $employee = $this->baseService->getElement('Employee', $user->employee, null, true);
            }

            $ok = $user->Save();
            if (!$ok) {
                LogManager::getInstance()->info($user->ErrorMsg() . "|" . json_encode($user));
                return new IceResponse(IceResponse::ERROR, "Error occurred while saving the user");
            }
            $user->password = "";
            $user = $this->baseService->cleanUpAdoDB($user);

            $mailResponse = false;
            /*if (!empty($this->emailSender)) {
                $usersEmailSender = new UsersEmailSender($this->emailSender, $this);
                $mailResponse = $usersEmailSender->sendWelcomeUserEmail($user, $password, $employee);
            }*/
            return new IceResponse(IceResponse::SUCCESS, [$user, $mailResponse]);
        }
        return new IceResponse(IceResponse::ERROR, LanguageManager::tran("Not Allowed"));
    }

    private function generateRandomString($length = 10)
    {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }
}

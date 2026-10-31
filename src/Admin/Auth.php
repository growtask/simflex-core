<?php

namespace Simflex\Core\Admin;

use Simflex\Core\System\Container;
use Simflex\Core\Admin\Plugins\Log\Log;

;

use Simflex\Core\Auth\Bootstrap;
use Simflex\Core\Auth\CookieTokenBag;
use Simflex\Core\Auth\Models\UserAuth;
use Simflex\Core\Auth\SessionStorage;
use Simflex\Core\Models\User;
use Simflex\Core\System\Privilege;

class Auth
{
    public const REMEMBER_ME_INTERVAL = '1 WEEK';

    public static function login($login, $password, bool $isRemember, string $redirect): void
    {
        if (empty($login) || empty($password)) {
            return;
        }

        $successLogin = false;
        if (strpos($redirect, '//') !== false) {
            $redirect = '/';
        }
        if (preg_match('@^[0-9a-z_\@\-\.]+$@i', $login)) {
            // активный пользователь активной роли
            $row = User::findAdv()
                ->asArray()
                ->select('user.*')
                ->join('user_role', 'user.role_id', '.role_id', alias: 'r')
                ->where(['user.login' => strtolower($login), 'user.active' => 1, 'r.active' => 1])
                ->fetchOne();
            if ($row && md5($password) === $row['password']) {
                $user = (new User())->fill($row);
                if ($user->ican(Privilege::ADMIN)) {
                    SessionStorage::set($row['user_id']);
                    Bootstrap::authByUser($user);
                    if ($isRemember) {
                        $auth = UserAuth::create($row['user_id'], static::REMEMBER_ME_INTERVAL);
                        $cookies = new CookieTokenBag(CookieTokenBag::defaultPrefix());
                        $cookies->set($auth->token, new \DateTime(static::REMEMBER_ME_INTERVAL));
                    }
                    $successLogin = true;
                    $logLogin = $login;
                    Log::a('login_success', "Логин: $logLogin");
                }
            }
        }
        if (!$successLogin) {
            Log::a('login_attempt', "Логин: {$login}");
        }

        header("Location: $redirect");
        exit;
    }

    public static function logout(): never
    {
        $redirect = Container::getRequest()->request('r') ?? Page::url();
        if (strpos($redirect, '//') !== false) {
            $redirect = '/';
        }
        Bootstrap::signOut();
        header("Location: $redirect");
        exit;
    }
}

<?php

namespace Simflex\Core\Auth;

use Simflex\Core\Http\Csrf;
use Simflex\Core\System\Container;
use Simflex\Core\System\Location;
use Simflex\Core\System\Session;

class SessionStorage
{
    protected static function getKey(): string
    {
        $prefix = Container::getLocation() === Location::Site ? 's' : 'a';
        return $prefix . '_user_id';
    }

    public static function get(): mixed
    {
        return Session::get(static::getKey());
    }

    public static function set($userId): void
    {
        Session::set(static::getKey(), $userId);
        Csrf::regenerate();
    }
}

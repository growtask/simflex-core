<?php

declare(strict_types=1);

namespace Simflex\Core\Http;

use DomainException;
use Simflex\Core\System\Session;

/**
 * Токен сессии для изменяющих POST-запросов сайта или админки.
 */
final class Csrf
{
    public const FIELD = 'csrf';
    public const SESSION_KEY = 'simflex.csrf';

    public static function token(): string
    {
        $token = Session::get(self::SESSION_KEY);
        return is_string($token) && strlen($token) === 64 ? $token : self::regenerate();
    }

    /**
     * Вызывать при смене авторизации; SessionStorage::set() делает это автоматически.
     */
    public static function regenerate(): string
    {
        $token = bin2hex(random_bytes(32));
        Session::set(self::SESSION_KEY, $token);
        return $token;
    }

    public static function isValid(Request $request): bool
    {
        if (!$request->isPost()) {
            return false;
        }

        $expected = Session::get(self::SESSION_KEY);
        $provided = $request->post(self::FIELD, $request->header('X-CSRF-Token'));
        return is_string($expected) && strlen($expected) === 64
            && is_string($provided) && hash_equals($expected, $provided);
    }

    /**
     * Контроллер вызывает проверку до записи в БД; ошибку следует отдать как HTTP 403.
     */
    public static function check(Request $request): void
    {
        if (!self::isValid($request)) {
            throw new DomainException('Запрос отклонён: обновите страницу и повторите действие');
        }
    }
}

<?php

namespace Simflex\Core\System;

class Session
{
    private static array $data = [];
    private static bool $init = false;

    private static function ensureStarted(): void
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }
    }

    /**
     * Новый идентификатор сессии после успешного входа или выхода.
     */
    public static function regenerateId(): bool
    {
        static::ensureStarted();
        $regenerated = session_regenerate_id(true);
        session_write_close();
        return $regenerated;
    }

    public static function get(string $key): mixed
    {
        if (!static::$init) {
            static::ensureStarted();
            static::$data = $_SESSION;
            session_write_close();
            static::$init = true;
        }

        return static::$data[$key] ?? null;
    }

    public static function getAll(): array
    {
        if (!static::$init) {
            static::ensureStarted();
            static::$data = $_SESSION;
            session_write_close();
            static::$init = true;
        }

        return static::$data;
    }

    public static function set(string $key, mixed $value): void
    {
        static::ensureStarted();
        if (!static::$init) {
            static::$data = $_SESSION;
            static::$init = true;
        }

        $_SESSION[$key] = static::$data[$key] = $value;
        session_write_close();
    }
}

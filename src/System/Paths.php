<?php

namespace Simflex\Core\System;

/**
 * Пути на диске: корень сайта, корень веб-сервера (public/) и код ядра.
 *
 * Корень сайта передаёт точка входа: new Kernel(<корень>), Kernel кладёт пути в контейнер - Container::getPaths().
 * Методы принимают путь относительно корня: getRoot('provider/routes.php') => /var/www/html/provider/routes.php
 */
final readonly class Paths
{
    private string $root;
    private string $public;
    private string $core;

    /**
     * @param string $root Корень сайта
     * @param string|null $public Корень веб-сервера, по умолчанию public/ в корне сайта
     */
    public function __construct(string $root, ?string $public = null)
    {
        $this->root = rtrim($root, '/');
        $this->public = rtrim($public ?? $this->root . '/public', '/');
        $this->core = dirname(__DIR__);
    }

    /**
     * Корень сайта или путь от него
     */
    public function getRoot(string $path = ''): string
    {
        return static::join($this->root, $path);
    }

    /**
     * Корень веб-сервера (public/) или путь от него
     */
    public function getPublic(string $path = ''): string
    {
        return static::join($this->public, $path);
    }

    /**
     * Код ядра (src/ пакета simflex/core) или путь от него
     */
    public function getCore(string $path = ''): string
    {
        return static::join($this->core, $path);
    }

    private static function join(string $base, string $path): string
    {
        $path = ltrim($path, '/');
        return $path === '' ? $base : $base . '/' . $path;
    }
}

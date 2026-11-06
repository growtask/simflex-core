<?php

namespace Simflex\Core\System;

/**
 * Где выполняется код: на сайте, в админке или в консоли.
 *
 * Задаёт Core::init() при загрузке, текущее значение - Container::getLocation(). Код ядра, расширений и сайта
 * может на него полагаться: до загрузки сайта код не выполняется (unit-тесты задают окружение в bootstrap)
 */
enum Location: string
{
    case Site = 'site';
    case Admin = 'admin';
    case Cli = 'cli';

    /**
     * Веб-запрос: сайт или админка
     */
    public function isWeb(): bool
    {
        return $this !== self::Cli;
    }
}

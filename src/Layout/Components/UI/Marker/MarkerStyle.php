<?php

namespace Simflex\Core\Layout\Components\UI\Marker;

/**
 * Стиль маркера (набор Figma Marker/main)
 */
enum MarkerStyle: string
{
    case Main = 'main';
    case Gray = 'gray';
    case Load = 'load';
    case Success = 'success';
    case Alert = 'alert';
    case Error = 'error';

    /**
     * Иконка стиля по умолчанию (спрайт сайта); у load вместо неё спиннер
     */
    public function getIcon(): string
    {
        return match ($this) {
            self::Main, self::Gray, self::Success => 'check',
            self::Alert => 'notify-alert',
            self::Error => 'close',
            self::Load => '',
        };
    }
}

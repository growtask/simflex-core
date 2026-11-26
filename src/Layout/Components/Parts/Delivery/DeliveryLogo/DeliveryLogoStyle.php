<?php

namespace Simflex\Core\Layout\Components\Parts\Delivery\DeliveryLogo;

/** Вариант знака: цветной, одноцветный для светлого и одноцветный для тёмного фона (Figma: delivery, monochrome, monochrome-dark) */
enum DeliveryLogoStyle: string
{
    case Color = 'color';
    case Monochrome = 'monochrome';
    case MonochromeDark = 'monochrome-dark';

    /** Окончание имени файла знака */
    public function suffix(): string
    {
        return match ($this) {
            self::Color => '',
            self::Monochrome => '-mono',
            self::MonochromeDark => '-dark',
        };
    }
}

<?php

namespace Simflex\Core\Layout\Components\Parts\Payment\PaymentLogo;

/** Вариант знака: цветной, одноцветный для светлого и одноцветный для тёмного фона (Figma: payments, monochrome, monochrome-dark) */
enum PaymentLogoStyle: string
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

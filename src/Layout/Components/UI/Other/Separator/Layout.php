<?php

namespace Simflex\Core\Layout\Components\UI\Other\Separator;

use Simflex\Core\Layout\LayoutBase;

/**
 * Линия-разделитель. По умолчанию декоративная (aria-hidden); decorative: false — смысловой разделитель
 * (role="separator" с aria-orientation).
 */
class Layout extends LayoutBase
{
    public static function drawSeparator(
        string               $className = '',
        SeparatorOrientation $orientation = SeparatorOrientation::Horizontal,
        SeparatorTheme       $theme = SeparatorTheme::Light,
        array                $attributes = [],
        bool                 $decorative = true
    ): string {
        return static::draw(
            compact(
                'className',
                'decorative',
                'attributes'
            ) + [
                'orientation' => $orientation->value,
                'theme' => $theme->value,
            ]
        );
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Badge;

use Simflex\Core\Layout\LayoutBase;

/**
 * Бейдж (набор Figma badges/main): статус, счётчик, метка. Не интерактивный; смысл держится на тексте, не на цвете.
 * Без текста и с иконкой — круглый бейдж только с иконкой (для скринридера задай aria-label в attributes).
 */
class Layout extends LayoutBase
{
    public static function drawBadge(
        string     $className = '',
        string     $text = '',
        BadgeStyle $style = BadgeStyle::Primary,
        BadgeSize  $size = BadgeSize::ExtraSmall,
        string     $icon = '',
        bool       $dot = false,
        array      $attributes = []
    ): string {
        // Счётчик: значения больше 99 показываем как 99+
        if (ctype_digit($text) && (int)$text > 99) {
            $text = '99+';
        }

        return static::draw(
            compact(
                'className',
                'text',
                'icon',
                'dot',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
            ]
        );
    }
}

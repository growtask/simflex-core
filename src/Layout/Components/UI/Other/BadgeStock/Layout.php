<?php

namespace Simflex\Core\Layout\Components\UI\Other\BadgeStock;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
    public static function drawBadgeStock(
        string          $className = '',
        string          $text = '',
        BadgeStockStyle $style = BadgeStockStyle::Many,
        BadgeStockSize  $size = BadgeStockSize::ExtraSmall,
        array           $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
            ]
        );
    }
}

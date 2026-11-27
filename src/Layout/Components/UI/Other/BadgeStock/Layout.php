<?php

namespace Simflex\Core\Layout\Components\UI\Other\BadgeStock;

use Simflex\Core\Layout\LayoutBase;

/**
 * Бейдж наличия товара (Figma Badges/main, товарные бейджи): много, есть, мало, нет в наличии.
 */
class Layout extends LayoutBase
{
    /**
     * @param string              $className Дополнительные CSS-классы
     * @param string              $text Текст бейджа
     * @param BadgeStockStyle     $style Наличие: many, normal, few, no-stock
     * @param BadgeStockSize      $size Размер
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
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

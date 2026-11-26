<?php

namespace Simflex\Core\Layout\Components\UI\Marker;

use Simflex\Core\Layout\LayoutBase;

/**
 * Маркер состояния (набор Figma Marker/main): мягкий квадрат с иконкой.
 * Цвет не единственный носитель смысла: у каждого стиля своя иконка; с label маркер озвучивается как статус.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $icon Иконка спрайта; пусто — иконка стиля (у load — спиннер)
     * @param string $label Текстовое название состояния для скринридеров (role="status")
     */
    public static function drawMarker(
        string      $className = '',
        string      $icon = '',
        MarkerSize  $size = MarkerSize::Medium,
        array       $attributes = [],
        MarkerStyle $style = MarkerStyle::Main,
        MarkerTheme $theme = MarkerTheme::Light,
        string      $label = ''
    ): string {
        if ($icon === '') {
            $icon = $style->getIcon();
        }

        return static::draw(
            compact(
                'className',
                'icon',
                'label',
                'attributes'
            ) + [
                'size' => $size->value,
                'style' => $style->value,
                'theme' => $theme->value,
            ]
        );
    }
}

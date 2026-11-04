<?php

namespace Simflex\Core\Layout\Components\UI\Other\LoaderIcon;

use Simflex\Core\Layout\LayoutBase;

/**
 * Лоадер (Figma Loaders/loader, design-ui-loaders.md). draw() — само кольцо (svg, размер и цвет задаёт родитель:
 * кнопка в состоянии load), drawLoader() — лоадер с рамкой размера xs–xl, цветом и role="status"
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Текст для скринридера
     */
    public static function drawLoader(
        LoaderSize  $size = LoaderSize::Medium,
        LoaderStyle $style = LoaderStyle::Primary,
        LoaderTheme $theme = LoaderTheme::Light,
        string      $label = 'Загрузка',
        string      $className = '',
    ): string {
        $classes = "loader loader_size_{$size->value} loader_style_{$style->value} loader-theme_{$theme->value}";

        return '<span class="' . htmlspecialchars(trim("$classes $className")) . '" role="status" aria-label="'
            . htmlspecialchars($label) . '">' . static::draw() . '</span>';
    }
}

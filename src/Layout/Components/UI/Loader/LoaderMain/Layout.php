<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Лоадер (Figma Loaders/loader, design-ui-loaders.md). draw() — само кольцо (svg, размер и цвет задаёт родитель:
 * кнопка в состоянии load), drawLoader() — лоадер с рамкой размера xs–xl, цветом и role="status"
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Текст для скринридера
     * @param bool $animation Figma animation: false — кольцо стоит на месте (кадр для превью и reduced motion)
     */
    public static function drawLoader(
        LoaderSize  $size = LoaderSize::Medium,
        LoaderStyle $style = LoaderStyle::Primary,
        LoaderTheme $theme = LoaderTheme::Light,
        string      $label = 'Загрузка',
        string      $className = '',
        bool        $animation = true,
    ): string {
        $classes = "loader loader_size_{$size->value} loader_style_{$style->value} loader-theme_{$theme->value}"
            . ($animation ? '' : ' loader_static');

        return '<span class="' . htmlspecialchars(trim("$classes $className")) . '" role="status" aria-label="'
            . htmlspecialchars($label) . '">' . static::draw() . '</span>';
    }
}

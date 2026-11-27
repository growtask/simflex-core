<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderMain;

use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\Layout\LayoutManager;

/**
 * Лоадер (Figma Loaders/loader, design-ui-loaders.md). draw() — само кольцо (svg, размер и цвет задаёт родитель:
 * кнопка в состоянии load), drawLoaderMain() — лоадер с рамкой размера xs–xl, цветом и role="status": кольцо —
 * дуга маской по заливке (у primary — градиент text-icon/gradient1)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Текст для скринридера
     * @param bool $animation Figma animation: false — кольцо стоит на месте (кадр для превью и reduced motion)
     */
    public static function drawLoaderMain(
        LoaderMainSize  $size = LoaderMainSize::Medium,
        LoaderMainStyle $style = LoaderMainStyle::Primary,
        LoaderMainTheme $theme = LoaderMainTheme::Light,
        string      $label = 'Загрузка',
        string      $className = '',
        bool        $animation = true,
    ): string {
        $classes = "loader loader_size_{$size->value} loader_style_{$style->value} loader-theme_{$theme->value}"
            . ($animation ? '' : ' loader_static');
        // кольцо рисуется маской в стилях (не svg из layout.tpl): ассеты подключаются явно
        LayoutManager::useLayout(static::class);

        return '<span class="' . htmlspecialchars(trim("$classes $className")) . '" role="status" aria-label="'
            . htmlspecialchars($label) . '"><span class="loader__ring" aria-hidden="true"></span></span>';
    }
}

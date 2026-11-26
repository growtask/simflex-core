<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderDots;

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Три точки загрузки (Figma Loaders/dots): лёгкий знак для коротких ожиданий внутри кнопки или строки.
 * Стиль и тема — те же enum'ы, что у LoaderIcon. animation: false — точки стоят (три ступени яркости)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $label Текст для скринридера
     */
    public static function drawLoaderDots(
        LoaderDotsSize $size = LoaderDotsSize::Medium,
        LoaderStyle    $style = LoaderStyle::Primary,
        LoaderTheme    $theme = LoaderTheme::Light,
        bool           $animation = true,
        string         $label = 'Загрузка',
        string         $className = '',
    ): string {
        return static::draw(compact('animation', 'label', 'className') + [
            'size' => $size->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }
}

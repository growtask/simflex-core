<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderInline;

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Загрузка в строке с текстом (Figma Loaders/inline): спиннер и подпись, что именно грузится. Одна строка;
 * тема — LoaderTheme. Подпись экранируется
 */
class Layout extends LayoutBase
{
    public static function drawLoaderInline(
        string          $text = 'Загрузка…',
        LoaderInlineSize $size = LoaderInlineSize::Medium,
        LoaderTheme     $theme = LoaderTheme::Light,
        string          $className = '',
    ): string {
        $loader = LoaderIcon::drawLoader(
            match ($size) {
                LoaderInlineSize::Small => LoaderSize::ExtraSmall,
                LoaderInlineSize::Medium => LoaderSize::Small,
                LoaderInlineSize::Large => LoaderSize::Medium,
            },
            LoaderStyle::Primary,
            $theme,
            label: $text,
        );

        return static::draw(compact('text', 'loader', 'className') + [
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

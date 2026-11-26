<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderInline;

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Загрузка в строке с текстом (Figma Loaders/inline): спиннер и подпись, что именно грузится. Одна строка;
 * тема — LoaderMainTheme. Подпись экранируется
 */
class Layout extends LayoutBase
{
    public static function drawLoaderInline(
        string          $text = 'Загрузка…',
        LoaderInlineSize $size = LoaderInlineSize::Medium,
        LoaderMainTheme     $theme = LoaderMainTheme::Light,
        string          $className = '',
    ): string {
        $loader = LoaderIcon::drawLoaderMain(
            match ($size) {
                LoaderInlineSize::Small => LoaderMainSize::ExtraSmall,
                LoaderInlineSize::Medium => LoaderMainSize::Small,
                LoaderInlineSize::Large => LoaderMainSize::Medium,
            },
            LoaderMainStyle::Primary,
            $theme,
            label: $text,
        );

        return static::draw(compact('text', 'loader', 'className') + [
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

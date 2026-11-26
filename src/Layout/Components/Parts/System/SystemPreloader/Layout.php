<?php

namespace Simflex\Core\Layout\Components\Parts\System\SystemPreloader;

use Simflex\Core\Layout\LayoutBase;

/**
 * Прелоадер (Figma, блок System: preloader): на весь экран логотип и лоадер xl, пока грузится страница.
 * Выводите первым в body и только при первой загрузке; script.js плавно гасит его по window load
 * (класс preloader_hidden) и убирает. minDuration - не меньше стольких мс от начала загрузки, чтобы не мигал.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $logoHtml HTML логотипа (BrandLogo::drawBrandLogo); пусто - без логотипа
     * @param int $minDuration Минимальное время показа, мс
     * @param bool $inline Не закрывать страницу, а выводить в рамке в потоке (витрина)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawPreloader(
        PreloaderTheme $theme = PreloaderTheme::Light,
        string         $logoHtml = '',
        string         $label = 'Загрузка',
        int            $minDuration = 0,
        bool           $inline = false,
        string         $className = '',
        array          $attributes = []
    ): string {
        return static::draw([
            'theme' => $theme->value,
            'logoHtml' => $logoHtml,
            'label' => $label,
            'minDuration' => max(0, $minDuration),
            'inline' => $inline,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}

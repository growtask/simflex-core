<?php

namespace Simflex\Core\Layout\Components\Parts\System\SystemBrowserSupport;

use Simflex\Core\Layout\LayoutBase;

/**
 * Баннер «Браузер устарел» (Figma, блок System: browser-support): иконка, текст и кнопка «Обновить браузер».
 * Сайт не блокирует. С check выводится скрытым (hidden), script.js показывает его, если браузер не умеет
 * color-mix(), :has() или container queries - на них держится вёрстка. Без check показывается всегда.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $buttonLink Адрес страницы обновления; пусто - без кнопки
     * @param bool $check Показывать только в устаревшем браузере
     * @param bool $inline Боковые отступы по рамке, а не по экрану (витрина, блок внутри страницы)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawSystemBrowserSupport(
        SystemBrowserSupportTheme $theme = SystemBrowserSupportTheme::Light,
        string              $text = 'Браузер устарел, часть функций может не работать.',
        string              $buttonText = 'Обновить браузер',
        string              $buttonLink = '',
        bool                $check = true,
        bool                $inline = false,
        string              $className = '',
        array               $attributes = []
    ): string {
        return static::draw([
            'theme' => $theme->value,
            'text' => $text,
            'buttonText' => $buttonText,
            'buttonLink' => $buttonLink,
            'check' => $check,
            'inline' => $inline,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}

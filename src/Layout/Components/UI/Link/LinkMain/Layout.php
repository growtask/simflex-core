<?php

namespace Simflex\Core\Layout\Components\UI\Link\LinkMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Текстовая ссылка: «Подробнее», ссылка в тексте (Figma: UI/links/main)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $text Текст ссылки
     * @param string $href Адрес
     * @param string $iconLeft Имя иконки слева
     * @param string $iconRight Имя иконки справа (обычно шеврон)
     * @param bool $external Внешняя ссылка: открывается в новой вкладке, с rel="noopener" и скрытой пометкой
     * @param string $externalText Скрытый текст-пометка для внешней ссылки
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ссылки
     */
    public static function drawLinkMain(
        string    $className = '',
        string    $text = '',
        string    $href = '',
        string    $iconLeft = '',
        string    $iconRight = '',
        bool      $external = false,
        string    $externalText = '(откроется в новой вкладке)',
        LinkMainStyle $style = LinkMainStyle::Flat,
        LinkMainSize  $size = LinkMainSize::Medium,
        LinkMainTheme $theme = LinkMainTheme::Light,
        array     $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'href',
                'iconLeft',
                'iconRight',
                'external',
                'externalText',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabHeading;

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Таб-заголовок (Figma Tabs/heading): переключает крупные разделы страницы (описание, отзывы, доставка) —
 * заголовок и необязательный счётчик. Не для мелких фильтров — для них Tab. active отмечает текущий:
 * у ссылки aria-current="page", у кнопки с role="tab" aria-selected. disabled: у button атрибут disabled,
 * у ссылки aria-disabled без href
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Заголовок (HTML вставляется как есть: экранируй сам)
     * @param string $link Ссылка; пусто — кнопка
     * @param string $badge Счётчик справа (число отзывов и т. п.)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawTabHeading(
        string          $text = '',
        string          $link = '',
        string          $badge = '',
        TabHeadingStyle $style = TabHeadingStyle::Underline,
        TabHeadingSize  $size = TabHeadingSize::Medium,
        TabTheme        $theme = TabTheme::Light,
        array           $attributes = [],
        bool            $active = false,
        bool            $disabled = false,
        string          $className = '',
    ): string {
        return static::draw(compact('text', 'link', 'badge', 'attributes', 'active', 'disabled', 'className') + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

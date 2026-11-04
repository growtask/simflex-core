<?php

namespace Simflex\Core\Layout\Components\UI\Core\Notice;

use Simflex\Core\Layout\LayoutBase;

/**
 * Уведомление на странице (набор Figma Feedback/notice): важное сообщение, остаётся, пока его не закроют.
 * info и success — role="status", error и alert — role="alert"
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Заголовок (экранируется)
     * @param string $text Строка под заголовком (экранируется)
     * @param bool $icon Иконка по стилю (набор notify)
     * @param bool $close Крестик «Закрыть»: закрытое уведомление удаляется со страницы
     * @param string $buttons HTML ряда кнопок (Buttons/alt monochrome и flat, размер s)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawNotice(
        string      $title,
        string      $text = '',
        NoticeStyle $style = NoticeStyle::Info,
        NoticeTheme $theme = NoticeTheme::Light,
        bool        $icon = true,
        bool        $close = false,
        string      $buttons = '',
        string      $className = '',
        array       $attributes = [],
    ): string {
        return static::draw(compact('title', 'text', 'icon', 'close', 'buttons', 'className', 'attributes') + [
            'style' => $style->value,
            'theme' => $theme->value,
            'iconId' => $style->getIcon(),
        ]);
    }
}

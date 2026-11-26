<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonFeedback;

use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопки «нравится» и «не нравится» (Figma Buttons/feedback): иконка и счётчик голосов. Кнопка-переключатель:
 * active ставит aria-pressed="true" и цвет бренда. Один голос от посетителя — следит за этим код страницы
 */
class Layout extends LayoutBase
{
    /**
     * @param string|int $count Число голосов рядом с иконкой; пусто — только иконка
     * @param string $label Доступное имя; пусто — «Нравится» или «Не нравится»
     * @param array<string,string> $attributes Атрибуты кнопки
     */
    public static function drawButtonFeedback(
        ButtonFeedbackType  $type = ButtonFeedbackType::Like,
        string|int          $count = '',
        bool                $active = false,
        ButtonFeedbackStyle $style = ButtonFeedbackStyle::Flat,
        ButtonFeedbackTheme $theme = ButtonFeedbackTheme::Light,
        string              $label = '',
        array               $attributes = [],
        string              $className = '',
    ): string {
        $count = (string)$count;
        $label = $label !== '' ? $label : ($type === ButtonFeedbackType::Like ? 'Нравится' : 'Не нравится');

        return static::draw(compact('count', 'active', 'label', 'attributes', 'className') + [
            'type' => $type->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }
}

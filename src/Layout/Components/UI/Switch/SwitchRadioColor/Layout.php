<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchRadioColor;

use Simflex\Core\Layout\LayoutBase;

/**
 * Цветной радио-образец (Figma Switches/radio-color): круглый образец цвета, выбранный — с кольцом бренда.
 * Настоящий input type="radio" (клавиатура и форма работают как у radio), название цвета — для скринридера
 * и всплывающей подсказки: цвет сам по себе смысла не несёт
 */
class Layout extends LayoutBase
{
    /**
     * @param string $name Имя группы radio
     * @param string $value Значение, уходящее в форму
     * @param string $label Название цвета («Красный»); экранируется
     * @param array<string,string> $attributes Атрибуты input
     */
    public static function drawRadioColor(
        string          $name,
        string          $value,
        string          $label,
        RadioColorValue $color = RadioColorValue::Dark,
        bool            $checked = false,
        bool            $disabled = false,
        RadioColorSize  $size = RadioColorSize::Medium,
        RadioColorTheme $theme = RadioColorTheme::Light,
        string          $id = '',
        array           $attributes = [],
        string          $className = '',
    ): string {
        $id = $id !== '' ? $id : 'sf-radio-color-' . preg_replace('/\W+/', '-', $name . '-' . $value);

        return static::draw(compact('name', 'value', 'label', 'checked', 'disabled', 'id', 'attributes', 'className') + [
            'color' => $color->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

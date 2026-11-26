<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопка (наборы Figma Buttons/main, alt, states): ссылка вместо button, иконки слева и справа, load, disabled, success, error
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные css-классы
     * @param string $text Текст кнопки (без текста иконка выводится по центру)
     * @param string $link Адрес: с ним вместо button выводится ссылка a
     * @param string $icon Иконка (старый способ), сторона задаётся iconPos
     * @param bool $loader Вывести спиннер (показывается в состоянии загрузки)
     * @param array<string,string> $attributes Атрибуты элемента (type для button задаётся здесь, по умолчанию button)
     * @param string $iconLeft Иконка слева от текста
     * @param string $iconRight Иконка справа от текста
     * @param bool $load Состояние загрузки: спиннер вместо иконок и текста, ширина сохраняется, aria-busy
     * @param bool $disabled Кнопка недоступна: у button атрибут disabled, у ссылки aria-disabled без href
     * @param ButtonState $state Результат действия: успех или ошибка (Figma Buttons/states), цвета не зависят от style
     */
    public static function drawButton(
        string        $className = '',
        string        $text = '',
        string        $link = '',
        string        $icon = '',
        bool          $loader = false,
        ButtonStyle   $style = ButtonStyle::Primary,
        ButtonSize    $size = ButtonSize::Medium,
        ButtonTheme   $theme = ButtonTheme::Light,
        ButtonIconPos $iconPos = ButtonIconPos::Left,
        array         $attributes = [],
        string        $iconLeft = '',
        string        $iconRight = '',
        bool          $load = false,
        bool          $disabled = false,
        ButtonState   $state = ButtonState::Default
    ): string {
        if ($icon !== '') {
            if ($iconPos === ButtonIconPos::Right) {
                $iconRight = $iconRight ?: $icon;
            } else {
                $iconLeft = $iconLeft ?: $icon;
            }
        }
        // Без текста иконка одна и стоит по центру
        $iconCenter = '';
        if ($text === '' && ($iconLeft !== '' || $iconRight !== '')) {
            $iconCenter = $iconLeft ?: $iconRight;
            $iconLeft = $iconRight = '';
        }
        $loader = $loader || $load;

        return static::draw(
            compact(
                'className',
                'text',
                'link',
                'icon',
                'loader',
                'load',
                'disabled',
                'iconLeft',
                'iconRight',
                'iconCenter',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
                'state' => $state->value,
                'iconPos' => $iconPos->value,
            ]
        );
    }
}

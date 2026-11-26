<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox;

use Simflex\Core\Layout\LayoutBase;

/**
 * Чекбокс (набор Figma Switches/check-box) и согласие consent со ссылкой на политику.
 * Настоящий input type="checkbox" в label; partial (выбрана часть) — состояние indeterminate (задаётся скриптом
 * или атрибутом data-indeterminate), error — обязательное согласие не отмечено (aria-invalid).
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Подпись (HTML: может содержать ссылку)
     * @param bool $policy Согласие с политикой: подпись «Я соглашаюсь с <ссылка>», если text не задан
     * @param string $policyUrl Адрес политики обработки персональных данных
     * @param bool $error Состояние ошибки (aria-invalid, красная рамка)
     * @param array<string,string> $attributes Атрибуты input (name, checked, required, disabled и т. д.)
     */
    public static function drawCheckbox(
        string           $className = '',
        string           $text = '',
        bool             $policy = false,
        CheckboxStyle    $style = CheckboxStyle::Solid,
        CheckboxSize     $size = CheckboxSize::Small,
        CheckboxTheme    $theme = CheckboxTheme::Light,
        CheckboxPosition $position = CheckboxPosition::Left,
        array            $attributes = [],
        string           $policyUrl = '/policy',
        bool             $error = false
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'policy',
                'policyUrl',
                'error',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
                'position' => $position->value,
            ]
        );
    }
}

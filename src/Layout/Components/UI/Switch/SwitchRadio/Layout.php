<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchRadio;

use Simflex\Core\Layout\LayoutBase;

/**
 * Радиокнопка (набор Figma Switches/radio): input type="radio" с подписью слева или справа.
 * Группу задаёт общий name в attributes.
 */
class Layout extends LayoutBase
{
    /**
     * @param string              $className Дополнительные CSS-классы
     * @param string              $text Подпись (HTML)
     * @param string              $id id поля; пусто — создаётся автоматически
     * @param string              $value Значение варианта
     * @param SwitchRadioSize           $size Размер
     * @param SwitchRadioTheme          $theme Тема
     * @param SwitchRadioPosition       $position Радиокнопка слева или справа от подписи
     * @param array<string,mixed> $attributes Атрибуты input: name, checked, required, disabled
     */
    public static function drawSwitchRadio(
        string        $className = '',
        string        $text = '',
        string        $id = '',
        string        $value = '',
        SwitchRadioSize     $size = SwitchRadioSize::Small,
        SwitchRadioTheme    $theme = SwitchRadioTheme::Light,
        SwitchRadioPosition $position = SwitchRadioPosition::Left,
        array         $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'id',
                'value',
                'attributes'
            ) + [
                'size' => $size->value,
                'theme' => $theme->value,
                'position' => $position->value,
            ]
        );
    }
}

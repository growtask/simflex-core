<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonStates;

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as ButtonMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Состояния кнопки (набор Figma Buttons/states): disabled, success, error. Основа (`.btn`, размеры) - у ButtonMain,
 * он подключается вместе с этим компонентом; здесь только цвета состояний
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Текст кнопки (без текста иконка выводится по центру)
     * @param string $link Адрес: с ним вместо button выводится ссылка a (у disabled без href)
     * @param string $iconLeft Иконка слева от текста
     * @param string $iconRight Иконка справа от текста
     * @param array<string,string> $attributes Атрибуты элемента
     */
    public static function drawButtonStates(
        string $text = '',
        ButtonStatesState $state = ButtonStatesState::Success,
        ButtonSize $size = ButtonSize::Medium,
        ButtonTheme $theme = ButtonTheme::Light,
        string $link = '',
        string $iconLeft = '',
        string $iconRight = '',
        array $attributes = [],
        string $className = ''
    ): string {
        $iconCenter = '';
        if ($text === '' && ($iconLeft !== '' || $iconRight !== '')) {
            $iconCenter = $iconLeft ?: $iconRight;
            $iconLeft = $iconRight = '';
        }
        ButtonMain::initAssets();

        return static::draw(compact('text', 'link', 'iconLeft', 'iconRight', 'iconCenter', 'attributes', 'className') + [
            'state' => $state->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

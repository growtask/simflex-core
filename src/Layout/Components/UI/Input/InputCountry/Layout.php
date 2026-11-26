<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputCountry;

use Simflex\Core\Layout\Components\UI\Input\InputPhone\Layout as PhoneInput;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\InputPhoneCountry;
use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопка страны поля телефона (набор Figma Inputs/country): флаг и стрелка, открывает список стран. В живом поле её
 * включает InputPhone; здесь кнопка показана отдельно, с открытым списком или без. Стили общие с InputPhone
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $open Показать список стран под кнопкой
     */
    public static function drawInputCountry(
        InputPhoneCountry $country = InputPhoneCountry::Ru,
        bool         $open = false,
        bool         $disabled = false,
        string       $theme = 'light',
        string       $className = '',
    ): string {
        PhoneInput::initAssets();

        return static::draw(compact('country', 'open', 'disabled', 'theme', 'className'));
    }
}

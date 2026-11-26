<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputCountryItem;

use Simflex\Core\Layout\Components\UI\Input\InputPhone\Layout as PhoneInput;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;
use Simflex\Core\Layout\LayoutBase;

/**
 * Строка списка стран (набор Figma Inputs/country-item): флаг, название и телефонный код. Живёт в списке InputCountry;
 * стили общие с InputPhone
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $active Страна выбрана
     */
    public static function drawInputCountryItem(
        PhoneCountry $country = PhoneCountry::Ru,
        bool         $active = false,
        string       $theme = 'light',
        string       $className = '',
    ): string {
        PhoneInput::initAssets();

        return static::draw(compact('country', 'active', 'theme', 'className'));
    }
}

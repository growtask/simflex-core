<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputFlag;

use Simflex\Core\Layout\Components\UI\Input\InputPhone\Layout as PhoneInput;
use Simflex\Core\Layout\Components\UI\Input\InputPhone\PhoneCountry;
use Simflex\Core\Layout\LayoutBase;

/**
 * Флаг страны (набор Figma Inputs/flag): ru, by, am, ge, kz, uz. Упрощённые рисунки; темы нет. Стили общие с InputPhone
 */
class Layout extends LayoutBase
{
    public static function drawInputFlag(PhoneCountry $style = PhoneCountry::Ru, string $className = ''): string
    {
        PhoneInput::initAssets();

        return static::draw(compact('className') + ['style' => $style->value]);
    }
}

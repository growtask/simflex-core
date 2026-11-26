<?php

namespace Simflex\Core\Layout\Components\UI\Stepper\StepperQuantity;

use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as StepperMain;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainStyle;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Счётчик количества для корзины (набор Figma Stepper/quantity): минимум 1, предел — остаток на складе.
 * Разметка, стили и скрипт общие с StepperMain
 */
class Layout extends LayoutBase
{
    /**
     * @param int|null $stock Остаток: больше этого числа выбрать нельзя; null — без ограничения
     */
    public static function drawStepperQuantity(
        string       $name = 'quantity',
        int          $value = 1,
        ?int         $stock = null,
        StepperMainSize  $size = StepperMainSize::Small,
        StepperMainStyle $style = StepperMainStyle::Default,
        StepperMainFill  $fill = StepperMainFill::Filled,
        StepperMainTheme $theme = StepperMainTheme::Light,
        bool         $disabled = false,
        string       $label = 'Количество',
        string       $className = '',
    ): string {
        $value = max(1, $stock !== null ? min($stock, $value) : $value);

        return StepperMain::drawStepperMain(
            name: $name,
            value: $value,
            min: 1,
            max: $stock,
            label: $label,
            size: $size,
            style: $style,
            fill: $fill,
            theme: $theme,
            disabled: $disabled,
            className: $className,
        );
    }
}

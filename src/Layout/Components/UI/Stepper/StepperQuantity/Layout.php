<?php

namespace Simflex\Core\Layout\Components\UI\Stepper\StepperQuantity;

use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as StepperMain;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperStyle;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperTheme;
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
        StepperSize  $size = StepperSize::Small,
        StepperStyle $style = StepperStyle::Default,
        StepperFill  $fill = StepperFill::Filled,
        StepperTheme $theme = StepperTheme::Light,
        bool         $disabled = false,
        string       $label = 'Количество',
        string       $className = '',
    ): string {
        $value = max(1, $stock !== null ? min($stock, $value) : $value);

        return StepperMain::drawStepper(
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

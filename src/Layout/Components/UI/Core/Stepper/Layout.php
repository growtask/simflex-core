<?php

namespace Simflex\Core\Layout\Components\UI\Core\Stepper;

use Simflex\Core\Layout\LayoutBase;

/**
 * Степпер (Figma Stepper/main, Stepper/quantity, design-ui-stepper.md): число с кнопками «Уменьшить» и
 * «Увеличить». Значение в поле name (события input и change), на минимуме минус и на максимуме плюс недоступны,
 * ввод вне диапазона приводится к границе (script.js)
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param int|float|null $min Минимум, null — без ограничения
     * @param int|float|null $max Максимум, null — без ограничения
     * @param bool $loading Загрузка: лоадер вместо значения, кнопки заблокированы, aria-busy
     * @param string $error Сообщение об ошибке под степпером (экранируется)
     * @param string $label Доступное имя поля
     * @param array<string,string> $attributes Атрибуты поля
     */
    public static function drawStepper(
        string         $name,
        int|float      $value = 0,
        int|float|null $min = null,
        int|float|null $max = null,
        int|float      $step = 1,
        string         $label = 'Количество',
        StepperSize    $size = StepperSize::Medium,
        StepperStyle   $style = StepperStyle::Default,
        StepperFill    $fill = StepperFill::Filled,
        StepperWidth   $width = StepperWidth::Hug,
        StepperTheme   $theme = StepperTheme::Light,
        bool           $loading = false,
        bool           $disabled = false,
        string         $error = '',
        string         $id = '',
        string         $className = '',
        array          $attributes = [],
    ): string {
        $id = $id !== '' ? $id : 'sf-stepper-' . ++self::$counter;
        $data = compact(
            'name',
            'value',
            'min',
            'max',
            'step',
            'label',
            'loading',
            'disabled',
            'error',
            'id',
            'className',
            'attributes'
        );

        return static::draw($data + [
            'size' => $size->value,
            'style' => $style->value,
            'fill' => $fill->value,
            'width' => $width->value,
            'theme' => $theme->value,
            'isMin' => $min !== null && $value <= $min,
            'isMax' => $max !== null && $value >= $max,
        ]);
    }
}

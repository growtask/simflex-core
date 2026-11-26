<?php

namespace Simflex\Core\Layout\Components\UI\Range\RangeMain;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ползунок (Figma Range/main и Range/dot): одно значение или «от–до». Сверху поля для точных значений (TextInput),
 * под ними трек с ручками; ручки двигаются мышью, пальцем и стрелками, поля и ручки синхронны, над нажатой ручкой
 * показано значение. В форму уходят значения полей (name_from и name_to у диапазона, name у одиночного)
 */
class Layout extends LayoutBase
{
    /**
     * @param float $min Минимум шкалы
     * @param float $max Максимум шкалы
     * @param float|null $value Левое значение (от) у диапазона или значение у одиночного; null — минимум
     * @param float|null $valueTo Правое значение (до) у диапазона; null — максимум
     * @param float $step Шаг значений
     * @param string $name Имя поля формы; у диапазона к нему добавляются _from и _to; пусто — поля без имени
     * @param bool $inputs Показывать поля ввода над треком; без них значения уходят скрытыми полями
     * @param bool $marks Показывать деления под треком
     * @param bool $labels Показывать подписи минимума и максимума под треком
     * @param string $label Доступное имя ползунка
     */
    public static function drawRange(
        float      $min = 0,
        float      $max = 100,
        ?float     $value = null,
        ?float     $valueTo = null,
        float      $step = 1,
        RangeType  $type = RangeType::Range,
        RangeWidth $width = RangeWidth::Hug,
        RangeTheme $theme = RangeTheme::Light,
        string     $name = '',
        bool       $inputs = true,
        bool       $marks = false,
        bool       $labels = false,
        bool       $disabled = false,
        string     $label = '',
        string     $className = '',
    ): string {
        $max = max($min, $max);
        $step = $step > 0 ? $step : 1;
        $clamp = static fn(float $v): float => min($max, max($min, $v));
        $isRange = $type === RangeType::Range;
        $from = $isRange ? $clamp($value ?? $min) : $min;
        $to = $isRange ? $clamp($valueTo ?? $max) : $clamp($value ?? $max);
        if ($isRange && $from > $to) {
            [$from, $to] = [$to, $from];
        }
        $span = $max - $min;
        $percent = static fn(float $v): float => $span > 0 ? round(($v - $min) / $span * 100, 3) : 0.0;
        $format = static fn(float $v): string => rtrim(rtrim(number_format($v, 4, '.', ''), '0'), '.');

        $fields = [];
        foreach ($isRange ? ['from' => $from, 'to' => $to] : ['to' => $to] as $key => $current) {
            $fieldName = $name === '' ? '' : ($isRange ? "{$name}_{$key}" : $name);
            $attributes = ['inputmode' => 'decimal', 'data-range-field' => $key, 'aria-label' => $key === 'from' ? 'От' : ($isRange ? 'До' : 'Значение')];
            if ($fieldName !== '') {
                $attributes['name'] = $fieldName;
            }
            if ($disabled) {
                $attributes['disabled'] = 'disabled';
            }
            $fields[$key] = $inputs
                ? TextInput::drawInput(
                    placeholder: 'Значение',
                    size: TextInputSize::Small,
                    theme: TextInputTheme::from($theme->value),
                    reset: false,
                    attributes: $attributes,
                    value: $format($current),
                )
                : '<input type="hidden"' . ($fieldName !== '' ? ' name="' . htmlspecialchars($fieldName) . '"' : '')
                    . ' data-range-field="' . $key . '" value="' . $format($current) . '">';
        }

        return static::draw(compact('inputs', 'marks', 'labels', 'disabled', 'label', 'className', 'fields', 'min', 'max', 'step') + [
            'type' => $type->value,
            'width' => $width->value,
            'theme' => $theme->value,
            'from' => $from,
            'to' => $to,
            'fromPercent' => $isRange ? $percent($from) : 0.0,
            'toPercent' => $percent($to),
            'minText' => $format($min),
            'maxText' => $format($max),
        ]);
    }
}

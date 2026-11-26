<?php

namespace Simflex\Core\Layout\Components\UI\Other\StepIndicator;

use Simflex\Core\Layout\LayoutBase;

/**
 * Индикатор прокрутки слайдера: ряд полос, активная шире остальных (Figma: Base/slider/step, step-icon)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param int $count Число полос (страниц)
     * @param int $active Номер активной полосы, с нуля
     * @param string $label Доступное имя индикатора
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты корня
     */
    public static function drawStepIndicator(
        string             $className = '',
        int                $count = 10,
        int                $active = 0,
        string             $label = '',
        StepIndicatorSize  $size = StepIndicatorSize::Medium,
        StepIndicatorTheme $theme = StepIndicatorTheme::Light,
        array              $attributes = []
    ): string {
        $count = max(0, $count);

        return static::draw(
            compact(
                'className',
                'count',
                'label',
                'attributes'
            ) + [
                'active' => $count > 0 ? min(max(0, $active), $count - 1) : 0,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

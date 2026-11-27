<?php

namespace Simflex\Core\Layout\Components\Base\Slider\SliderStep;

use Simflex\Core\Layout\LayoutBase;

/**
 * Индикатор прокрутки слайдера (Figma Base/slider/step): ряд полос, активная шире остальных. Одна полоска — SliderStepItem
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
    public static function drawSliderStep(
        string             $className = '',
        int                $count = 10,
        int                $active = 0,
        string             $label = '',
        SliderStepSize  $size = SliderStepSize::Medium,
        SliderStepTheme $theme = SliderStepTheme::Light,
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

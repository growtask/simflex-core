<?php

namespace Simflex\Core\Layout\Components\Base\Slider\SliderStepItem;

use Simflex\Core\Layout\Components\Base\Slider\SliderStep\Layout as SliderStep;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepSize;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepTheme;
use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\Layout\LayoutManager;

/**
 * Одна полоска индикатора прокрутки (Figma Base/slider/step-item): активная длиннее и темнее. Обычно полоски выводит
 * SliderStep; отдельная полоска нужна, когда индикатор собирается вручную. Стили — у SliderStep
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $active Активная полоска (текущее положение)
     * @param string $className Дополнительные CSS-классы
     */
    public static function drawSliderStepItem(
        bool            $active = false,
        SliderStepSize  $size = SliderStepSize::Medium,
        SliderStepTheme $theme = SliderStepTheme::Light,
        string          $className = '',
    ): string {
        // стили полоски — в SliderStep (полоска ставится внутрь .step-indicator)
        LayoutManager::useLayout(SliderStep::class);

        return static::draw([
            'active' => $active,
            'size' => $size->value,
            'theme' => $theme->value,
            'className' => $className,
        ]);
    }
}

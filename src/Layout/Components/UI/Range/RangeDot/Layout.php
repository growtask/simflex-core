<?php

namespace Simflex\Core\Layout\Components\UI\Range\RangeDot;

use Simflex\Core\Layout\Components\UI\Range\RangeMain\Layout as RangeMain;
use Simflex\Core\Layout\Components\UI\Range\RangeMain\RangeTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ручка ползунка (набор Figma Range/dot): живёт внутри RangeMain; отдельно показывает ручку на коротком треке.
 * Стили и скрипт — у RangeMain (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    /**
     * @param int $value Положение ручки на шкале 0–100
     * @param bool $tooltip Показывать значение над ручкой
     */
    public static function drawRangeDot(
        int        $value = 50,
        bool       $tooltip = true,
        bool       $disabled = false,
        RangeTheme $theme = RangeTheme::Light,
        string     $className = '',
    ): string {
        RangeMain::initAssets();

        return static::draw(compact('tooltip', 'disabled', 'className') + [
            'value' => max(0, min(100, $value)),
            'theme' => $theme->value,
        ]);
    }
}

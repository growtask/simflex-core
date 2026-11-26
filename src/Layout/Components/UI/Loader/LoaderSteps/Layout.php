<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSteps;

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Пошаговый прогресс (Figma Loaders/steps): текущий шаг из общего (3–5), role="progressbar"
 */
class Layout extends LayoutBase
{
    /**
     * Шаги: сегменты «пройдено — не пройдено», до 5 штук
     * @param int $total Число шагов, 3–5
     * @param int $current Текущий шаг, 1–$total
     * @param bool $showLabel Подпись «Шаг 2 из 4» над сегментами
     */
    public static function drawSteps(
        int           $total = 4,
        int           $current = 1,
        bool          $showLabel = false,
        ProgressSize  $size = ProgressSize::Medium,
        ProgressTheme $theme = ProgressTheme::Light,
        string        $className = '',
    ): string {
        $total = max(3, min(5, $total));

        return static::draw([
            'total' => $total,
            'current' => max(1, min($total, $current)),
            'showLabel' => $showLabel,
            'className' => $className,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSteps;

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressTheme;
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
    public static function drawLoaderSteps(
        int           $total = 4,
        int           $current = 1,
        bool          $showLabel = false,
        LoaderProgressSize  $size = LoaderProgressSize::Medium,
        LoaderProgressTheme $theme = LoaderProgressTheme::Light,
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

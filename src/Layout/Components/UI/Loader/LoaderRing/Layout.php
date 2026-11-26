<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderRing;

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Круглый прогресс (Figma Loaders/ring): доля или оценка в компактном виде, role="progressbar"
 */
class Layout extends LayoutBase
{
    /**
     * Кольцо: доля или оценка в компактном виде
     * @param bool $showValue Показать проценты внутри кольца
     */
    public static function drawRing(
        int           $value = 0,
        bool          $showValue = true,
        ProgressSize  $size = ProgressSize::Medium,
        ProgressStyle $style = ProgressStyle::Primary,
        ProgressTheme $theme = ProgressTheme::Light,
        string        $label = 'Выполнено',
        string        $className = '',
    ): string {
        return static::draw([
            'value' => self::clamp($value),
            'showValue' => $showValue,
            'label' => $label,
            'className' => $className,
            'size' => $size->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }

    private static function clamp(int $value): int
    {
        return max(0, min(100, $value));
    }
}

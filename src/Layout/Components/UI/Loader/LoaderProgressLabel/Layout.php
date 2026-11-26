<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel;

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\ProgressTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Полоса прогресса с процентами (Figma Loaders/progress-label): заполнение идёт фоном под подписью, role="progressbar"
 */
class Layout extends LayoutBase
{
    /**
     * Полоса с процентами: заполнение идёт фоном под подписью
     * @param string $text Подпись справа от процентов (имя файла, этап); экранируется
     */
    public static function drawProgressLabel(
        int                $percent = 0,
        string             $text = '',
        ProgressLabelStyle $style = ProgressLabelStyle::Progress,
        ProgressSize       $size = ProgressSize::Medium,
        ProgressTheme      $theme = ProgressTheme::Light,
        string             $className = '',
    ): string {
        return static::draw([
            'value' => self::clamp($percent),
            'text' => $text,
            'className' => $className,
            'labelStyle' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }

    private static function clamp(int $value): int
    {
        return max(0, min(100, $value));
    }
}

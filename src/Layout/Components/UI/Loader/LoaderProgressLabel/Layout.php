<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgressLabel;

use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderProgress\LoaderProgressTheme;
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
    public static function drawLoaderProgressLabel(
        int                $percent = 0,
        string             $text = '',
        LoaderProgressLabelStyle $style = LoaderProgressLabelStyle::Progress,
        LoaderProgressSize       $size = LoaderProgressSize::Medium,
        LoaderProgressTheme      $theme = LoaderProgressTheme::Light,
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

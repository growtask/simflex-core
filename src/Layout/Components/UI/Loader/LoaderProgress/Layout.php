<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderProgress;

use Simflex\Core\Layout\LayoutBase;

/**
 * Полоса прогресса (Figma Loaders/progress): role="progressbar", значение 0–100 ограничивается.
 * Для неизвестной длительности — Indeterminate. Остальные виды прогресса — LoaderProgressLabel, LoaderRing, LoaderSteps
 */
class Layout extends LayoutBase
{
    /**
     * @param int $value Доля выполненного, 0–100 (у Indeterminate не нужна)
     * @param bool $animation Indeterminate: бегущая полоса; false — полоса стоит
     * @param string $label Доступное имя
     */
    public static function drawProgress(
        int           $value = 0,
        ProgressType  $type = ProgressType::Determinate,
        ProgressSize  $size = ProgressSize::Medium,
        ProgressStyle $style = ProgressStyle::Primary,
        ProgressTheme $theme = ProgressTheme::Light,
        bool          $animation = true,
        string        $label = 'Выполнено',
        string        $className = '',
    ): string {
        return static::draw([
            'value' => self::clamp($value),
            'label' => $label,
            'animation' => $animation,
            'className' => $className,
            'type' => $type->value,
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

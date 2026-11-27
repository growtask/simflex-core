<?php

namespace Simflex\Core\Layout\Components\Base\Player\PlayerWave;

use Simflex\Core\Layout\LayoutBase;

/**
 * Волна трека (Figma Base/Player/wave): столбики по громкости, проигранная часть закрашена. В PlayerAudio волна —
 * перемотка (role="slider", скрипт PlayerAudio); отдельно — рисунок с долей progress
 */
class Layout extends LayoutBase
{
    /** Столбиков волны в серверной разметке (по ширине их выравнивает flex, лишние скрываются overflow) */
    public const BARS = 120;

    /**
     * @param float[] $peaks Высоты столбиков 0–1 (например, рассчитанные при загрузке файла); пусто — ровный рисунок
     * @param float $progress Проигранная доля 0–1
     * @param bool $seekable Волна — перемотка: role="slider", фокус с клавиатуры (поведение — скрипт PlayerAudio)
     * @param string $className Дополнительные CSS-классы
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawPlayerWave(
        array           $peaks = [],
        float           $progress = 0,
        PlayerWaveStyle $style = PlayerWaveStyle::Accent,
        PlayerWaveSize  $size = PlayerWaveSize::Medium,
        PlayerWaveTheme $theme = PlayerWaveTheme::Light,
        bool            $seekable = false,
        string          $className = '',
        array           $attributes = [],
    ): string {
        return static::draw([
            'bars' => static::bars($peaks, static::BARS),
            'progress' => min(1, max(0, $progress)),
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
            'seekable' => $seekable,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }

    /**
     * Высоты столбиков в процентах: пики, приведённые к числу столбиков (максимум по отрезку), или ровный рисунок
     *
     * @param float[] $peaks
     * @return int[]
     */
    public static function bars(array $peaks, int $count): array
    {
        $peaks = array_values(array_map('floatval', $peaks));
        if (!$peaks) {
            for ($i = 0; $i < $count; $i++) {
                $v = fmod(abs(sin($i * 12.9898) * 43758.5453), 1);
                $peaks[] = 0.2 + 0.8 * (0.5 * $v + 0.5 * abs(sin($i / 7)));
            }
        }
        $n = count($peaks);
        $bars = [];
        for ($i = 0; $i < $count; $i++) {
            $from = intdiv($i * $n, $count);
            $to = max($from + 1, intdiv(($i + 1) * $n, $count));
            $bars[] = (int)round(min(1, max(0.08, max(array_slice($peaks, $from, $to - $from)))) * 100);
        }

        return $bars;
    }
}

<?php

namespace Simflex\Core\Layout\Components\Base\Player\PlayerAudio;

use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveStyle;
use Simflex\Core\Layout\LayoutBase;

/**
 * Аудиоплеер (Figma Base/Player/audio): обложка, кнопка воспроизведения, волна-перемотка PlayerWave, время,
 * название и исполнитель; один трек на плеер. Звук — нативный audio, кнопка, перемотка нажатием и перетаскиванием
 * по волне, клавиатура (пробел — пуск/пауза, на волне ← → — 5 с, PageUp/PageDown — 10 %, Home/End) — script.js
 */
class Layout extends LayoutBase
{
    /**
     * @param string $src Адрес аудиофайла
     * @param string $title Название трека (Figma name)
     * @param string $artist Исполнитель (Figma artist)
     * @param string $image Обложка; пусто — без обложки (Figma image)
     * @param string $imageAlt Описание обложки
     * @param float[] $peaks Высоты столбиков волны 0–1; пусто — ровный рисунок
     * @param int $duration Длительность, с (показывается до загрузки метаданных)
     * @param PlayerWaveStyle $wave Стиль волны
     * @param bool $time Показывать время (Figma time)
     * @param string $className Дополнительные CSS-классы
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты корня
     */
    public static function drawPlayerAudio(
        string           $src,
        string           $title = '',
        string           $artist = '',
        string           $image = '',
        string           $imageAlt = '',
        array            $peaks = [],
        int              $duration = 0,
        PlayerAudioSize  $size = PlayerAudioSize::Medium,
        PlayerWaveStyle  $wave = PlayerWaveStyle::Accent,
        PlayerAudioTheme $theme = PlayerAudioTheme::Light,
        bool             $time = true,
        string           $className = '',
        array            $attributes = []
    ): string {
        return static::draw(
            compact('src', 'title', 'artist', 'image', 'imageAlt', 'peaks', 'duration', 'time', 'className', 'attributes') + [
                'size' => $size->value,
                'wave' => $wave,
                'theme' => $theme->value,
            ]
        );
    }
}

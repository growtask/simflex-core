<?php

/**
 * Демо PlayerAudio: размеры, с обложкой и без, без названия и времени, стиль волны (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Player\PlayerAudio\Layout as PlayerAudio;
use Simflex\Core\Layout\Components\Base\Player\PlayerAudio\PlayerAudioSize;
use Simflex\Core\Layout\Components\Base\Player\PlayerAudio\PlayerAudioTheme;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveStyle;

$audioTheme = PlayerAudioTheme::from($theme);
// тишина 3 секунды (WAV, 8 кГц, 8 бит): плеер в витрине работает без внешних файлов
$silence = 'data:audio/wav;base64,' . base64_encode('RIFF' . pack('V', 36 + 24000) . 'WAVEfmt ' . pack('VvvVVvv', 16, 1, 1, 8000, 8000, 1, 8)
    . 'data' . pack('V', 24000) . str_repeat(chr(128), 24000));
$cover = asset('images/banner/main.webp');

?>
<?php foreach (PlayerAudioSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row" style="align-items:flex-start">
        <div style="width:560px"><?= PlayerAudio::drawPlayerAudio($silence, 'Название трека', 'Исполнитель', $cover, 'Обложка', duration: 3, size: $size, theme: $audioTheme) ?></div>
        <div style="width:420px"><?= PlayerAudio::drawPlayerAudio($silence, 'Голосовое сообщение', duration: 3, size: $size, wave: PlayerWaveStyle::Primary, theme: $audioTheme) ?></div>
        <div style="width:320px"><?= PlayerAudio::drawPlayerAudio($silence, size: $size, theme: $audioTheme, time: false) ?></div>
    </div>
<?php endforeach; ?>

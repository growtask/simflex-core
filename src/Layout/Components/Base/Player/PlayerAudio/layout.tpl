<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Player\PlayerWave\Layout as PlayerWave;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveSize;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$fmt = static function (int $s): string {
    $h = intdiv($s, 3600);
    $m = intdiv($s % 3600, 60);
    $sec = str_pad((string)($s % 60), 2, '0', STR_PAD_LEFT);
    return $h ? $h . ':' . str_pad((string)$m, 2, '0', STR_PAD_LEFT) . ':' . $sec : $m . ':' . $sec;
};

$classes = ['player', "player-size_{$data['size']}", "player-theme_{$data['theme']}", $data['className'] ?? ''];
$label = 'Аудиоплеер' . ($data['title'] !== '' ? ': ' . $data['title'] : '');
?>
<div class="<?= $esc(implode(' ', array_filter($classes))) ?>" role="group" aria-label="<?= $esc($label) ?>"
     data-sf-player <?= buildAttrs($data['attributes'] ?? []) ?>>
    <audio class="player__audio" src="<?= $esc($data['src']) ?>" preload="metadata" data-sf-player-audio></audio>
    <?php if ($data['image'] !== ''): ?>
        <img class="player__cover" src="<?= $esc($data['image']) ?>" alt="<?= $esc($data['imageAlt']) ?>" loading="lazy">
    <?php endif; ?>
    <div class="player__body">
        <div class="player__controls">
            <?= Button::drawButtonMain(
                className: 'player__play',
                style: ButtonMainStyle::Gray,
                size: ButtonMainSize::from($data['size']),
                theme: ButtonMainTheme::from($data['theme']),
                attributes: ['aria-label' => 'Воспроизвести', 'data-sf-player-play' => ''],
                iconLeft: 'play-fill',
            ) ?>
            <div class="player__track">
                <?= PlayerWave::drawPlayerWave(
                    peaks: $data['peaks'],
                    style: $data['wave'],
                    size: PlayerWaveSize::from($data['size']),
                    theme: PlayerWaveTheme::from($data['theme']),
                    seekable: true,
                ) ?>
                <?php if ($data['time']): ?>
                    <div class="player__time" aria-hidden="true">
                        <span data-sf-player-current>0:00</span>
                        <span data-sf-player-total><?= $esc($fmt((int)$data['duration'])) ?></span>
                    </div>
                <?php endif; ?>
            </div>
        </div>
        <?php if ($data['title'] !== '' || $data['artist'] !== ''): ?>
            <span class="player__line" aria-hidden="true"></span>
            <div class="player__file">
                <?php if ($data['title'] !== ''): ?>
                    <span class="player__name"><?= $esc($data['title']) ?></span>
                <?php endif; ?>
                <?php if ($data['artist'] !== ''): ?>
                    <span class="player__artist"><?= $esc($data['artist']) ?></span>
                <?php endif; ?>
            </div>
        <?php endif; ?>
    </div>
</div>

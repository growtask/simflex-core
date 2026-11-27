<?php
/** @var array $data */

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$classes = ['player-wave', "player-wave-{$data['style']}", "player-wave-size_{$data['size']}", "player-wave-theme_{$data['theme']}",
    $data['seekable'] ? 'player-wave_seekable' : '', $data['className']];
$attrs = $data['attributes'];
if ($data['seekable']) {
    $attrs += ['role' => 'slider', 'tabindex' => '0', 'aria-label' => 'Перемотка', 'aria-valuemin' => '0',
        'aria-valuemax' => '100', 'aria-valuenow' => (string)round($data['progress'] * 100), 'data-sf-player-wave' => ''];
} else {
    $attrs += ['aria-hidden' => 'true'];
}
?>
<div class="<?= $esc(implode(' ', array_filter($classes))) ?>" style="--wave-progress: <?= $data['progress'] ?>" <?= buildAttrs($attrs) ?>>
    <?php foreach ($data['bars'] as $height): ?>
        <span class="player-wave__bar" style="height: <?= (int)$height ?>%"></span>
    <?php endforeach; ?>
    <?php /* проигранная часть: тот же ряд поверх, обрезанный clip-path по --wave-progress */ ?>
    <span class="player-wave__played" aria-hidden="true">
        <?php foreach ($data['bars'] as $height): ?>
            <span class="player-wave__bar player-wave__bar_played" style="height: <?= (int)$height ?>%"></span>
        <?php endforeach; ?>
    </span>
</div>

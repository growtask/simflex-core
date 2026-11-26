<?php
/** @var array $data */

$class = htmlspecialchars(implode(' ', array_filter([
    'progress-steps',
    "progress-steps_size_{$data['size']}",
    "progress-steps-theme_{$data['theme']}",
    $data['className'],
])));
?>
<div class="<?= $class ?>" role="progressbar" aria-label="Шаги" aria-valuemin="1" aria-valuemax="<?= $data['total'] ?>"
     aria-valuenow="<?= $data['current'] ?>" aria-valuetext="Шаг <?= $data['current'] ?> из <?= $data['total'] ?>">
    <?php if ($data['showLabel']): ?>
        <span class="progress-steps__label">Шаг <?= $data['current'] ?> из <?= $data['total'] ?></span>
    <?php endif; ?>
    <span class="progress-steps__segments">
        <?php for ($step = 1; $step <= $data['total']; $step++): ?>
            <span class="progress-steps__segment<?= $step <= $data['current'] ? ' progress-steps__segment_done' : '' ?>"></span>
        <?php endfor; ?>
    </span>
</div>

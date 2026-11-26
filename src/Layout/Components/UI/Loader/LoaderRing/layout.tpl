<?php
/** @var array $data */

$value = $data['value'] ?? 0;
$theme = $data['theme'];
$size = $data['size'];
$class = static fn(array $parts): string => htmlspecialchars(implode(' ', array_filter($parts)));
?>
    <div class="<?= $class([
        'progress-ring',
        "progress-ring_size_$size",
        "progress-ring_style_{$data['style']}",
        "progress-ring-theme_$theme",
        $data['className'],
    ]) ?>" role="progressbar" aria-label="<?= htmlspecialchars($data['label']) ?>" aria-valuemin="0" aria-valuemax="100" aria-valuenow="<?= $value ?>">
        <svg class="progress-ring__svg" viewBox="0 0 40 40" aria-hidden="true">
            <circle class="progress-ring__track" cx="20" cy="20" r="17" pathlength="100" fill="none"></circle>
            <circle class="progress-ring__fill" cx="20" cy="20" r="17" pathlength="100" fill="none"
                    stroke-dasharray="<?= $value ?> 100"></circle>
        </svg>
        <?php if ($data['showValue']): ?>
            <span class="progress-ring__value"><?= $value ?>%</span>
        <?php endif; ?>
    </div>

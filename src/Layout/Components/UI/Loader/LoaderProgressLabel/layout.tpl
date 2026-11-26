<?php
/** @var array $data */

$value = $data['value'] ?? 0;
$theme = $data['theme'];
$size = $data['size'];
$class = static fn(array $parts): string => htmlspecialchars(implode(' ', array_filter($parts)));
?>
    <div class="<?= $class([
        'progress-label',
        "progress-label_size_$size",
        "progress-label_style_{$data['labelStyle']}",
        "progress-label-theme_$theme",
        $data['className'],
    ]) ?>" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="<?= $value ?>"<?= $data['text'] !== '' ? ' aria-label="' . htmlspecialchars($data['text']) . '"' : '' ?>>
        <span class="progress-label__bar" style="width:<?= $value ?>%"></span>
        <span class="progress-label__value"><?= $value ?>%</span>
        <?php if ($data['text'] !== ''): ?>
            <span class="progress-label__text"><?= htmlspecialchars($data['text']) ?></span>
        <?php endif; ?>
    </div>

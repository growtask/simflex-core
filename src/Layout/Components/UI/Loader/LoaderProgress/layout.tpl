<?php
/** @var array $data */

$value = $data['value'] ?? 0;
$theme = $data['theme'];
$size = $data['size'];
$class = static fn(array $parts): string => htmlspecialchars(implode(' ', array_filter($parts)));
?>
    <?php $indeterminate = $data['type'] === 'indeterminate'; ?>
    <div class="<?= $class([
        'progress',
        "progress_size_$size",
        "progress_style_{$data['style']}",
        "progress-theme_$theme",
        $indeterminate ? 'progress_indeterminate' : '',
        $indeterminate && !$data['animation'] ? 'progress_static' : '',
        $data['className'],
    ]) ?>" role="progressbar" aria-label="<?= htmlspecialchars($data['label']) ?>" aria-valuemin="0" aria-valuemax="100"
         <?= $indeterminate ? '' : 'aria-valuenow="' . $value . '"' ?>>
        <span class="progress__line"<?= $indeterminate ? '' : ' style="width:' . $value . '%"' ?>></span>
    </div>

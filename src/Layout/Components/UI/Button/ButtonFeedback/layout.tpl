<?php
/** @var array $data */

$classes = [
    'btn-feedback',
    "btn-feedback-style_{$data['style']}",
    "btn-feedback-theme_{$data['theme']}",
    $data['active'] ? 'active' : '',
    $data['className'],
];
$attributes = $data['attributes'] + [
    'aria-label' => $data['label'],
    'aria-pressed' => $data['active'] ? 'true' : 'false',
];
?>
<button type="button" class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attributes) ?>>
    <?= renderIcon($data['type'], 'btn-feedback__icon') ?>
    <?php if ($data['count'] !== ''): ?>
        <span class="btn-feedback__count"><?= htmlspecialchars($data['count']) ?></span>
    <?php endif; ?>
</button>

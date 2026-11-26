<?php
/** @var array $data */

$classes = [
    'selector-item',
    "selector-item-style_{$data['style']}",
    "selector-item-size_{$data['size']}",
    "selector-item-theme_{$data['theme']}",
    $data['active'] ? 'selector-item_active' : '',
    $data['className'],
];
?>
<button type="button" class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"
        aria-pressed="<?= $data['active'] ? 'true' : 'false' ?>"<?= $data['disabled'] ? ' disabled' : '' ?>>
    <?php if ($data['icon'] !== ''): ?>
        <?= renderIcon($data['icon'], 'selector-item__icon') ?>
    <?php endif; ?>
    <?php if ($data['text'] !== ''): ?>
        <span class="selector-item__text"><?= htmlspecialchars($data['text']) ?></span>
    <?php endif; ?>
    <?php if ($data['badge'] !== ''): ?>
        <span class="selector-item__badge"><?= htmlspecialchars($data['badge']) ?></span>
    <?php endif; ?>
</button>

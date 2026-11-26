<?php
/** @var array $data */

$classes = [
    'tooltip',
    'tooltip_rich',
    "tooltip_position_{$data['position']}",
    "tooltip_side_{$data['side']}",
    'tooltip_style_default',
    "tooltip-theme_{$data['theme']}",
];
?>
<span class="tooltip-wrap <?= htmlspecialchars($data['className']) ?>" data-sf-tooltip>
    <?= $data['trigger'] ?>
    <span id="<?= $data['id'] ?>" class="<?= implode(' ', array_filter($classes)) ?>" role="tooltip">
        <span class="tooltip__head">
            <?php if ($data['icon'] !== ''): ?>
                <?= renderIcon($data['icon'], 'tooltip__icon') ?>
            <?php endif; ?>
            <span class="tooltip__title"><?= htmlspecialchars($data['title']) ?></span>
        </span>
        <?php if ($data['text'] !== ''): ?>
            <span class="tooltip__text"><?= htmlspecialchars($data['text']) ?></span>
        <?php endif; ?>
        <?php if ($data['actionText'] !== ''): ?>
            <a class="tooltip__action" href="<?= htmlspecialchars($data['actionLink'] ?: '#') ?>">
                <?= htmlspecialchars($data['actionText']) ?>
                <?= renderIcon('chevron-s-right', 'tooltip__action-icon') ?>
            </a>
        <?php endif; ?>
    </span>
</span>

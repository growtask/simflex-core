<?php
/** @var array $data */

$classes = [
    'tooltip',
    "tooltip_position_{$data['position']}",
    "tooltip_side_{$data['side']}",
    "tooltip_style_{$data['style']}",
    "tooltip-theme_{$data['theme']}",
];
?>
<span class="tooltip-wrap <?= htmlspecialchars($data['className']) ?>" data-sf-tooltip>
    <?= $data['trigger'] ?>
    <span id="<?= $data['id'] ?>" class="<?= implode(' ', $classes) ?>" role="tooltip"><?= htmlspecialchars($data['text']) ?></span>
</span>

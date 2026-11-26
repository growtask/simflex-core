<?php
/** @var array $data */

$socialClasses = [
    'social',
    "social-{$data['style']}",
    "social-network_{$data['network']}",
    "social-size_{$data['size']}",
    "social-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$attrs = $data['attributes'] ?? [];
if ($data['external']) {
    $attrs += ['target' => '_blank', 'rel' => 'noopener'];
}
$attrs += ['aria-label' => $data['label']];
?>

<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(implode(' ', $socialClasses)) ?>" <?= buildAttrs($attrs) ?>>
    <?php if ($data['style'] === 'default'): ?>
        <?php // Цветной знак в покое, монохромный (цвета текста) — по наведению и в тёмной теме ?>
        <?= renderIcon('social-' . $data['network'], 'social__icon social__icon_color') ?>
    <?php endif; ?>
    <?= renderIcon('social-monochrome-' . $data['network'], 'social__icon social__icon_mono') ?>
</a>

<?php

/** @var array $data */

$classes = ['brand-logo-anim', "brand-logo-anim-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?php // Знак и подпись лежат в одном окне, при наведении и фокусе сменяют друг друга ?>
    <span class="brand-logo-anim__slide">
        <img class="brand-logo-anim__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
        <span class="brand-logo-anim__home" aria-hidden="true"><?= htmlspecialchars($data['homeText']) ?></span>
    </span>
    <?php if ($data['text'] && $data['caption'] !== ''): ?>
        <span class="brand-logo-anim__divider" aria-hidden="true"></span>
        <span class="brand-logo-anim__caption"><?= htmlspecialchars($data['caption']) ?></span>
    <?php endif; ?>
</a>

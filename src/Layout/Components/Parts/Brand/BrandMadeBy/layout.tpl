<?php

/** @var array $data */

$classes = ['brand-made-by', "brand-made-by-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'] + ['target' => '_blank', 'rel' => 'noopener'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <span class="brand-made-by__stack">
        <span class="brand-made-by__label"><?= htmlspecialchars($data['caption']) ?></span>
        <img class="brand-made-by__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
    </span>
</a>

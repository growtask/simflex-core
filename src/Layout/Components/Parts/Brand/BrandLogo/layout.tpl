<?php

/** @var array $data */

$classes = ['brand-logo', "brand-logo-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <img class="brand-logo__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
</a>

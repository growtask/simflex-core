<?php

/** @var array $data */

$classes = ['delivery-list', $data['className']];
$attributes = $data['attributes'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<ul class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?php foreach ($data['items'] as $item): ?>
        <li class="delivery-list__item"><?= $item ?></li>
    <?php endforeach; ?>
</ul>

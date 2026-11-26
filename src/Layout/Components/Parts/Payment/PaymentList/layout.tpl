<?php

/** @var array $data */

$classes = ['payment-list', $data['className']];
$attributes = $data['attributes'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<ul class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?php foreach ($data['items'] as $item): ?>
        <li class="payment-list__item"><?= $item ?></li>
    <?php endforeach; ?>
</ul>

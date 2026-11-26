<?php

/** @var array $data */

$classes = ['payment-logo', "payment-logo_style_{$data['style']}", $data['className']];
$tag = $data['href'] !== '' ? 'a' : 'span';
$attributes = $data['attributes'];
if ($data['href'] !== '') {
    $attributes += ['href' => $data['href']];
}
?>
<<?= $tag ?> class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?= $data['image'] ?>
</<?= $tag ?>>

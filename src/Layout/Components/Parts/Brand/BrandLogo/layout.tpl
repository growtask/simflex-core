<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;

$classes = ['brand-logo', "brand-logo-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?= PlaceholderImg::drawPlaceholderImg(src: $data['brandSrc'], alt: $data['label'], imgClass: 'brand-logo__image', attributes: ['loading' => 'eager']) ?>
</a>

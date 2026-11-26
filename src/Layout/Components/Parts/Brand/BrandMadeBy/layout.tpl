<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;

$classes = ['brand-made-by', "brand-made-by-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'] + ['target' => '_blank', 'rel' => 'noopener'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <span class="brand-made-by__stack">
        <span class="brand-made-by__label"><?= htmlspecialchars($data['caption']) ?></span>
        <?= PlaceholderImg::drawPlaceholderImg(src: $data['brandSrc'], alt: $data['label'], imgClass: 'brand-made-by__image', attributes: ['loading' => 'eager']) ?>
    </span>
</a>

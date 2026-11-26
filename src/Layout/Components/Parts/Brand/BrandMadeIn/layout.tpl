<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;

$classes = ['brand-made-in', "brand-made-in-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'] + ['target' => '_blank', 'rel' => 'noopener'];
if ($data['label'] !== '') {
    $attributes += ['aria-label' => $data['label']];
}
?>
<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?php if ($data['flag']): ?>
        <span class="brand-made-in__flag" aria-hidden="true"></span>
    <?php endif; ?>
    <span class="brand-made-in__stack">
        <span class="brand-made-in__label"><?= htmlspecialchars($data['caption']) ?></span>
        <?= PlaceholderImg::drawPlaceholderImg(src: $data['brandSrc'], alt: $data['label'], imgClass: 'brand-made-in__image', attributes: ['loading' => 'eager']) ?>
    </span>
</a>

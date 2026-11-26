<?php
/** @var array $data */

$classes = [
    'btn-social',
    "btn-social-type_{$data['type']}",
    "btn-social-size_{$data['size']}",
    "btn-social-style_{$data['style']}",
    "btn-social-theme_{$data['theme']}",
    $data['className'],
];
$attributes = $data['attributes'];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);
$isLink = $data['link'] !== '';
$tag = $isLink ? 'a' : 'button';
?>
<<?= $tag ?> class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"
    <?= $isLink ? 'href="' . htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') . '"' : 'type="' . htmlspecialchars($type, ENT_QUOTES, 'UTF-8') . '"' ?>
    <?= buildAttrs($attributes) ?>>
    <span class="btn-social__content">
        <span class="btn-social__plate"><?= renderIcon($data['icon'], 'btn-social__icon') ?></span>
        <span class="btn-social__text"><?= htmlspecialchars($data['text']) ?></span>
    </span>
    <?= renderIcon('arrow-up-right', 'btn-social__arrow') ?>
</<?= $tag ?>>

<?php
/** @var array $data */

$linkClasses = [
    'link',
    "link-{$data['style']}",
    "link-size_{$data['size']}",
    "link-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$attrs = $data['attributes'] ?? [];
if ($data['external']) {
    $attrs += ['target' => '_blank', 'rel' => 'noopener'];
}
?>

<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(implode(' ', $linkClasses)) ?>" <?= buildAttrs($attrs) ?>>
    <?php if ($data['iconLeft']): ?>
        <?= renderIcon($data['iconLeft'], 'link__icon-left') ?>
    <?php endif; ?>

    <span class="link__text"><?= htmlspecialchars($data['text']) ?></span>

    <?php if ($data['external']): ?>
        <span class="visually-hidden"><?= htmlspecialchars($data['externalText']) ?></span>
    <?php endif; ?>

    <?php if ($data['iconRight']): ?>
        <?= renderIcon($data['iconRight'], 'link__icon-right') ?>
    <?php endif; ?>
</a>

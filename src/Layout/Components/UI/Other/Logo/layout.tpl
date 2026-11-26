<?php
/** @var array $data */

$logoClasses = [
    'logo',
    "logo-type_{$data['type']}",
    "logo-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$attrs = $data['attributes'] ?? [];
if ($data['external']) {
    $attrs += ['target' => '_blank', 'rel' => 'noopener'];
}
if ($data['label'] !== '') {
    $attrs += ['aria-label' => $data['label']];
}
?>

<a href="<?= htmlspecialchars($data['href']) ?>" class="<?= htmlspecialchars(implode(' ', $logoClasses)) ?>" <?= buildAttrs($attrs) ?>>
    <?php if ($data['type'] === 'made-in'): ?>
        <?php // Отметка студии: флаг и подпись над знаком ?>
        <span class="logo__flag" aria-hidden="true"></span>
        <span class="logo__stack">
            <span class="logo__label"><?= htmlspecialchars($data['caption']) ?></span>
            <img class="logo__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
        </span>
    <?php elseif ($data['type'] === 'made-by'): ?>
        <span class="logo__stack">
            <span class="logo__label"><?= htmlspecialchars($data['caption']) ?></span>
            <img class="logo__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
        </span>
    <?php elseif ($data['type'] === 'anim'): ?>
        <?php // Знак и подпись «Главная» лежат в одном окне, при наведении сменяют друг друга ?>
        <span class="logo__slide">
            <img class="logo__image logo__brand" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
            <span class="logo__home" aria-hidden="true"><?= htmlspecialchars($data['homeText']) ?></span>
        </span>
        <?php if ($data['text'] && $data['caption'] !== ''): ?>
            <span class="logo__divider" aria-hidden="true"></span>
            <span class="logo__caption"><?= htmlspecialchars($data['caption']) ?></span>
        <?php endif; ?>
    <?php else: ?>
        <img class="logo__image" src="<?= htmlspecialchars($data['brandSrc']) ?>" alt="<?= htmlspecialchars($data['label']) ?>">
    <?php endif; ?>
</a>

<?php
/** @var array $data */

$tabClasses = [
    'tab',
    "tab-{$data['style']}",
    "tab-size_{$data['size']}",
    "tab-theme_{$data['theme']}",
    $data['active'] ? 'active' : '',
    $data['className'] ?? ''
];

$attributes = $data['attributes'] ?? [];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);

$isLink = (bool)$data['link'];
if ($data['active']) {
    if ($isLink) {
        $attributes['aria-current'] = 'page';
    } elseif (($attributes['role'] ?? '') === 'tab') {
        $attributes['aria-selected'] = 'true';
    }
} elseif (!$isLink && ($attributes['role'] ?? '') === 'tab') {
    $attributes['aria-selected'] = 'false';
}
if ($data['disabled']) {
    $attributes['aria-disabled'] = 'true';
    if ($isLink) {
        $attributes['tabindex'] = '-1';
    }
}
$class = trim(implode(' ', array_filter($tabClasses)));
$tag = $isLink ? 'a' : 'button';
?>

<<?= $tag ?>
    <?php if ($isLink): ?>
        <?php if (!$data['disabled']): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
    <?php else: ?>
        type="<?= htmlspecialchars($type, ENT_QUOTES, 'UTF-8') ?>"<?= $data['disabled'] ? ' disabled' : '' ?>
    <?php endif; ?>
    class="<?= $class ?>" <?= buildAttrs($attributes) ?>>
    <?php if ($data['iconLeft']): ?>
        <?= renderIcon($data['iconLeft'], 'tab__icon-left') ?>
    <?php endif; ?>

    <?php if ($data['text'] !== ''): ?>
        <span class="tab__text"><?= $data['text'] ?></span>
    <?php endif; ?>

    <?php if ($data['badge']): ?>
        <span class="tab__badge"><?= $data['badge'] ?></span>
    <?php endif; ?>

    <?php if ($data['iconRight']): ?>
        <?= renderIcon($data['iconRight'], 'tab__icon-right') ?>
    <?php endif; ?>
</<?= $tag ?>>

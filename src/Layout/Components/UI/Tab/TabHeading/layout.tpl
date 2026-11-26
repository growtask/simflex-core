<?php
/** @var array $data */

$classes = [
    'tab-heading',
    "tab-heading-style_{$data['style']}",
    "tab-heading-size_{$data['size']}",
    "tab-heading-theme_{$data['theme']}",
    $data['active'] ? 'active' : '',
    $data['className'],
];

$attributes = $data['attributes'];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);

$isLink = $data['link'] !== '';
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
$tag = $isLink ? 'a' : 'button';
?>
<<?= $tag ?> class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>"
    <?php if ($isLink): ?>
        <?php if (!$data['disabled']): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
    <?php else: ?>
        type="<?= htmlspecialchars($type, ENT_QUOTES, 'UTF-8') ?>"<?= $data['disabled'] ? ' disabled' : '' ?>
    <?php endif; ?>
    <?= buildAttrs($attributes) ?>>
    <span class="tab-heading__text"><?= $data['text'] ?></span>
    <?php if ($data['badge'] !== ''): ?>
        <span class="tab-heading__badge"><?= $data['badge'] ?></span>
    <?php endif; ?>
</<?= $tag ?>>

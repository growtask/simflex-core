<?php
/** @var array $data */

$classes = [
    'btn-icon',
    "btn-icon-{$data['style']}",
    "btn-icon-theme_{$data['theme']}",
    $data['className'],
];
$attributes = $data['attributes'];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);
$attributes['aria-label'] = $data['label'];
$attributes['title'] ??= $data['label'];
$isLink = $data['link'] !== '';
if ($data['disabled']) {
    $attributes['aria-disabled'] = 'true';
    if ($isLink) {
        $attributes['tabindex'] = '-1';
    }
}
$class = htmlspecialchars(trim(implode(' ', array_filter($classes))));
?>
<?php if ($isLink): ?>
    <a<?= $data['disabled'] ? '' : ' href="' . htmlspecialchars($data['link']) . '"' ?> class="<?= $class ?>" <?= buildAttrs($attributes) ?>><?= renderIcon($data['icon'], 'btn-icon__icon') ?></a>
<?php else: ?>
    <button type="<?= htmlspecialchars($type) ?>"<?= $data['disabled'] ? ' disabled' : '' ?> class="<?= $class ?>" <?= buildAttrs($attributes) ?>><?= renderIcon($data['icon'], 'btn-icon__icon') ?></button>
<?php endif; ?>

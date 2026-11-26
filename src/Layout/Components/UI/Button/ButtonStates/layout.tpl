<?php
/** @var array $data */

$disabled = $data['state'] === 'disabled';
$attributes = $data['attributes'] ?? [];
$type = $attributes['type'] ?? 'button';
unset($attributes['type']);
$isLink = (bool)$data['link'];
if ($disabled) {
    $attributes['aria-disabled'] = 'true';
    if ($isLink) {
        $attributes['tabindex'] = '-1';
    }
}
$class = trim(implode(' ', array_filter([
    'btn',
    "btn-states_{$data['state']}",
    "btn-size_{$data['size']}",
    "btn-theme_{$data['theme']}",
    $data['className'] ?? '',
])));
$tag = $isLink ? 'a' : 'button';
?>

<<?= $tag ?>
    <?php if ($isLink): ?>
        <?php if (!$disabled): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
    <?php else: ?>
        type="<?= htmlspecialchars($type, ENT_QUOTES, 'UTF-8') ?>"<?= $disabled ? ' disabled' : '' ?>
    <?php endif; ?>
    class="<?= $class ?>" <?= buildAttrs($attributes) ?>>
    <?php if ($data['iconLeft']): ?>
        <span class="btn__icon btn__icon_left"><?= renderIcon($data['iconLeft']) ?></span>
    <?php endif; ?>

    <?php if ($data['text']): ?>
        <span class="btn__text"><?= $data['text'] ?></span>
    <?php endif; ?>

    <?php if ($data['iconCenter']): ?>
        <span class="btn__icon btn__icon_center"><?= renderIcon($data['iconCenter']) ?></span>
    <?php endif; ?>

    <?php if ($data['iconRight']): ?>
        <span class="btn__icon btn__icon_right"><?= renderIcon($data['iconRight']) ?></span>
    <?php endif; ?>
</<?= $tag ?>>

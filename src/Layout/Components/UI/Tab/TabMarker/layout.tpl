<?php
/** @var array $data */

$classes = [
    'tab-marker',
    "tab-marker-style_{$data['style']}",
    "tab-marker-size_{$data['size']}",
    "tab-marker-theme_{$data['theme']}",
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
    <?php if ($data['slot'] !== ''): ?>
        <span class="tab-marker__slot tab-marker__slot_custom"><?= $data['slot'] ?></span>
    <?php elseif ($data['icon'] !== ''): ?>
        <span class="tab-marker__slot"><?= renderIcon($data['icon'], 'tab-marker__icon') ?></span>
    <?php endif; ?>
    <span class="tab-marker__body">
        <?php if ($data['text'] !== '' || $data['description'] !== ''): ?>
            <span class="tab-marker__text">
                <?php if ($data['text'] !== ''): ?>
                    <span class="tab-marker__title"><?= $data['text'] ?></span>
                <?php endif; ?>
                <?php if ($data['description'] !== ''): ?>
                    <span class="tab-marker__description"><?= $data['description'] ?></span>
                <?php endif; ?>
            </span>
        <?php endif; ?>
        <?php if ($data['badge'] !== ''): ?>
            <span class="tab-marker__badge"><?= $data['badge'] ?></span>
        <?php endif; ?>
        <?php if ($data['iconRight'] !== ''): ?>
            <?= renderIcon($data['iconRight'], 'tab-marker__chevron') ?>
        <?php endif; ?>
    </span>
</<?= $tag ?>>

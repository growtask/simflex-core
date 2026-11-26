<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;

$classes = [
    'tab-image',
    "tab-image-style_{$data['style']}",
    "tab-image-size_{$data['size']}",
    "tab-image-theme_{$data['theme']}",
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
    <?php if ($data['image'] !== ''): ?>
        <span class="tab-image__img"><?= PlaceholderImg::drawPlaceholderImg(src: $data['image'], alt: $data['imageAlt']) ?></span>
    <?php else: ?>
        <span class="tab-image__img tab-image__img_empty"><?php if ($data['icon'] !== ''): ?><?= renderIcon($data['icon'], 'tab-image__icon') ?><?php endif; ?></span>
    <?php endif; ?>
    <span class="tab-image__body">
        <?php if ($data['text'] !== '' || $data['description'] !== ''): ?>
            <span class="tab-image__text">
                <?php if ($data['text'] !== ''): ?>
                    <span class="tab-image__title"><?= $data['text'] ?></span>
                <?php endif; ?>
                <?php if ($data['description'] !== ''): ?>
                    <span class="tab-image__description"><?= $data['description'] ?></span>
                <?php endif; ?>
            </span>
        <?php endif; ?>
        <?php if ($data['badge'] !== ''): ?>
            <span class="tab-image__badge"><?= $data['badge'] ?></span>
        <?php endif; ?>
        <?php if ($data['iconRight'] !== ''): ?>
            <?= renderIcon($data['iconRight'], 'tab-image__chevron') ?>
        <?php endif; ?>
    </span>
</<?= $tag ?>>

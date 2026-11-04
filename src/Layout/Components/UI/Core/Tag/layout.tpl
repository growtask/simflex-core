<?php
/** @var array $data */

$tagClasses = [
    'tag',
    "tag-{$data['style']}",
    "tag-size_{$data['size']}",
    "tag-theme_{$data['theme']}",
    $data['close'] ? 'tag_removable' : '',
    $data['className'] ?? ''
];
$class = trim(implode(' ', array_filter($tagClasses)));
?>
<?php if ($data['close']): ?>
    <span class="<?= $class ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
        <?php if ($data['icon']): ?>
            <?= renderIcon($data['icon'], 'tag__icon-left') ?>
        <?php endif; ?>
        <span class="tag__text"><?= $data['text'] ?></span>
        <button type="button" class="tag__close" data-sf-tag-remove aria-label="<?= htmlspecialchars($data['closeLabel']) ?>">
            <?= renderIcon('close', 'tag__icon') ?>
        </button>
    </span>
<?php else: ?>
    <button type="button" class="<?= $class ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
        <?php if ($data['icon']): ?>
            <?= renderIcon($data['icon'], 'tag__icon-left') ?>
        <?php endif; ?>
        <span class="tag__text"><?= $data['text'] ?></span>
        <?php if ($data['close'] === null): ?>
            <?= renderIcon('close', 'tag__icon') ?>
        <?php endif; ?>
    </button>
<?php endif; ?>

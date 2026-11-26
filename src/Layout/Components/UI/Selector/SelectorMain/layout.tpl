<?php
/** @var array $data */

$classes = [
    'selector',
    "selector-style_{$data['style']}",
    "selector-size_{$data['size']}",
    "selector-theme_{$data['theme']}",
    $data['fill'] ? 'selector-width_fill' : '',
    $data['className'],
];
$selected = '';
foreach ($data['items'] as $item) {
    if ($item['active']) {
        $selected = $item['value'];
    }
}
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" role="group"<?= $data['label'] !== '' ? ' aria-label="' . htmlspecialchars($data['label']) . '"' : '' ?>>
    <?php foreach ($data['items'] as $item): ?>
        <?php
        $itemClasses = [
            'selector-item',
            "selector-item-style_{$data['style']}",
            "selector-item-size_{$data['size']}",
            "selector-item-theme_{$data['theme']}",
            $item['active'] ? 'selector-item_active' : '',
        ];
        ?>
        <button type="button" class="<?= htmlspecialchars(implode(' ', array_filter($itemClasses))) ?>"
                data-value="<?= htmlspecialchars($item['value']) ?>"
                aria-pressed="<?= $item['active'] ? 'true' : 'false' ?>"<?= !empty($item['disabled']) ? ' disabled' : '' ?>>
            <?php if (!empty($item['icon'])): ?>
                <?= renderIcon($item['icon'], 'selector-item__icon') ?>
            <?php endif; ?>
            <?php if ($item['text'] !== ''): ?>
                <span class="selector-item__text"><?= htmlspecialchars($item['text']) ?></span>
            <?php endif; ?>
            <?php if (!empty($item['badge'])): ?>
                <span class="selector-item__badge"><?= htmlspecialchars((string)$item['badge']) ?></span>
            <?php endif; ?>
        </button>
    <?php endforeach; ?>
    <?php if ($data['name'] !== ''): ?>
        <input type="hidden" class="selector__input" name="<?= htmlspecialchars($data['name']) ?>" value="<?= htmlspecialchars($selected) ?>">
    <?php endif; ?>
</div>

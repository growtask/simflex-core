<?php
/** @var array $data */

?>
<?php if ($data['view'] === 'button'): ?>
    <?php
    $classes = [
        'sort-button',
        "sort-button_style_{$data['style']}",
        "sort-button_size_{$data['size']}",
        "sort-button-theme_{$data['theme']}",
        $data['active'] ? 'active' : '',
        $data['className'],
    ];
    $attributes = $data['attributes'];
    $attributes['aria-label'] = $data['label'];
    $attributes['title'] ??= $data['label'];
    if ($data['active']) {
        $attributes['aria-pressed'] = 'true';
    }
    $class = htmlspecialchars(trim(implode(' ', array_filter($classes))));
    ?>
    <?php if ($data['link'] !== ''): ?>
        <a href="<?= htmlspecialchars($data['link']) ?>" class="<?= $class ?>" <?= buildAttrs($attributes) ?>><?= renderIcon($data['icon'], 'sort-button__icon') ?></a>
    <?php else: ?>
        <button type="button" class="<?= $class ?>" <?= buildAttrs($attributes) ?>><?= renderIcon($data['icon'], 'sort-button__icon') ?></button>
    <?php endif; ?>
<?php else: ?>
    <span class="sort sort-theme_<?= $data['theme'] ?> <?= htmlspecialchars($data['className']) ?>">
        <span class="sort__text"><?= htmlspecialchars($data['text']) ?></span>
        <span class="sort__buttons"><?= $data['buttons'] ?></span>
    </span>
<?php endif; ?>

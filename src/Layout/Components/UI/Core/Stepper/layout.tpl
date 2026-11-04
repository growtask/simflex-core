<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Other\LoaderIcon\Layout as LoaderIcon;

$classes = [
    'stepper',
    "stepper_style_{$data['style']}",
    "stepper_fill_{$data['fill']}",
    "stepper_size_{$data['size']}",
    "stepper_width_{$data['width']}",
    "stepper-theme_{$data['theme']}",
    $data['loading'] ? 'stepper_loading' : '',
    $data['error'] !== '' ? 'stepper_error' : '',
    $data['className'],
];
$isLocked = $data['loading'] || $data['disabled'];
$attributes = $data['attributes'] + [
    'id' => $data['id'],
    'name' => $data['name'],
    'value' => (string)$data['value'],
    'step' => (string)$data['step'],
    'aria-label' => $data['label'],
];
foreach (['min', 'max'] as $limit) {
    if ($data[$limit] !== null) {
        $attributes[$limit] = (string)$data[$limit];
    }
}
if ($data['error'] !== '') {
    $attributes['aria-invalid'] = 'true';
    $attributes['aria-describedby'] = $data['id'] . '-error';
}
$icon = in_array($data['size'], ['xs', 's'], true) ? 'stepper__icon_small' : '';
?>
<div class="stepper-field">
    <div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" data-sf-stepper
        <?= $data['loading'] ? 'aria-busy="true"' : '' ?>>
        <button type="button" class="stepper__button" data-sf-stepper-step="-1" aria-label="Уменьшить"
                aria-controls="<?= $data['id'] ?>"<?= $isLocked || $data['isMin'] ? ' disabled' : '' ?>>
            <?= renderIcon('minus', trim("stepper__icon $icon")) ?>
        </button>
        <input type="text" inputmode="decimal" class="stepper__input" autocomplete="off"
            <?= buildAttrs($attributes) ?><?= $isLocked ? ' readonly' : '' ?><?= $data['disabled'] ? ' disabled' : '' ?>>
        <?php if ($data['loading']): ?>
            <span class="stepper__loader" aria-hidden="true"><?= LoaderIcon::draw() ?></span>
        <?php endif; ?>
        <button type="button" class="stepper__button" data-sf-stepper-step="1" aria-label="Увеличить"
                aria-controls="<?= $data['id'] ?>"<?= $isLocked || $data['isMax'] ? ' disabled' : '' ?>>
            <?= renderIcon('plus', trim("stepper__icon $icon")) ?>
        </button>
    </div>
    <?php if ($data['error'] !== ''): ?>
        <div class="stepper-field__error" id="<?= $data['id'] ?>-error"><?= htmlspecialchars($data['error']) ?></div>
    <?php endif; ?>
</div>

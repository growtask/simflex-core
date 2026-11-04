<?php
/** @var array $data */

$toggleClasses = [
    'toggle',
    "toggle-size_{$data['size']}",
    "toggle-position_{$data['position']}",
    "toggle-theme_{$data['theme']}",
    isset($data['attributes']['disabled']) ? 'toggle_disabled' : '',
    $data['className'] ?? ''
];
?>

<label class="<?= trim(implode(' ', array_filter($toggleClasses))) ?>">
    <span class="toggle__wrapper">
        <input type="checkbox" class="toggle__input" role="switch" <?= buildAttrs($data['attributes'] ?? []) ?>>
        <span class="toggle__background">
            <span class="toggle__thumb">
                <?php if ($data['icon']): ?>
                    <?= renderIcon('check', 'toggle__check') ?>
                <?php endif; ?>
            </span>
        </span>
    </span>
    <?php if ($data['text']): ?>
        <span class="toggle__text"><?= $data['text'] ?></span>
    <?php endif; ?>
</label>
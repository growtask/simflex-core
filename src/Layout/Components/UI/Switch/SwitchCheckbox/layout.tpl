<?php
/** @var array $data */

$attributes = $data['attributes'] ?? [];
unset($attributes['type']);

$checkboxClasses = [
    'checkbox',
    "checkbox-{$data['style']}",
    "checkbox-size_{$data['size']}",
    "checkbox-position_{$data['position']}",
    "checkbox-theme_{$data['theme']}",
    $data['error'] ? 'checkbox_error' : '',
    isset($attributes['disabled']) ? 'checkbox_disabled' : '',
    $data['className'] ?? ''
];
if ($data['error']) {
    $attributes['aria-invalid'] = 'true';
}
?>

<label class="<?= implode(' ', array_filter($checkboxClasses)) ?>">
    <input type="checkbox" class="checkbox__input" <?= buildAttrs($attributes) ?>>
    <span class="checkbox__custom" aria-hidden="true"></span>
    <?php if ($data['text']): ?>
        <span class="checkbox__text"><?= $data['text'] ?></span>
    <?php endif; ?>
    <?php if ($data['policy'] && !$data['text']): ?>
        <span class="checkbox__policy">
            Я соглашаюсь с <a href="<?= htmlspecialchars($data['policyUrl'], ENT_QUOTES, 'UTF-8') ?>">политикой обработки персональных данных</a>
        </span>
    <?php endif; ?>
</label>

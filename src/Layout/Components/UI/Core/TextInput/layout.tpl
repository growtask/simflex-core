<?php
/** @var array $data */

$isDisabled = isset($data['attributes']['disabled']);
$inputClasses = [
    'text-input',
    "text-input-pos_{$data['labelPos']}",
    "text-input-style_{$data['style']}",
    "text-input-size_{$data['size']}",
    "text-input-theme_{$data['theme']}",
    "text-input-kind_{$data['kind']}",
    $data['value'] !== '' ? 'text-input_filled' : '',
    $data['error'] !== '' ? 'text-input_error' : '',
    $data['success'] && $data['error'] === '' ? 'text-input_success' : '',
    $isDisabled ? 'text-input_disabled' : '',
    $data['className'] ?? ''
];

$attributes = $data['attributes'] ?? [];
$type = $attributes['type'] ?? 'text';
unset($attributes['type']);

$id = htmlspecialchars($data['id'], ENT_QUOTES, 'UTF-8');
$attributes['aria-describedby'] = $id . '-error';
if ($data['error'] !== '') {
    $attributes['aria-invalid'] = 'true';
}
// Поле без видимой подписи получает доступное имя из подсказки
if ($data['labelText'] === '' && !isset($attributes['aria-label']) && $data['placeholder'] !== '') {
    $attributes['aria-label'] = $data['placeholder'];
}
if ($data['errorInvalid'] !== '') {
    $attributes['data-error-invalid'] = $data['errorInvalid'];
}
if ($data['counter']) {
    $attributes['data-max'] = (string)$data['maxLength'];
}
?>

<div class="<?= implode(' ', array_filter($inputClasses)) ?>">
    <div class="text-input__wrapper">
        <?php if ($data['labelText'] !== ''): ?>
            <label class="text-input__label<?= $data['labelPos'] === 'hidden' ? ' visually-hidden' : '' ?>" for="<?= $id ?>"><?= $data['labelText'] ?></label>
        <?php endif; ?>

        <div class="text-input__input-container">
            <input type="<?= htmlspecialchars($type, ENT_QUOTES, 'UTF-8') ?>" id="<?= $id ?>" class="text-input__field"<?php if ($data['placeholder']): ?> placeholder="<?= htmlspecialchars($data['placeholder']) ?>"<?php endif; ?><?php if ($data['value'] !== ''): ?> value="<?= htmlspecialchars($data['value'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?> <?= buildAttrs($attributes) ?>>

            <?php if ($data['icon']): ?>
                <?= renderIcon($data['icon'], 'text-input__icon') ?>
            <?php endif; ?>

            <?php if ($data['counter']): ?>
                <span class="text-input__counter" aria-hidden="true"><?= (int)$data['length'] ?>/<?= (int)$data['maxLength'] ?></span>
            <?php endif; ?>

            <?php if ($data['slot'] !== ''): ?>
                <span class="text-input__slot"><?= $data['slot'] ?></span>
            <?php endif; ?>

            <?= $data['popup'] ?? '' ?>

            <?php if ($data['reset']): ?>
                <button class="text-input__reset reset-button" type="button" aria-label="Очистить" aria-hidden="true" tabindex="-1">
                    <?= renderIcon('close', 'text-input__reset-icon') ?>
                </button>
            <?php endif; ?>
        </div>
        <span class="text-input__error-message<?= $data['error'] === '' ? ' hidden' : '' ?>" id="<?= $id ?>-error" aria-live="polite"><?= htmlspecialchars($data['error'], ENT_QUOTES, 'UTF-8') ?></span>
        <?php if ($data['counter']): ?>
            <span class="text-input__status visually-hidden" aria-live="polite"></span>
        <?php endif; ?>
    </div>
</div>

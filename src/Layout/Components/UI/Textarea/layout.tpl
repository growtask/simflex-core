<?php
/** @var array $data */

$textareaClasses = [
    'textarea',
    "textarea-pos_{$data['labelPos']}",
    "textarea-style_{$data['style']}",
    "textarea-size_{$data['size']}",
    "textarea-theme_{$data['theme']}",
    "textarea-state_{$data['state']}",
    $data['className'] ?? ''
];

$id = $data['id'];
$hasLabel = $data['labelText'] !== '' && $data['labelPos'] !== 'none';
$maxLength = (int)$data['maxLength'];
$length = mb_strlen($data['value']);

// Связанные с полем сообщение и счётчик: читаются скринридером вместе с полем
$describedBy = [];
if ($data['message'] !== '') {
    $describedBy[] = $id . '-message';
}
if ($data['counter']) {
    $describedBy[] = $id . '-counter';
}

$fieldAttrs = $data['attributes'] ?? [];
if ($data['labelPos'] === 'none' && $data['labelText'] !== '' && !isset($fieldAttrs['aria-label'])) {
    $fieldAttrs['aria-label'] = $data['labelText'];
}
if ($data['state'] === 'error') {
    $fieldAttrs['aria-invalid'] = 'true';
}
if ($describedBy) {
    $fieldAttrs['aria-describedby'] = implode(' ', $describedBy);
}
if ($maxLength > 0) {
    $fieldAttrs['maxlength'] = (string)$maxLength;
}
?>

<div class="<?= htmlspecialchars(implode(' ', $textareaClasses)) ?>">
    <div class="textarea__wrapper">
        <?php if ($hasLabel): ?>
            <label class="textarea__label" for="<?= htmlspecialchars($id) ?>"><?= htmlspecialchars($data['labelText']) ?></label>
        <?php endif; ?>

        <div class="textarea__container">
            <textarea id="<?= htmlspecialchars($id) ?>" class="textarea__field"<?php if ($data['placeholder'] !== ''): ?> placeholder="<?= htmlspecialchars($data['placeholder']) ?>"<?php endif; ?> <?= buildAttrs($fieldAttrs) ?>><?= htmlspecialchars($data['value']) ?></textarea>

            <?php if ($data['counter']): ?>
                <span class="textarea__counter" id="<?= htmlspecialchars($id) ?>-counter" aria-live="polite"><?= $length ?><?= $maxLength > 0 ? '/' . $maxLength : '' ?></span>
            <?php endif; ?>
        </div>

        <?php if ($data['message'] !== ''): ?>
            <span class="textarea__message" id="<?= htmlspecialchars($id) ?>-message"><?= htmlspecialchars($data['message']) ?></span>
        <?php endif; ?>
    </div>
</div>

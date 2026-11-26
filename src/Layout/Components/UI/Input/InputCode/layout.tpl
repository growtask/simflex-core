<?php
/** @var array $data */

$classes = [
    'code-input',
    "code-input_state_{$data['state']}",
    "code-input-theme_{$data['theme']}",
    $data['className'],
];
$id = $data['id'];
$messageId = $id . '-message';
$hasMessage = $data['message'] !== '' && $data['state'] !== 'default';
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" id="<?= htmlspecialchars($id) ?>"
     data-sf-code-input<?= buildAttrs($data['attributes']) ?>>
    <input type="hidden" name="<?= htmlspecialchars($data['name']) ?>" value="<?= htmlspecialchars($data['value']) ?>" data-sf-code-value>
    <div class="code-input__digits" role="group" aria-label="<?= htmlspecialchars($data['label']) ?>">
        <?php for ($i = 0; $i < $data['length']; $i++): ?>
            <input type="text" class="code-input__digit" inputmode="numeric" pattern="[0-9]*" maxlength="1"
                   placeholder="0" autocomplete="<?= $i === 0 ? 'one-time-code' : 'off' ?>"
                   value="<?= htmlspecialchars($data['digits'][$i] ?? '') ?>"
                   aria-label="Цифра <?= $i + 1 ?> из <?= (int)$data['length'] ?>"
                   <?= $data['state'] === 'error' ? 'aria-invalid="true"' : '' ?>
                   <?= $hasMessage ? 'aria-describedby="' . htmlspecialchars($messageId) . '"' : '' ?>>
        <?php endfor; ?>
    </div>
    <p class="code-input__message" id="<?= htmlspecialchars($messageId) ?>" aria-live="polite"<?= $hasMessage ? '' : ' hidden' ?>><?= htmlspecialchars($data['message']) ?></p>
</div>

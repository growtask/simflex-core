<?php
/** @var array $data */

$classes = [
    'radio-color',
    "radio-color-size_{$data['size']}",
    "radio-color-theme_{$data['theme']}",
    "radio-color-color_{$data['color']}",
    $data['className'],
];
$id = htmlspecialchars($data['id']);
?>
<span class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>">
    <input type="radio" class="radio-color__input" id="<?= $id ?>" name="<?= htmlspecialchars($data['name']) ?>"
           value="<?= htmlspecialchars($data['value']) ?>"<?= $data['checked'] ? ' checked' : '' ?><?= $data['disabled'] ? ' disabled' : '' ?>
           <?= buildAttrs($data['attributes']) ?>>
    <label class="radio-color__label" for="<?= $id ?>" title="<?= htmlspecialchars($data['label']) ?>">
        <span class="radio-color__swatch"></span>
        <span class="visually-hidden"><?= htmlspecialchars($data['label']) ?></span>
    </label>
</span>

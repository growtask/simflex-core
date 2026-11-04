<?php
/** @var array $data */

$attributes = $data['attributes'] + ['data-sf-tags-input' => ''];
if ($data['searchUrl'] !== '') {
    $attributes['data-search-url'] = $data['searchUrl'];
}
if ($data['allowNew']) {
    $attributes['data-allow-new'] = '';
}
$classes = ['tags-input', "tags-input-theme_{$data['theme']}", $data['disabled'] ? 'tags-input_disabled' : '',
    $data['className']];
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attributes) ?>>
    <input type="hidden" name="<?= htmlspecialchars($data['name']) ?>" value="<?= htmlspecialchars($data['value']) ?>"
           data-sf-tags-value>
    <div class="tags-input__control">
        <?= $data['field'] ?>
        <div class="tags-input__panel" id="<?= htmlspecialchars($data['id']) ?>-list" role="listbox" hidden>
            <div class="tags-input__options"><?= $data['options'] ?></div>
            <p class="tags-input__empty" hidden>Ничего не найдено</p>
        </div>
    </div>
    <div class="tags-input__tags" aria-live="polite"><?= $data['tags'] ?></div>
    <template data-sf-tags-tag><?= $data['tagTemplate'] ?></template>
    <template data-sf-tags-option><?= $data['optionTemplate'] ?></template>
</div>

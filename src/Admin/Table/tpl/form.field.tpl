<?php

/**
 * Поле формы (form-input) для форм, которые собираются без Table/tpl/form.tpl (параметры модуля и т. п.):
 * название, поле, подсказка
 * @var \Simflex\Core\Admin\Fields\Field $field
 */

?>
<div class="form-input<?= $field->isWide() ? ' form-input_wide' : '' ?>" data-field="<?= htmlspecialchars($field->name) ?>">
    <div class="form-input__label"><?= $field->label ?></div>
    <div class="form-input__control"><?= $field->input($field->value) ?></div>
    <?php if ($field->help !== ''): ?>
        <div class="form-input__help"><?= $field->help ?></div>
    <?php endif; ?>
</div>

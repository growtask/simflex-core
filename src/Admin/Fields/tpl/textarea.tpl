<?php

/**
 * Многострочное поле (Textarea/textarea); с визуальным редактором — textarea для TinyMCE (sf-editor-*) в карточке
 * редактора (form-section-editor)
 * @var string $name
 * @var mixed $value
 * @var string $placeholder
 * @var bool $readonly
 * @var string $editor full, mini или пусто
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Textarea\Layout as Textarea;
use Simflex\Core\Layout\Components\UI\Core\Textarea\TextareaLabelPos;
use Simflex\Core\Layout\Components\UI\Core\Textarea\TextareaSize;
use Simflex\Core\Layout\Components\UI\Core\Textarea\TextareaTheme;

$attributes = ['name' => $name, 'aria-label' => strip_tags((string)$this->label)];
if ($readonly) {
    $attributes['readonly'] = 'readonly';
}
?>
<?php if ($editor): ?>
    <div class="form-editor">
        <textarea class="form-editor__textarea<?= $readonly ? ' sf-editor-readonly' : '' ?> sf-editor-<?= $editor ?>"
                  placeholder="<?= htmlspecialchars((string)$placeholder) ?>"
                  name="<?= htmlspecialchars($name) ?>"><?= htmlspecialchars((string)$value) ?></textarea>
    </div>
<?php else: ?>
    <?= Textarea::drawTextarea(
        className: 'form-input__textarea',
        value: (string)$value,
        placeholder: (string)$placeholder,
        maxLength: 0,
        counter: false,
        id: 'field-' . $name,
        labelPos: TextareaLabelPos::Hidden,
        size: TextareaSize::Small,
        theme: TextareaTheme::from(Page::get()->getTheme()),
        attributes: $attributes,
    ) ?>
<?php endif; ?>

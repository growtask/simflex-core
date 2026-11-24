<?php

/**
 * Многострочное поле (Textarea/textarea); с визуальным редактором — textarea, которую texted превращает
 * в редактор (компонент text-editor, Plugins/Editor/text-editor.js), в карточке редактора (form-editor)
 * @var string $name
 * @var mixed $value
 * @var string $placeholder
 * @var bool $readonly
 * @var string $editor full, mini или пусто
 * @var array<string, mixed> $editorOptions Настройки редактора (FieldText::getEditorOptions())
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
$editorJson = $editor
    ? json_encode($editorOptions, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR)
    : '';
?>
<?php if ($editor): ?>
    <div class="form-editor">
        <textarea class="form-editor__textarea" data-sf="text-editor"
                  data-sf-text-editor="<?= htmlspecialchars($editorJson) ?>"
                  id="field-<?= htmlspecialchars($name) ?>"
                  aria-label="<?= htmlspecialchars(strip_tags((string)$this->label)) ?>"
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

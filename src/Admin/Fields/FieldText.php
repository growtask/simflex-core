<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Admin\Plugins\Editor\Editor;

/**
 * Многострочный текст; с параметром editor_full или editor_mini — визуальный редактор (texted, набор блоков
 * full или mini), HTML которого при сохранении очищает сервер
 */
class FieldText extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    public function __construct($row)
    {
        parent::__construct($row);
        $this->editor = '';
        if (!empty($this->params['editor_mini'])) {
            $this->editor = 'mini';
        }
        if (!empty($this->params['editor_full'])) {
            $this->editor = 'full';
        }
    }

    public function loadUI(bool $onForm = false): string
    {
        if ($onForm && $this->editor !== '') {
            Editor::addScript();
        }
        return '';
    }

    public function input($value): string
    {
        return $this->render('textarea', [
            'value' => $value,
            'editor' => $this->editor,
            'editorOptions' => $this->editor !== '' ? $this->getEditorOptions() : [],
        ] + $this->inputVars());
    }

    /**
     * С визуальным редактором значение очищается по набору блоков поля: в базу не попадает HTML,
     * который редактор не мог создать (скрипты, обработчики событий, чужие адреса)
     */
    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = parent::getPOST($simple, $group);
        if ($this->editor !== '' && is_string($value) && $value !== '') {
            return Editor::clean($value, $this->getEditorPreset());
        }
        return $value;
    }

    /**
     * Набор блоков редактора: Editor::PRESET_FULL, PRESET_MINI или PRESET_READONLY (поле только для чтения)
     */
    public function getEditorPreset(): string
    {
        if ($this->readonly) {
            return Editor::PRESET_READONLY;
        }
        return $this->editor === 'mini' ? Editor::PRESET_MINI : Editor::PRESET_FULL;
    }

    /**
     * Настройки редактора поля: набор, право на правку, черновик по таблице, записи и полю
     *
     * @return array<string, mixed>
     */
    protected function getEditorOptions(): array
    {
        $recordId = $this->tablePk !== '' ? $this->getRecordId() : 0;
        $autosaveKey = $recordId && $this->table !== ''
            ? 'sf-' . $this->table . '-' . $recordId . '-' . $this->inputName()
            : '';

        // файлы записи — в своей папке: public/uf/images/<таблица>/<запись>/ (новая запись — /<таблица>/)
        $mediaPath = $this->table !== '' ? '/' . $this->table . ($recordId ? '/' . $recordId : '') : '/';
        $options = Editor::getInitOptions($this->getEditorPreset(), !$this->readonly, $autosaveKey, $mediaPath);
        if ($this->placeholder !== '') {
            $options['placeholder'] = $this->placeholder;
        }

        return $options;
    }
}

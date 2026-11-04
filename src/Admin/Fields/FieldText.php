<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Admin\Plugins\Editor\Editor;

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
        $html = '';
        if ($onForm) {
            if ($this->readonly) {
                $html .= Editor::tinymce('readonly', 'sf-editor-readonly');
            }
            if ('mini' === $this->editor) {
                $html .= Editor::tinymce('mini', 'sf-editor-mini');
            }
            if ('full' === $this->editor) {
                $html .= Editor::tinymce('full', 'sf-editor-full');
            }
        }
        return $html;
    }

    public function input($value): string
    {
        return $this->render('textarea', ['value' => $value, 'editor' => $this->editor] + $this->inputVars());
    }
}

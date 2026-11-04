<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind;
use Simflex\Core\Helpers\Time;

class FieldTime extends Field
{
    private string $pattern;

    public function __construct($row)
    {
        parent::__construct($row);
        $this->pattern = @$this->params['use_seconds'] ? 'H:i:s' : 'H:i';
        $this->defaultValue = $this->e2n ? '' : date($this->pattern);
        if (!empty($this->params['defaultValue'])) {
            $this->defaultValue = $this->params['defaultValue'];
        }
    }

    public function input($value): string
    {
        return $this->render('date', [
            'name' => $this->inputName(),
            'value' => $value ? (string)Time::convert($value, $this->pattern, false) : '',
            // с секундами — поле без календаря: в нём только часы и минуты
            'kind' => @$this->params['use_seconds'] ? TextInputKind::Text : TextInputKind::Time,
            'readonly' => $this->readonly,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = (string)$this->getPosted();
        if ($simple) {
            return $value;
        }
        $ret = $this->e2n && $value === '' ? null : Time::convert($value, $this->pattern, false);
        return $ret;
    }

    public function show($row): string
    {
        return $row[$this->name] ? (string)Time::convert($row[$this->name], $this->pattern, false) : '';
    }
}

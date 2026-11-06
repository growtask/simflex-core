<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind;
use Simflex\Core\Helpers\Time;

class FieldDate extends Field
{
    public function __construct($row)
    {
        parent::__construct($row);
        $this->defaultValue = $this->e2n ? '' : date('Y-m-d');
        if (!empty($this->params['defaultValue'])) {
            $this->defaultValue = $this->params['defaultValue'];
        }
    }

    public function input($value): string
    {
        $time = $value ? strtotime((string)$value) : false;
        if (!$value && !$this->e2n) {
            $time = time();
        }
        return $this->render('date', [
            'value' => $time ? date('d.m.Y', $time) : '',
            'name' => $this->inputName(),
            'kind' => TextInputKind::Date,
            'readonly' => $this->readonly,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = (string)$this->getPosted();
        if ($simple) {
            return $value;
        }
        if (preg_match('@^[0-9]{2}.[0-9]{2}.[0-9]{4}$@', $value)) {
            $value = substr($value, -4) . '-' . substr($value, 3, 2) . '-' . substr($value, 0, 2);
        }
        return $this->e2n && $value === '' ? null : $value;
    }

    public function show($row): string
    {
        return $this->cell($row[$this->name] ? Time::userFull($row[$this->name]) : '');
    }

    public function filter($value): string
    {
        return $this->filterDateRange($value);
    }

    public function getFilterLabel(string $value): string
    {
        return DateRange::getLabel($value);
    }
}

<?php

namespace Simflex\Core\Admin\Fields;

class FieldBool extends FieldInt
{
    public string $style = 'text-align:center;';
    public mixed $defaultValue = 0;

    public function input($value): string
    {
        return $this->render('bool', [
            'name' => $this->inputName(),
            'checked' => (bool)$value,
            'readonly' => $this->readonly,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $postValue = $this->getPosted(group: $group);
        return $this->e2n && empty($postValue) ? 0 : (isset($postValue) ? 1 : 0);
    }

    public function show($row): string
    {
        return $this->render('bool-show', ['checked' => (bool)$row[$this->name]]);
    }

    public function showDetail($row): string
    {
        $value = $row[$this->name . ($this->fk ? '_label' : '')];
        return $value ? 'Да' : 'Нет';
    }

    public function getFilterLabel(string $value): string
    {
        return $value === '1' ? 'Да' : ($value === '0' ? 'Нет' : parent::getFilterLabel($value));
    }

    public function filter($value): string
    {
        if ($this->filter) {
            return $this->filterDropdown([
                'name' => 'filter[' . $this->name . ']',
                'value' => $value,
                'items' => [['1', 'Да'], ['0', 'Нет'], ['', '—']],
            ]);
        }
        return '';
    }
}

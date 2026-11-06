<?php

namespace Simflex\Core\Admin\Fields;

/**
 * Основа полей выбора значения из реестра в коде (классы, привилегии, таблицы...),
 * см. \Simflex\Core\System\ExtensionRegistry. Выводится тем же выпадающим списком, что и внешний ключ
 */
abstract class FieldExtensionSelect extends Field
{
    /**
     * @return array<string, string> значение => название
     */
    abstract protected function options(): array;

    public function input($value): string
    {
        $value = ltrim((string)($this->value ?: $value), '\\');
        $options = $this->options();
        $items = [['', '—']];
        foreach ($options as $optionValue => $name) {
            $items[] = [$optionValue, $name];
        }

        return $this->dropdown([
            'name' => $this->inputName(),
            'value' => $value,
            'onchange' => $this->onchange,
            'readonly' => $this->readonly,
            'disabled' => $this->readonly,
            'current' => $options[$value] ?? '—',
            'items' => $items,
        ]);
    }

    public function getFilterLabel(string $value): string
    {
        return (string)($this->options()[$value] ?? $value);
    }

    public function getFilterOptions(): array
    {
        $options = [];
        foreach ($this->options() as $value => $label) {
            $options[(string)$value] = strip_tags((string)$label);
        }
        return $options;
    }

    public function filter($value): string
    {
        if (!$this->filter) {
            return '';
        }

        return $this->filterDropdown([
            'name' => 'filter[' . $this->name . ']',
            'value' => (string)$value,
            'items' => $this->getFilterItems(),
        ]);
    }

    public function show($row): string
    {
        return $this->cell((string)$this->showDetail($row));
    }

    public function showDetail($row): ?string
    {
        $value = ltrim((string)($row[$this->name] ?? ''), '\\');
        return htmlspecialchars($this->options()[$value] ?? $value);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = $this->getPosted(group: $simple ? $group : null);
        return $value === '' && !$simple && $this->e2n ? null : $value;
    }
}

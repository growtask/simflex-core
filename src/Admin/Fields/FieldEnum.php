<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\DB;

class FieldEnum extends FieldString
{
    /** @var array<string, array<string, array<string, string>>> таблица => колонка => значение => подпись */
    protected static array $values = [];
    protected string $changeURL = '';

    public function input($value): string
    {
        return $this->dropdown([
            'name' => $this->name,
            'value' => !$value ? '' : $value,
            'onchange' => $this->onchange,
            'items' => $this->dropdownItems($this->e2n),
        ]);
    }

    protected function dropdownItems(bool $withEmpty): array
    {
        $items = $withEmpty ? [['', '—']] : [];
        foreach ($this->fetchValues() as $k => $v) {
            $items[] = [$k, $v];
        }
        return $items;
    }

    protected function fetchValues(): array
    {
        $buffer = &static::$values[$this->table][$this->name];

        if (!isset($buffer)) {
            // описание колонки: значения ENUM и их подписи в комментарии (через ;;)
            $row = DB::columnInfo($this->table, $this->name);
            $enumArray = [];
            preg_match_all("/'(.*?)'/", $row['Type'], $enumArray);
            $enumFields = $enumArray[1];
            $names = explode(';;', $row['Comment']);
            if (count($names) === count($enumFields)) {
                $ret = [];
                foreach ($names as $index => $name) {
                    $ret[$enumFields[$index]] = trim($name);
                }
                $buffer = $ret;
            } else {
                if ($this->params['enum'] ?? '') {
                    $buffer = [];
                    foreach (explode(';;', $this->params['enum']) as $kv) {
                        $kvv = explode('=', $kv);
                        $buffer[$kvv[0]] = $kvv[1];
                    }
                } else {
                    $buffer = [];
                    foreach ($enumFields as $name) {
                        $buffer[$name] = $name;
                    }
                }
            }
        }

        return $buffer;
    }

    public function getFilterLabel(string $value): string
    {
        return (string)($this->fetchValues()[$value] ?? parent::getFilterLabel($value));
    }

    public function filter($value): string
    {
        if ($this->filter) {
            return $this->filterDropdown([
                'name' => 'filter[' . $this->name . ']',
                'value' => $value,
                'items' => $this->dropdownItems(true),
            ]);
        }
        return '';
    }

    public function showDetail($row): ?string
    {
        $value = $row[$this->name];
        $values = $this->fetchValues();
        return @$values[$value];
    }

    public function show($row): string
    {
        $options = [];
        foreach ($this->fetchValues() as $key => $label) {
            $options[(string)$key] = strip_tags((string)$label);
        }
        $value = $row[$this->name] ?? null;

        // смена статуса сохраняется сразу (action=change_enum, theme/js/list.js)
        return \Simflex\Core\Layout\Components\UI\Core\Dropdown\Layout::drawSelect(
            $this->name . '_' . $row[$this->tablePk],
            $options,
            $value === null || $value === '' ? null : (string)$value,
            placeholder: '—',
            size: \Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownSize::Small,
            theme: \Simflex\Core\Layout\Components\UI\Core\Dropdown\DropdownTheme::from(
                \Simflex\Core\Admin\Page::get()->getTheme()
            ),
            disabled: $this->readonly,
            className: 'td-enum',
            attributes: [
                'aria-label' => strip_tags($this->label),
                'data-sf-enum-change' => '?' . http_build_query([
                    'action' => 'change_enum',
                    'field' => $this->name,
                    $this->tablePk => $row[$this->tablePk],
                ]),
            ],
        );
    }
}

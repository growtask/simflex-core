<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\DB;
use Simflex\Core\DB\AQ;
use Simflex\Core\Admin\Table\Repository;

class FieldInt extends Field
{
    public mixed $defaultValue = 0;

    public string $filterAndWhere = '';
    /** @var callable возвращает [x => [y => [label => z], q => [label => k]]] */
    public \Closure|array|string $filterDataProvider;

    public function __construct($row)
    {
        parent::__construct($row);
        $this->isNumeric = !$this->fk;
        $this->filterDataProvider = function () {
            return $this->tree();
        };
    }

    protected function bigint($value): string
    {
        return sprintf('%.0f', $value);
    }

    /**
     * Находит в $table колонку «родителя» — ссылку на ту же таблицу (fk_is_pid).
     *
     * @return string Экранированное имя колонки или '0', если такой колонки в таблице нет
     */
    protected function fkPidColumn(string $table): string
    {
        $fkClass = Repository::getTableClass($table);
        $fkTableFields = $fkClass ? $fkClass::getFieldRows() : [];
        foreach ($fkTableFields as $fkTableField) {
            if ($fkTableField['class'] === 'FieldInt' || str_ends_with($fkTableField['class'], '\\FieldInt')) {
                $fkParams = $fkTableField['params'];
                if (!empty($fkParams['main']['fk_is_pid'])) {
                    return DB::wrapName($fkTableField['name']);
                }
            }
        }

        return '0';
    }

    public function &tree(): array
    {
        $tree = [];
        $fkPID = $this->fkPidColumn($this->fk->table);

        $query = new AQ()
            ->select("{$this->fk->key} id, $fkPID pid, {$this->fk->label} label")
            ->from($this->fk->table)
            ->orderBy($this->fk->key);
        if (($exclude = $this->getRequest()->request($this->fk->key)) !== null) {
            $query->andWhere("{$this->fk->key} <> " . $this->bigint($exclude));
        }
        if ($this->filterAndWhere) {
            $query->andWhere($this->filterAndWhere);
        }
        foreach ($query->asArray()->all() as $row) {
            $tree[$this->bigint($row['pid'])][$this->bigint($row['id'])] = $row;
        }
        return $tree;
    }

    public function input($value): string
    {
        if (!$this->fk) {
            return $this->render('input', ['value' => $value] + $this->inputVars());
        }

        $withPid = (bool)$this->params['fk_is_pid'];
        $items = $this->getFkQuery($withPid)->limit(20)->all();
        $sel = $this->getFkRow($value, $withPid);

        $listItems = [];
        $hasId = false;
        foreach ($items as $r) {
            if ($r['id'] == ($sel['id'] ?? null)) {
                $hasId = true;
            }

            if ($withPid) {
                $pidName = $this->getContentTitle($r['pid']);
                if ($pidName) {
                    $r['name'] = $pidName . ' -> ' . $r['name'];
                }
            }
            $listItems[] = [$r['id'], $r['name']];
        }

        if (!$hasId && $sel) {
            if ($withPid) {
                $pidName = $this->getContentTitle($sel['pid']);
                if ($pidName) {
                    $sel['name'] = $pidName . ' -> ' . $sel['name'];
                }
            }
            array_unshift($listItems, [$sel['id'], $sel['name']]);
        }

        return $this->dropdown([
            'name' => $this->name,
            'value' => !$value ? '' : $value,
            'onchange' => $this->onchange,
            'readonly' => $this->readonly,
            'disabled' => $this->readonly,
            'action' => 'searchInt',
            'search' => true,
            'current' => $sel['name'] ?? '',
            'items' => $listItems,
        ]);
    }

    /**
     * Записи связанной таблицы: id, name (подпись) и, если $withPid, pid (родитель)
     */
    protected function getFkQuery(bool $withPid = false): AQ
    {
        $fields = [
            DB::wrapName($this->params['fk_key']) . ' AS id',
            DB::wrapName($this->params['fk_label']) . ' AS name',
        ];
        if ($withPid) {
            $fields[] = $this->fkPidColumn($this->params['fk_table']) . ' AS pid';
        }

        return new AQ()->asArray()->select($fields)->from($this->params['fk_table']);
    }

    /**
     * Запись связанной таблицы по id, пустой массив - не найдена
     */
    protected function getFkRow(mixed $id, bool $withPid = false): array
    {
        return $this->getFkQuery($withPid)->where([$this->params['fk_key'] => $id])->fetchOne() ?? [];
    }

    /**
     * Заголовок страницы раздела «Страницы» (подпись родителя)
     */
    protected function getContentTitle(mixed $id): ?string
    {
        $title = new AQ()->select('title')->from('content')->where(['content_id' => (int)$id])->fetchScalar();
        return $title === null ? null : (string)$title;
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = $this->getPosted();
        return $this->e2n && $value === '' ? null : (int)$value;
    }

    public function getFilterLabel(string $value): string
    {
        if ($this->fk && ($row = $this->getFkRow($value))) {
            return (string)$row['name'];
        }

        return parent::getFilterLabel($value);
    }

    public function filter($value): string
    {
        if (!$this->filter) {
            return '';
        }
        if ($this->fk) {
            $sel = $this->getFkRow($value);

            return $this->filterDropdown([
                'name' => 'filter[' . $this->name . ']',
                'value' => $value,
                'action' => 'searchInt',
                'search' => true,
                'items' => $sel ? [[$sel['id'], $sel['name']]] : [],
            ]);
        }

        // число: в поле фильтра вводятся только цифры (theme/js/list.js)
        return $this->render('filter', [
            'name' => $this->name,
            'placeholder' => $this->width === 0.0 ? $this->label : '',
            'value' => $value,
            'isDigits' => true,
        ]);
    }
}

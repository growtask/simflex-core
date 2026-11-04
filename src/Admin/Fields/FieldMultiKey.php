<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\Admin\Table\Table;
use Simflex\Core\DB\DB;
use Simflex\Core\DB\AQ;

/**
 * Связи «многие ко многим»: записи другой таблицы, выбранные тегами. Колонки у поля нет, связи хранятся в таблице
 * связей. Параметры типа поля (проще через пресет \Simflex\Core\Admin\Table\Presets\MultiKeyField):
 * - table_values — таблица выбираемых записей;
 * - table_relations — таблица связей;
 * - key — первичный ключ table_values, он же колонка таблицы связей с выбранной записью;
 * - key_alias — колонка table_values, которая показывается вместо ключа;
 * - relation_key — колонка таблицы связей с id записи раздела, по умолчанию — первичный ключ раздела;
 * - parent_key — колонка родителя в table_values: запись подписывается «Имя (Родитель)».
 * Связи пишутся по id записи, поэтому у новой записи сохраняются после её вставки (Table::save())
 */
class FieldMultiKey extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    /** @var array<int, string>|null подписи связей записей показываемого списка: id записи => «Имя, Имя» */
    protected ?array $listLabels = null;

    public function __construct($row)
    {
        parent::__construct($row);
        $this->isVirtual = true;
        $this->isSavedById = true;
    }

    /**
     * Колонка таблицы связей с id записи раздела
     */
    public function getRelationKey(): string
    {
        return (string)($this->params['relation_key'] ?? '') ?: $this->tablePk;
    }

    public function input($value): string
    {
        // форма, показанная снова после ошибки сохранения, — с выбранными в ней записями
        if ($this->getPosted() !== null) {
            $selected = $this->getPostedIds();
        } else {
            $id = $this->getRecordId();
            $selected = $id ? $this->getSelectedIds($id) : [];
        }

        $values = $this->getValues();
        return $this->render('tags', [
            'name' => $this->name,
            // выбранные — в порядке выбора, с подписями записей
            'selected' => array_intersect_key($values, array_flip($selected)),
            'options' => $values,
            'searchUrl' => '',
            'allowNew' => false,
        ]);
    }

    /**
     * Сохраняет связи записи. Без id записи (новая запись до вставки) и без значения в форме ничего не пишет
     */
    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $id = $this->getRecordId();
        if (!$id || $this->getPosted() === null) {
            return '';
        }

        $relations = (string)$this->params['table_relations'];
        $relationKey = $this->getRelationKey();
        $key = (string)$this->params['key'];
        DB::transaction(function () use ($relations, $relationKey, $key, $id) {
            DB::delete($relations, [$relationKey => $id]);
            DB::insert($relations, array_map(fn(int $valueId) => [$relationKey => $id, $key => $valueId], $this->getPostedIds()));
        });

        return '';
    }

    public function show($row): string
    {
        $this->listLabels ??= $this->getListLabels();

        return $this->cell($this->listLabels[(int)$row[$this->tablePk]] ?? '');
    }

    public function getFilterLabel(string $value): string
    {
        return (string)($this->getValues([(int)$value])[(int)$value] ?? $value);
    }

    public function filter($value): string
    {
        $value = (string)$value;
        $label = $value !== '' ? ($this->getValues([(int)$value])[(int)$value] ?? '') : '—';

        return $this->filterDropdown([
            'name' => 'filter[' . $this->name . ']',
            'value' => $value,
            'action' => 'searchMultiKey',
            'search' => true,
            'items' => [[$value, htmlspecialchars($label)]],
        ]);
    }

    public function selectQueryField(): string
    {
        return '';
    }

    /**
     * Выбираемые записи: ключ => подпись (с родителем, если задан parent_key), по порядку ключа
     *
     * @param int[]|null $ids Только эти записи
     * @param string $search Только записи, в подписи которых есть этот текст
     * @param int $limit Не больше стольких записей, 0 — все
     * @return array<int, string>
     */
    public function getValues(?array $ids = null, string $search = '', int $limit = 0): array
    {
        if ($ids === []) {
            return [];
        }

        $values = (string)$this->params['table_values'];
        $key = (string)$this->params['key'];
        $label = DB::wrapName((string)$this->params['key_alias']);
        $parentKey = (string)($this->params['parent_key'] ?? '');

        $select = ['t.' . DB::wrapName($key) . ' AS id', "t.$label AS name"];
        $query = (new AQ())->asArray()->from($values, 't')->orderBy('t.' . DB::wrapName($key));
        if ($parentKey !== '') {
            $select[] = "p.$label AS parent";
            $query->leftJoin($values, 't.' . $parentKey, 'p.' . $key, alias: 'p');
        }
        $query->select($select);
        if ($ids !== null) {
            $query->andWhere(['t.' . $key => array_map('intval', $ids)]);
        }
        if ($search !== '') {
            $query->andWhere("t.$label LIKE :search")->bind(['search' => '%' . $search . '%']);
        }
        if ($limit > 0) {
            $query->limit($limit);
        }

        $out = [];
        foreach ($query->all() as $row) {
            $out[(int)$row['id']] = $row['name'] . (($row['parent'] ?? '') !== '' ? ' (' . $row['parent'] . ')' : '');
        }

        return $out;
    }

    /**
     * Ключи записей, связанных с записью раздела
     *
     * @return int[]
     */
    protected function getSelectedIds(int $id): array
    {
        return array_map('intval', (new AQ())->asArray()->from((string)$this->params['table_relations'])
            ->select(DB::wrapName((string)$this->params['key']))
            ->where([$this->getRelationKey() => $id])
            ->fetchColumn());
    }

    /**
     * Ключи записей, выбранных в форме: «1,2,3»
     *
     * @return int[]
     */
    protected function getPostedIds(): array
    {
        return array_values(array_unique(array_filter(array_map('intval', explode(',', (string)$this->getPosted())))));
    }

    /**
     * Подписи связей записей показываемого списка (Table::$currentQuery, без него — всех записей):
     * id записи => «Имя, Имя»
     *
     * @return array<int, string>
     */
    protected function getListLabels(): array
    {
        $relationKey = 'r.' . DB::wrapName($this->getRelationKey());
        $query = (new AQ())->asArray()->from((string)$this->params['table_relations'], 'r')
            ->select(["$relationKey AS record_id", 'r.' . DB::wrapName((string)$this->params['key']) . ' AS value_id']);
        if (Table::$currentQuery) {
            $list = (clone Table::$currentQuery)
                ->select(DB::wrapName($this->table) . '.' . DB::wrapName($this->tablePk))
                ->orderBy(null)
                ->limit('');
            $query->where("$relationKey IN (" . $list->build() . ')')->bind($list->getBinds());
        }
        $relations = $query->all();

        $labels = $this->getValues(array_values(array_unique(array_map(fn($row) => (int)$row['value_id'], $relations))));
        $out = [];
        foreach ($relations as $row) {
            if (isset($labels[(int)$row['value_id']])) {
                $out[(int)$row['record_id']][] = $labels[(int)$row['value_id']];
            }
        }

        return array_map(fn(array $items) => implode(', ', $items), $out);
    }
}

<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\DB;
use Simflex\Core\DB\AQ;

/**
 * Взаимные связи записей одной таблицы (например, «другие цвета» товара): выбранные записи связаны с записью формы
 * и друг с другом. Пара хранится в таблице связей одной строкой, в любом порядке. Параметры типа поля:
 * - relation — таблица связей;
 * - left, right — её колонки с id записей пары;
 * - name — колонка таблицы раздела, которая показывается в тегах.
 * Связи пишутся по id записи, поэтому у новой записи сохраняются после её вставки (Table::save())
 */
class FieldRelation extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    public function __construct($row)
    {
        parent::__construct($row);
        $this->isVirtual = true;
        $this->isSortable = (bool)($this->params['is_sortable'] ?? false);
        $this->isSavedById = true;
    }

    public function input($value): string
    {
        $id = $this->getRecordId();
        $rows = $id ? $this->getRelated($id) : [];

        return $this->render('tags', [
            'name' => $this->name,
            'selected' => array_map('strval', $rows),
            'options' => [],
            // записи раздела ищет Table::searchTags()
            'searchUrl' => '?action=searchTags&name=' . rawurlencode($this->name),
            'allowNew' => false,
        ]);
    }

    /**
     * Сохраняет связи записи: прежняя группа связанных записей распадается, выбранные записи и запись формы
     * связываются попарно. Без id записи (новая запись до вставки) и без значения в форме ничего не пишет
     */
    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $id = $this->getRecordId();
        if (!$id || $this->getPosted() === null) {
            return '';
        }

        $posted = array_map('intval', explode(',', (string)$this->getPosted()));
        $posted = array_values(array_diff(array_unique(array_filter($posted)), [$id]));
        $old = array_merge([$id], array_keys($this->getRelated($id)));
        $new = array_merge([$id], $posted);

        $left = (string)$this->params['left'];
        $right = (string)$this->params['right'];
        $pairs = [];
        for ($i = 0; $i < count($new) - 1; $i++) {
            for ($k = $i + 1; $k < count($new); $k++) {
                $pairs[] = [$left => $new[$i], $right => $new[$k]];
            }
        }
        DB::transaction(function () use ($old, $new, $pairs) {
            $this->deletePairs($old);
            $this->deletePairs($new);
            DB::insert((string)$this->params['relation'], $pairs);
        });

        return '';
    }

    /**
     * Записи, связанные с записью: id => подпись
     *
     * @return array<int, string>
     */
    protected function getRelated(int $id): array
    {
        $pk = 't.' . DB::wrapName($this->tablePk);
        $left = 'p.' . DB::wrapName((string)$this->params['left']);
        $right = 'p.' . DB::wrapName((string)$this->params['right']);
        $rows = (new AQ())->asArray()->from($this->table, 't')
            ->select(["$pk AS id", 't.' . DB::wrapName((string)$this->params['name']) . ' AS name'])
            ->where(
                'EXISTS (SELECT 1 FROM ' . DB::wrapName((string)$this->params['relation']) . ' p'
                . " WHERE ($right = :relation_id1 AND $left = $pk) OR ($left = :relation_id2 AND $right = $pk))"
            )
            ->bind(['relation_id1' => $id, 'relation_id2' => $id])
            ->orderBy($pk)
            ->all();

        $out = [];
        foreach ($rows as $row) {
            $out[(int)$row['id']] = (string)$row['name'];
        }

        return $out;
    }

    /**
     * Удаляет пары связей между записями группы
     *
     * @param int[] $ids
     */
    protected function deletePairs(array $ids): void
    {
        if (count($ids) < 2) {
            return;
        }

        DB::delete((string)$this->params['relation'], [(string)$this->params['left'] => $ids, (string)$this->params['right'] => $ids]);
    }
}

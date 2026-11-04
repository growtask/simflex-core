<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\AQ;
use Simflex\Core\System\Container;

/**
 * Таблица записей другой таблицы в форме (например, фото отзыва): строки добавляются, меняются и удаляются ajax-
 * действиями раздела vtAdd, vtEdit, vtDelete, страница строк — vtGet. Раздел задаёт запросы строк и их количества
 * (обычно в initTable()) и колонки в формате FieldTable. Файлы колонок image/file загружаются действием
 * upload_table_file раздела (Table::uploadTableFile())
 */
class FieldVirtualTable extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    /**
     * Запрос строк страницы, первая колонка __id — id строки; количество строк считается по нему же,
     * без ORDER BY и LIMIT
     */
    public ?AQ $query = null;
    public array $cols = [];
    public string $button = '';
    public string $customjs = '';

    public function __construct($row)
    {
        parent::__construct($row);
        $this->isVirtual = true;
    }

    public function input($value): string
    {
        if (!$this->getRecordId()) {
            return $this->render('vtable-notice');
        }

        $value = (string)$this->getValue();
        $total = $this->getCount();
        $attributes = [
            'data-sf-table-mode' => 'virtual',
            // адрес действий раздела и запись формы: ?action=vtGet&<pk>=<id>
            'data-sf-table-url' => Container::getRequest()->getPath(),
            'data-sf-table-pk' => $this->tablePk . '=' . $this->getRecordId(),
            'data-sf-table-total' => (string)$total,
        ];

        return $this->render('table', ['value' => $value, 'isVirtual' => true] + compact('total', 'attributes'))
            . $this->customjs;
    }

    public function getCount(): int
    {
        return $this->query ? (int)(clone $this->query)->select('COUNT(*)')->orderBy(null)->limit('')->fetchScalar() : 0;
    }

    /**
     * Строки страницы
     *
     * @return list<array<string, mixed>>
     */
    protected function getRows(): array
    {
        return $this->query ? (clone $this->query)->asArray()->all() : [];
    }

    public function getValue(): string|false
    {
        $vv = [];
        foreach ($this->getRows() as $r) {
            foreach ($r as $k => $v) {
                $v = (string)$v;
                if ($k === 'img_json') {
                    // первое по порядку изображение из значения FieldTable, без них — картинка по умолчанию
                    $js = json_decode($v, true)['v'] ?? [];
                    usort($js, fn($a, $b) => (int)($a['npp'] ?? 0) <=> (int)($b['npp'] ?? 0));
                    $r['img'] = $js[0]['img'] ?? asset('img/default-img.png');
                    unset($r['img_json']);
                    continue;
                }

                if (str_starts_with($v, 'RM:')) {
                    $d = explode(';;', substr($v, 3));
                    $r[$k] = $d[0];
                    $r['__rm_id'] = $d[1];
                }

                if (str_starts_with($v, 'RMJ:')) {
                    $d = explode(';;', substr($v, 4));
                    $r[$k] = $d[0];
                    $r['__rmj_id'] = $d[1];
                }
            }

            $vv[] = $r;
        }

        return json_encode([
            's' => $this->cols,
            'v' => $vv,
        ]);
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        return '';
    }
}

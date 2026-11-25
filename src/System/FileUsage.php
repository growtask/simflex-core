<?php

namespace Simflex\Core\System;

use Simflex\Core\DB\AQ;
use Simflex\Core\DB\DB;
use Simflex\Core\DB\Schema;

/**
 * Где на сайте стоит ссылка на файл: поиск адреса во всех текстовых колонках таблиц базы (CHAR, VARCHAR, TEXT,
 * JSON). Файловый менеджер показывает это в подтверждении удаления, переименования и перемещения, чтобы страницы
 * не ломались молча. Ищется подстрока адреса (/uf/images/a.png - и в полном адресе с доменом, и в HTML или JSON
 * значения), для папки - адрес с / в конце (всё, что внутри). Таблицы журналов и служебные не просматриваются
 * (ConfigBase::$fileUsageIgnoreTables)
 */
class FileUsage
{
    /**
     * @param string[] $ignoreTables Таблицы, которые не просматриваются
     */
    public function __construct(protected array $ignoreTables = [])
    {
    }

    /**
     * Сколько записей каждой таблицы содержат адрес
     *
     * @param string $url Адрес файла от корня сайта (/uf/images/a.png) или папки с / в конце (/uf/images/blog/)
     * @return array<string, int> таблица => число записей, только таблицы, где адрес найден
     */
    public function find(string $url): array
    {
        $needles = array_values(array_unique([$url, static::encodePath($url)]));
        $counts = [];
        foreach ($this->getTextColumns() as $table => $columns) {
            $conditions = [];
            $binds = [];
            foreach ($columns as $column) {
                foreach ($needles as $needle) {
                    $bind = 'needle' . count($binds);
                    $conditions[] = DB::wrapName($column) . " LIKE :$bind ESCAPE '!'";
                    $binds[$bind] = '%' . static::escapeLike($needle) . '%';
                }
            }
            $count = (int)(new AQ())->from($table)->select('COUNT(*)')->where(implode(' OR ', $conditions))
                ->bind($binds)->fetchScalar();
            if ($count > 0) {
                $counts[$table] = $count;
            }
        }

        return $counts;
    }

    /**
     * Текстовые колонки таблиц, в которых ищется адрес
     * @return array<string, string[]> таблица => колонки
     */
    protected function getTextColumns(): array
    {
        return array_diff_key(Schema::getTextColumns(), array_flip($this->ignoreTables));
    }

    /** Подстрока для LIKE с ESCAPE '!': % и _ (часто в именах файлов) - как обычные символы */
    protected static function escapeLike(string $value): string
    {
        return strtr($value, ['!' => '!!', '%' => '!%', '_' => '!_']);
    }

    /** Адрес с закодированными сегментами: /uf/images/фото.png → /uf/images/%D1%84%D0%BE%D1%82%D0%BE.png */
    protected static function encodePath(string $url): string
    {
        return implode('/', array_map('rawurlencode', explode('/', $url)));
    }
}

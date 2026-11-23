<?php

namespace Simflex\Core\System;

use Simflex\Core\DB\DB;

/**
 * Где на сайте стоит ссылка на файл: поиск адреса во всех текстовых колонках таблиц базы (CHAR, VARCHAR, TEXT,
 * JSON). Файловый менеджер показывает это в подтверждении удаления и переименования, чтобы страницы не ломались
 * молча. Ищется подстрока адреса (/uf/images/a.png - и в полном адресе с доменом, и в HTML или JSON значения),
 * для папки - адрес с / в конце (всё, что внутри). Таблицы журналов и служебные - не просматриваются
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
        $out = [];
        foreach ($this->textColumns() as $table => $columns) {
            $conditions = [];
            $params = [];
            foreach ($columns as $column) {
                foreach ($needles as $needle) {
                    $conditions[] = DB::wrapName($column) . " LIKE ? ESCAPE '!'";
                    $params[] = '%' . static::escapeLike($needle) . '%';
                }
            }
            $count = (int)DB::result(
                'SELECT COUNT(*) AS cnt FROM ' . DB::wrapName($table) . ' WHERE ' . implode(' OR ', $conditions),
                'cnt',
                $params
            );
            if ($count > 0) {
                $out[$table] = $count;
            }
        }

        return $out;
    }

    /**
     * Текстовые колонки таблиц базы сайта
     * @return array<string, string[]> таблица => колонки
     */
    protected function textColumns(): array
    {
        $rows = DB::assoc(
            "SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
                AND DATA_TYPE IN ('char', 'varchar', 'tinytext', 'text', 'mediumtext', 'longtext', 'json')
            ORDER BY TABLE_NAME, ORDINAL_POSITION"
        ) ?: [];
        $out = [];
        foreach ($rows as $row) {
            if (!in_array($row['TABLE_NAME'], $this->ignoreTables, true)) {
                $out[$row['TABLE_NAME']][] = $row['COLUMN_NAME'];
            }
        }

        return $out;
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

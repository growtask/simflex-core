<?php

namespace Simflex\Core\DB;

use Simflex\Core\System\Container;
use Simflex\Core\Logger\Log;
use Simflex\Core\DB\Schema\Table;

class Schema
{
    /** @var Table[] Существующие таблицы */
    protected array $tables = [];

    /** @var Table[] Таблицы, ожидающие создания (commit) */
    protected array $awaitingCreate = [];

    /** @var Table[] Таблицы, ожидающие удаления */
    protected array $awaitingDelete = [];

    /** @var Table[] Таблицы, созданные за время жизни этого объекта */
    protected array $sessionCreated = [];

    protected array $awaitingAlter = [];

    /** @var callable[] Данные для записи после создания таблиц, см. seed() */
    protected array $awaitingSeed = [];

    public function __construct()
    {
        $this->reload();
    }

    // ------------ УТИЛИТЫ ------------ //
    public function reload(): void
    {
        $dbName = Container::getConfig()->db['name'];
        $this->tables = [];

        $tables = DB::query(
            'select TABLE_NAME, AUTO_INCREMENT from information_schema.TABLES where TABLE_SCHEMA = ?',
            [$dbName]
        );
        while ($table = DB::fetch($tables)) {
            $tableName = $table['TABLE_NAME'];
            $tab = $this->tables[$tableName] = $this->loadTable($tableName);
            if ($table['AUTO_INCREMENT']) {
                $tab->autoIncrement($table['AUTO_INCREMENT']);
            }
        }
    }

    protected function loadTable(string $name): Table
    {
        $table = new Table($name, true);

        $columns = DB::query('select * from information_schema.COLUMNS where TABLE_NAME = ? and TABLE_SCHEMA = ?', [
            $name,
            Container::getConfig()->db['name'],
        ]);

        while ($col = DB::fetch($columns)) {
            $c = $table->addColumn(
                $col['COLUMN_NAME'],
                $col['DATA_TYPE'],
                $col['CHARACTER_MAXIMUM_LENGTH'] ?? $col['NUMERIC_PRECISION'] + 1
            );

            if ($col['COLUMN_DEFAULT']) {
                $c->setDefault($col['COLUMN_DEFAULT']);
            }

            if ($col['COLUMN_KEY'] === 'PRI') {
                $c->primaryKey();
            }

            if (strpos($col['EXTRA'], 'auto_increment') !== false) {
                $c->autoIncrement();
            }

            $c->comment($col['COLUMN_COMMENT']);
            $c->setNull($col['IS_NULLABLE'] === 'YES');
        }

        $table->keepParams();

        // TODO: загружать ограничения
        return $table;
    }

    public function hasTable(string $name): bool
    {
        return isset($this->tables[$name]);
    }

    /**
     * Текстовые колонки (CHAR, VARCHAR, TEXT, JSON) всех таблиц базы сайта, без загрузки схемы таблиц
     * (System\FileUsage ищет в них адреса файлов)
     *
     * @return array<string, string[]> таблица => колонки в порядке таблицы
     */
    public static function getTextColumns(): array
    {
        $rows = DB::assoc(
            "SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
                AND DATA_TYPE IN ('char', 'varchar', 'tinytext', 'text', 'mediumtext', 'longtext', 'json')
            ORDER BY TABLE_NAME, ORDINAL_POSITION"
        ) ?: [];
        $columns = [];
        foreach ($rows as $row) {
            $columns[$row['TABLE_NAME']][] = $row['COLUMN_NAME'];
        }

        return $columns;
    }

    // ------------ ИЗМЕНЕНИЕ ------------ //

    /**
     * @param string $name Имя таблицы
     * @param callable $fn Колбэк описания таблицы (аргументом передаётся Schema\Table)
     */
    public function createTable(string $name, callable $fn): void
    {
        $table = new Table($name);
        $fn($table);
        $table->addTimestamps();

        $this->awaitingCreate[] = $table;
    }

    /**
     * Удаляет таблицу
     *
     * @throws \Exception
     */
    public function dropTable(string $name, bool $checkIfExists = false): void
    {
        if ($checkIfExists && !$this->hasTable($name)) {
            throw new \Exception('Table ' . $name . ' does not exist');
        }

        $this->awaitingDelete[] = $this->tables[$name] ?? $this->sessionCreated[$name];
    }

    /**
     * Записывает начальные данные после создания таблиц миграции (при commit), например записи новой таблицы:
     * $s->createTable('menu', ...); $s->seed(fn () => Menu::bulkInsert([...]));
     * Исключение в колбэке или возврат false проваливает commit, миграция откатывается вместе с её таблицами.
     */
    public function seed(callable $fn): void
    {
        $this->awaitingSeed[] = $fn;
    }

    public function table(string $name, callable $fn): void
    {
        if (!$this->hasTable($name)) {
            $this->createTable($name, $fn);
        } else {
            $fn($this->tables[$name]);
            $this->awaitingCreate[] = $this->tables[$name];
            $this->awaitingAlter[] = $name;
        }
    }

    // ------------ ВЫПОЛНЕНИЕ ------------ //

    /**
     * Фиксирует изменения
     *
     * @throws \Exception
     */
    public function commit(): bool
    {
        return $this->commitDeletion() && $this->commitCreation() && $this->commitSeed();
    }

    /**
     * Откатывает созданные таблицы
     *
     * @throws \Exception
     */
    public function rollback(): bool
    {
        foreach ($this->sessionCreated as $table) {
            $this->dropTable($table->getName());
        }

        return $this->commitDeletion();
    }

    protected function commitDeletion(): bool
    {
        // удаляем таблицы, отката нет
        foreach ($this->awaitingDelete as $table) {
            $status = !!DB::query('DROP TABLE IF EXISTS `' . $table->getName() . '`');
            if (!$status) {
                return false;
            }
        }

        // очищаем пул
        $this->awaitingDelete = [];
        return true;
    }

    protected function commitSeed(): bool
    {
        $seeds = $this->awaitingSeed;
        $this->awaitingSeed = [];
        foreach ($seeds as $fn) {
            try {
                // false — провал, например ModelBase::bulkInsert(), переданного как fn () => Model::bulkInsert([...])
                if ($fn() === false) {
                    Log::critical('Failed to write the migration data: {error}', ['error' => DB::error()]);
                    return false;
                }
            } catch (\Throwable $e) {
                Log::critical('Failed to write the migration data: {error}', ['error' => $e->getMessage()]);
                return false;
            }
        }

        return true;
    }

    /**
     * Фиксирует создание таблиц
     *
     * @throws \Exception
     */
    protected function commitCreation(): bool
    {
        foreach ($this->awaitingCreate as $table) {
            // пробуем создать таблицу
            $status = !!DB::query($table->toString());
            if (!$status) {
                return false;
            }

            // если всё прошло гладко, проверяем, не была ли таблица уже создана
            if (!in_array($table->getName(), $this->awaitingAlter)) {
                $params = $table->getParams();
                if (!$params->ifNotExists || $params->ifNotExists && !$this->hasTable($table->getName())) {
                    $this->sessionCreated[$table->getName()] = $table;
                }
            }
        }

        // очищаем пулы
        $this->awaitingCreate = [];
        $this->awaitingAlter = [];
        return true;
    }
}

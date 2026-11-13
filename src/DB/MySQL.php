<?php

namespace Simflex\Core\DB;

use Simflex\Core\System\Location;
use DebugBar\DataCollector\PDO\TraceablePDO;
use PDO;
use PDOStatement;
use Simflex\Core\System\Container;

/**
 * Класс MySQL
 *
 * @package Simflex\Core\DB\DB
 */
class MySQL implements Adapter
{
    private PDO $db;
    private PDOStatement $lastQuery;

    public function connect(): bool
    {
        $cfg = Container::getConfig();
        $host = $cfg->db['host'];
        $database = $cfg->db['name'];
        $charset = $cfg->db['charset'] ?? 'utf8mb4';
        $collate = $cfg->db['collate'] ?? 'utf8mb4_general_ci';
        $this->db = new PDO("mysql:host=$host;dbname=$database;charset=$charset", $cfg->db['user'], $cfg->db['password'], [
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE $collate",
        ]);

        if (Container::getLocation() !== Location::Cli && $cfg->devMode) {
            $this->db = new TraceablePDO($this->db);
            Container::get('debugbar')->addCollector(new \DebugBar\DataCollector\PDO\PDOCollector($this->db));
        }

        $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // Часовой пояс сессии — как у PHP (TIMEZONE сайта), а не системный пояс сервера MySQL:
        // NOW(), CURRENT_TIMESTAMP и колонки TIMESTAMP совпадают со временем из date()
        $this->db->exec("SET time_zone = '" . date('P') . "'");
        return true;
    }

    public function query(string $q, array $params = []): PDOStatement|false
    {
        $_ENV['lastq'] = $q;

        $query = $this->db->prepare($q, [PDO::ATTR_CURSOR => PDO::CURSOR_SCROLL]);
        $this->lastQuery = $query;

        return $query->execute($params) ? $query : false;
    }

    public function fetch(mixed $result): array|false|null
    {
        if (!$result) {
            return null;
        } else {
            /** @var PDOStatement $result */
            return $result->fetch(PDO::FETCH_ASSOC);
        }
    }

    public function seek(&$result, int $index): bool
    {
        if (!$result) {
            return false;
        } else {
            /** @var PDOStatement $result */
            $result->fetch(PDO::FETCH_ASSOC, PDO::FETCH_ORI_ABS, max($index - 1, 0));
            return true;
        }
    }

    /**
     * @param bool|PDOStatement $result
     */
    public function result(mixed $result, int|string $field = ''): mixed
    {
        if (!$result) {
            return false;
        } else {
            /** @var PDOStatement $result */
            if (is_int($field)) {
                $r = $result->fetch(PDO::FETCH_NUM);
                return $r && isset($r[$field]) ? $r[$field] : false;
            } else {
                $r = $result->fetch(PDO::FETCH_ASSOC);
                return $field ? ($r && isset($r[$field]) ? $r[$field] : false) : $r;
            }
        }
    }

    public function assoc(mixed $result, bool|string $f1, bool|string $f2): bool|array
    {
        if (!$result) {
            return false;
        } else {
            $rows = [];
            if ($f1) {
                while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
                    if ($f2 === false) {
                        $rows[$row[$f1]] = $row;
                    } elseif ($f2) {
                        $rows[$row[$f1]][$row[$f2]] = $row;
                    } else {
                        $rows[$row[$f1]][] = $row;
                    }
                }
            } else {
                $rows = $result->fetchAll(PDO::FETCH_ASSOC);
            }
            return $rows;
        }
    }

    public function insertId(): string
    {
        return $this->db->lastInsertId();
    }

    public function errno(): int
    {
        return isset($this->lastQuery) ? ($this->lastQuery->errorInfo()[1] ?? 0) : 0;
    }

    public function error(): ?string
    {
        return isset($this->lastQuery) ? $this->lastQuery->errorInfo()[2] : null;
    }

    public function errorCode(): ?string
    {
        return isset($this->lastQuery) ? $this->db->errorCode() : null;
    }

    public function errorPrepared(): string
    {
        $errorList = [
            1451 => 'Нельзя удалить запись - имеются связанные записи',
        ];

        $errNo = $this->errno();
        if ($errNo > 0) {
            $message = "Ошибка. Код: $errNo. ";
            $message .= $errorList[$errNo] ?? $this->error();

            return $message;
        } else {
            return '';
        }
    }

    public function escape(string $str): string
    {
        return substr($this->db->quote($str), 1, -1);
    }

    public function affectedRows(): int
    {
        return isset($this->lastQuery) ? $this->lastQuery->rowCount() : 0;
    }

    public function beginTransaction(): void
    {
        $this->db->beginTransaction();
    }

    public function inTransaction(): bool
    {
        return $this->db->inTransaction();
    }

    public function commitTransaction(): void
    {
        $this->db->commit();
    }

    public function rollbackTransaction(): void
    {
        $this->db->rollBack();
    }
}

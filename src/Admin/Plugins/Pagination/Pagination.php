<?php

namespace Simflex\Core\Admin\Plugins\Pagination;

use Simflex\Core\Http\View;

/**
 * Страницы списка: ссылки на страницы и LIMIT текущей
 */
class Pagination
{
    private int $p = 0;
    private int $pOn = 0;
    private int $pCount = 0;
    private int $count = 0;
    private string $link = '?p={p}';
    private bool $pOnShow = false;

    public function __construct($p, $pOn, $count, $link = '?p={p}', $pOnShow = false)
    {
        $this->p = abs($p);
        $this->pOn = abs($pOn);
        $this->count = abs($count);
        $this->pCount = (int) ceil($count / $this->pOn);
        if ($this->p + 1 > $this->pCount) {
            $this->pCount++;
        }
        $this->link = (string)$link;
        $this->pOnShow = (bool)$pOnShow;
    }

    /**
     * LIMIT записей текущей страницы: 'offset, count'
     */
    public function limit(): string
    {
        return $this->p * $this->pOn . ', ' . $this->pOn;
    }

    /**
     * Подвал списка: сведения о показанных записях и страницы; одна страница — только сведения
     */
    public function content(): string
    {
        if ($this->count === 0) {
            return '';
        }

        return View::render(__DIR__ . '/tpl/control.tpl', [], $this);
    }
}

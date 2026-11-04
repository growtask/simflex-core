<?php

/**
 * Подвал списка (компоненты макета table-footer): «Показано 1–20 из 50», страницы (nav/pagination) и переход
 * на страницу. Номер страницы в адресе — ?p= с нуля
 * @var \Simflex\Core\Admin\Plugins\Pagination\Pagination $this
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\Common\Pagination\Layout as PaginationLayout;
use Simflex\Core\Layout\Components\Common\Pagination\PaginationTheme;

$request = \Simflex\Core\System\Container::getRequest();
$from = $this->p * $this->pOn + 1;
$to = min($this->count, $this->p * $this->pOn + $this->pOn);
// {page} — подставит компонент; в buildQuery плейсхолдер экранировался бы
$urlPattern = Page::get()->getPath() . '?' . str_replace('PAGE_NUMBER', '{page}', $request->buildQuery(['p' => 'PAGE_NUMBER']));
?>
<div class="table-footer">
    <p class="table-footer__info">Показано <?= $from ?>–<?= $to ?> из <?= $this->count ?></p>
    <?php if ($this->pCount > 1): ?>
    <?= PaginationLayout::drawPagination(
        $this->p + 1,
        $this->pCount,
        $urlPattern,
        theme: PaginationTheme::from(Page::get()->getTheme()),
        className: 'table-footer__pagination',
        urlPageOffset: -1,
    ) ?>
    <?php endif; ?>
</div>

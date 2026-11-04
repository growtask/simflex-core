<?php
/**
 * Ячейка списка: текст или число
 * @var string $name
 * @var bool $isId
 * @var string $kind text или num
 * @var string $value
 */
?>
<span class="td-value td-value_<?= $kind ?><?= $isId ? ' td-value_id' : '' ?> table__row-<?= $name ?>"><?= $value ?></span>

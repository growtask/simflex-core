<?php

namespace Simflex\Core\Admin;

/**
 * Слот верхней части админки: HTML расширения в заголовке страницы (`page-head`, десктоп) и в верхней панели
 * планшета и телефона (`topbar`). Класс объявляется в `ExtensionConfig::$adminHeadSlots`
 */
interface HeadSlot
{
    /**
     * HTML выводится без экранирования: данные внутри слота (названия, значения из БД или запроса) слот экранирует
     * сам (`htmlspecialchars`)
     *
     * @return string готовый HTML; пустая строка - ничего не выводить
     */
    public function draw(): string;
}

<?php

namespace Simflex\Core\Admin;

/**
 * Источник уведомлений админки. Класс объявляется в `ExtensionConfig::$adminNoticeSources`; создаётся без аргументов
 * один раз за запрос страницы админки
 */
interface NoticeSource
{
    /**
     * Источник сам решает, кому показывать уведомления (проверяет пользователя и его привилегии)
     *
     * @return list<Notice> текущие уведомления; пустой список - показывать нечего
     */
    public function getNotices(): array;
}

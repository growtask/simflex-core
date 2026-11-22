<?php

namespace Simflex\Core\Admin;

/**
 * Постоянное уведомление админки: выводится под заголовком страницы, пока источник (NoticeSource) его отдаёт.
 * Пользователь может скрыть его для себя до конца сессии
 */
final readonly class Notice
{
    /**
     * @param string $key Постоянный ключ уведомления (например, `hosting_db_backup`): по нему скрывается уведомление
     * @param string $title Заголовок (экранируется)
     * @param string $text Текст под заголовком (экранируется)
     * @param string $linkUrl Адрес кнопки-ссылки; пусто - кнопки нет
     * @param string $linkText Текст кнопки-ссылки
     */
    public function __construct(
        public string $key,
        public NoticeLevel $level,
        public string $title,
        public string $text = '',
        public string $linkUrl = '',
        public string $linkText = '',
    ) {
    }

    /**
     * Отпечаток содержимого: скрытое уведомление, у которого он изменился (например, добавилась проблема),
     * показывается снова
     */
    public function getFingerprint(): string
    {
        return md5(implode("\0", [$this->level->value, $this->title, $this->text, $this->linkUrl, $this->linkText]));
    }
}

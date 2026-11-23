<?php

namespace Simflex\Core\Admin;

use Simflex\Core\Logger\Log;
use Simflex\Core\System\ExtensionConfig;
use Simflex\Core\System\Session;

/**
 * Уведомления админки: сбор у источников (`ExtensionConfig::$adminNoticeSources`) и скрытие пользователем.
 * Скрытое уведомление запоминается в сессии (ключ => отпечаток содержимого): в новой сессии оно видно снова,
 * как и уведомление, содержимое которого изменилось
 */
final class Notices
{
    public const SESSION_KEY = 'admin_dismissed_notices';

    /**
     * Уведомления всех источников, кроме скрытых пользователем. Ошибка источника не ломает страницу: пишется в лог
     *
     * @return list<Notice>
     */
    public static function getVisible(): array
    {
        $dismissed = null;
        $visible = [];
        foreach (self::collect() as $notice) {
            $dismissed ??= self::getDismissed();
            if (($dismissed[$notice->key] ?? null) !== $notice->getFingerprint()) {
                $visible[] = $notice;
            }
        }

        return $visible;
    }

    /**
     * Скрыть уведомление для текущей сессии. Скрывается только то, что источники отдают сейчас
     *
     * @return bool false, если уведомления с таким ключом нет
     */
    public static function dismiss(string $key): bool
    {
        foreach (self::collect() as $notice) {
            if ($notice->key === $key) {
                $dismissed = self::getDismissed();
                $dismissed[$key] = $notice->getFingerprint();
                Session::set(self::SESSION_KEY, $dismissed);
                return true;
            }
        }

        return false;
    }

    /**
     * @return list<Notice> с уникальными ключами: при совпадении остаётся первое
     */
    private static function collect(): array
    {
        $notices = [];
        foreach (ExtensionConfig::getAll() as $config) {
            foreach ($config->getAdminNoticeSources() as $class) {
                try {
                    /** @var NoticeSource $source */
                    $source = new $class();
                    foreach ($source->getNotices() as $notice) {
                        $notices[$notice->key] ??= $notice;
                    }
                } catch (\Throwable $exception) {
                    Log::error('Источник уведомлений админки {source}: {error}', [
                        'source' => $class,
                        'error' => $exception->getMessage(),
                    ]);
                }
            }
        }

        return array_values($notices);
    }

    /**
     * @return array<string, string> ключ уведомления => отпечаток скрытого содержимого
     */
    private static function getDismissed(): array
    {
        $dismissed = Session::get(self::SESSION_KEY);

        return is_array($dismissed) ? $dismissed : [];
    }
}

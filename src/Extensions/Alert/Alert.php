<?php

namespace Simflex\Core\Extensions\Alert;

use Simflex\Core\Http\Assets;
use Simflex\Core\Layout\Components\UI\Core\Notice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Core\Notice\NoticeStyle;
use Simflex\Core\Layout\Components\UI\Core\Notice\NoticeTheme;
use Simflex\Core\Layout\Components\UI\Core\Toast\Layout as Toast;
use Simflex\Core\Layout\Components\UI\Core\Toast\ToastStyle;
use Simflex\Core\Http\PageAssets;
use Simflex\Core\Http\View;
use Simflex\Core\System\Container;
use Simflex\Core\System\Location;
use Simflex\Core\System\Session;

/**
 * Сообщения пользователю (ошибка, успех, предупреждение, информация), которые переживают редирект: хранятся
 * в сессии до вывода. Сообщения сайта и админки хранятся отдельно: на сайте их выводит getHTML() (alert.tpl рядом
 * с классом), в админке - макет (drawAdminMessages(): успех - тост, ошибка, предупреждение и информация -
 * уведомления Notice в правом верхнем углу), getHTML() в админке ничего не выводит.
 *
 * $page - необязательный идентификатор группы сообщений (например, "profile"): сообщения группы выводятся
 * только getHTML() с тем же идентификатором
 */
class Alert
{
    /** Разделы сообщений в порядке вывода */
    protected const array SECTIONS = ['error', 'success', 'warning', 'info', 'text'];

    /** @var array<string, array<string, array<string, string>>> группа => раздел => сообщения */
    protected static array $s;
    protected static bool $isInited = false;

    private function __construct()
    {
    }

    public static function init(): void
    {
        if (!self::$isInited) {
            self::$s = Session::get(static::getSessionKey()) ?? [];
            self::$isInited = true;
            if (!static::isAdmin()) {
                PageAssets::css(Assets::publish(__DIR__ . '/alert.css'));
            }
        }
    }

    /**
     * Добавить сообщение об ошибке
     * @param array|string $mixed Сообщение или список сообщений
     * @param string|false $goto Адрес редиректа: header("location: $goto") и exit
     * @param string $page Группа сообщений, например "profile"
     */
    public static function error(array|string $mixed, string|false $goto = false, string $page = ''): void
    {
        static::add('error', $mixed, $goto, $page);
    }

    /**
     * Добавить предупреждение
     * @see error()
     */
    public static function warning(array|string $mixed, string|false $goto = false, string $page = ''): void
    {
        static::add('warning', $mixed, $goto, $page);
    }

    /**
     * Добавить сообщение об успешной операции
     * @see error()
     */
    public static function success(array|string $mixed, string|false $goto = false, string $page = ''): void
    {
        static::add('success', $mixed, $goto, $page);
    }

    /**
     * Добавить информационное сообщение
     * @see error()
     */
    public static function info(array|string $mixed, string|false $goto = false, string $page = ''): void
    {
        static::add('info', $mixed, $goto, $page);
    }

    /**
     * Добавить текст без оформления сообщения
     * @see error()
     */
    public static function text(array|string $mixed, string|false $goto = false, string $page = ''): void
    {
        static::add('text', $mixed, $goto, $page);
    }

    /**
     * HTML накопившихся сообщений группы; выведенные сообщения удаляются
     * @param string $page Группа сообщений, например "profile"
     */
    public static function getHTML(string $page = ''): string
    {
        self::init();
        // в админке сообщения выводит макет (drawAdminMessages())
        if (static::isAdmin()) {
            return '';
        }
        $html = '';
        foreach (static::SECTIONS as $section) {
            $html .= static::renderSection($page, $section);
        }
        static::save();

        return $html . "\n" . '<div class="alert-buffer"' . ($page ? ' id="alert-buffer-' . $page . '"' : '') . '></div>' . "\n";
    }

    /**
     * Есть ли сообщения в группе
     */
    public static function has(string $page = ''): bool
    {
        self::init();
        foreach (static::SECTIONS as $section) {
            if (!empty(self::$s[$page][$section])) {
                return true;
            }
        }

        return false;
    }

    /**
     * Есть ли ошибки в группе
     */
    public static function hasErrors(string $page = ''): bool
    {
        self::init();
        return !empty(self::$s[$page]['error']);
    }

    protected static function add(string $section, array|string $mixed, string|false $goto, string $page): void
    {
        self::init();
        if (is_array($mixed)) {
            self::$s[$page][$section] = array_merge(self::$s[$page][$section] ?? [], $mixed);
        } else {
            self::$s[$page][$section][md5($mixed)] = $mixed;
        }
        static::save();

        if ($goto) {
            header('location: ' . $goto);
            exit;
        }
    }

    protected static function renderSection(string $page, string $section): string
    {
        $messages = self::$s[$page][$section] ?? [];
        if (!$messages) {
            return '';
        }
        self::$s[$page][$section] = [];

        $txt = count($messages) === 1
            ? (string)reset($messages)
            : '<ul><li>' . implode('</li><li>', $messages) . '</li></ul>';
        if ($section === 'text') {
            return $txt;
        }

        return View::render(__DIR__ . '/alert.tpl', ['section' => $section, 'txt' => $txt]);
    }

    /**
     * Сообщения админки для макета: успех - тосты (стопка тостов), ошибка, предупреждение, информация и текст -
     * уведомления Notice с крестиком. Выведенные сообщения удаляются. Текст сообщений выводится без разметки
     * @param string $theme Тема админки (Admin\Page::getTheme())
     * @return array{toasts: string, notices: string}
     */
    public static function drawAdminMessages(string $theme): array
    {
        self::init();
        $toasts = $notices = '';
        foreach (static::SECTIONS as $section) {
            foreach (self::$s[''][$section] ?? [] as $message) {
                $text = trim(html_entity_decode(strip_tags((string)$message)));
                if ($section === 'success') {
                    $toasts .= Toast::drawToast($text, ToastStyle::Success, icon: true, timer: true);
                    continue;
                }
                [$style, $title] = match ($section) {
                    'error' => [NoticeStyle::Error, 'Ошибка'],
                    'warning' => [NoticeStyle::Alert, 'Внимание'],
                    default => [NoticeStyle::Info, 'Информация'],
                };
                $notices .= Notice::drawNotice($title, $text, $style, NoticeTheme::from($theme), close: true);
            }
            self::$s[''][$section] = [];
        }
        static::save();

        return ['toasts' => $toasts, 'notices' => $notices];
    }

    protected static function save(): void
    {
        Session::set(static::getSessionKey(), self::$s);
    }

    protected static function isAdmin(): bool
    {
        return Container::getLocation() === Location::Admin;
    }

    /**
     * Ключ сессии: сообщения админки и сайта не смешиваются
     */
    protected static function getSessionKey(): string
    {
        return static::isAdmin() ? 'admin.alerts' : 'plug_alert';
    }
}

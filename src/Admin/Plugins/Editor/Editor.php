<?php

namespace Simflex\Core\Admin\Plugins\Editor;

use Simflex\Core\Admin\Page;
use Simflex\Core\Http\Assets;
use Simflex\Core\Http\Csrf;
use Simflex\Core\Http\Request;
use Simflex\Core\System\Container;
use Simflex\Core\System\FileUsage;
use Simflex\Core\System\Privilege;
use Simflex\Texted\Config;

/**
 * Визуальный редактор полей админки — texted (пакет simflex/texted): textarea превращается в блочный редактор,
 * HTML поля перед сохранением очищает сервер по набору блоков поля. Файлы и медиа выбираются в файловом
 * менеджере админки (window.fileManager), тема интерфейса следует за темой админки.
 *
 * Скрипт админки — text-editor.js рядом с этим файлом: компонент data-sf="text-editor" запускает редактор
 * на textarea с настройками из data-sf-text-editor (getInitOptions()).
 */
class Editor
{
    /** Набор блоков «все блоки» (FieldDefinition::$editorFull) */
    public const PRESET_FULL = 'full';
    /** Набор блоков «текст, списки, ссылки» (FieldDefinition::$editorMini) */
    public const PRESET_MINI = 'mini';
    /** Только просмотр (поле readonly) */
    public const PRESET_READONLY = 'readonly';

    /** Папка файлов сайта в public/ и её адрес — та же, что у файлового менеджера */
    public const FILES_DIR = 'uf';
    public const FILES_URL = '/uf';

    /** Путь загрузки файлов редактора относительно корня админки (getUploadUrl()) */
    public const UPLOAD_PATH = 'text-editor-upload';

    protected static ?Config $config = null;

    /**
     * Подключает стили и скрипт редактора к странице. Форма, в которую поле с редактором приходит ajax-ответом
     * (параметры модуля), подключает его заранее: скрипты, добавленные в ответе, страница не загружает
     */
    public static function addScript(): void
    {
        $page = Page::get();
        $distUrl = Assets::publish(static::getDistPath());
        $page->css($distUrl . '/ted.css');
        $page->js($distUrl . '/ted.js', 10);
        $page->coreJsModule('/Plugins/Editor/text-editor.js');
    }

    /**
     * Каталог пакета simflex/texted (dist — статика редактора, src — сервер)
     */
    public static function getPackagePath(): string
    {
        return Container::getPaths()->getRoot('vendor/simflex/texted');
    }

    /**
     * Статика редактора — папка dist пакета: ted.js, ted.css, content.js, шрифты, плитки и значки (стили ссылаются
     * на них относительно). Публикуется только она: исходники, тесты и PHP пакета в public/ не попадают
     */
    public static function getDistPath(): string
    {
        return static::getPackagePath() . '/dist';
    }

    /**
     * Адрес загрузки файлов редактора с компьютера (обрабатывает respondToUpload())
     */
    public static function getUploadUrl(): string
    {
        return Page::url(static::UPLOAD_PATH);
    }

    /**
     * Загрузка файлов редактора с компьютера, картинка по ссылке (action=fetch) и удаление после сохранения
     * (action=delete) — ответ JSON. Только пользователю админки с CSRF-токеном сессии; набор блоков поля — параметр
     * preset адреса (только просмотр — 403). Файлы пишутся в public/uf/<вид>/<путь документа>/, где путь —
     * pagePath запроса (FieldText::getEditorOptions(): /<таблица>/<запись>). Файл, адрес которого есть в другой
     * записи базы (FileUsage), не удаляется
     */
    public static function respondToUpload(): void
    {
        $request = Container::getRequest() ?? new Request();
        $user = Container::getUser();
        if (!$user || !$user->ican(Privilege::ADMIN) || !Csrf::isValid($request)) {
            static::respondWithError(403, 'Нет доступа');
            return;
        }
        $preset = (string)$request->get('preset', self::PRESET_FULL);
        try {
            static::getConfig()->getPreset($preset);
        } catch (\InvalidArgumentException) {
            static::respondWithError(400, 'Неизвестный набор блоков');
            return;
        }
        $pagePath = (string)$request->post('pagePath', '/');
        $usage = new FileUsage(Container::getConfig()->fileUsageIgnoreTables);
        static::getConfig()->respondToUpload(
            $pagePath,
            $preset,
            true,
            fn(string $url): bool => $usage->find((string)parse_url($url, PHP_URL_PATH)) !== [],
        );
    }

    /**
     * Ответ JSON с ошибкой в формате texted ({error})
     */
    protected static function respondWithError(int $code, string $message): void
    {
        http_response_code($code);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        echo json_encode(['error' => $message], JSON_UNESCAPED_UNICODE);
    }

    /**
     * Настройки texted на сервере: папка файлов public/uf и адрес /uf, остальное — по умолчанию пакета
     */
    public static function getConfig(): Config
    {
        return static::$config ??= Config::fromArray([
            'files' => [
                'dir' => Container::getPaths()->getPublic(static::FILES_DIR),
                'url' => static::FILES_URL,
            ],
        ]);
    }

    /**
     * Настройки Ted.init для поля (JSON в data-sf-text-editor): настройки сервера для браузера (адрес папки
     * файлов, лимиты, набор, право на правку), ключ черновика и загрузка файлов с компьютера: uploadUrl (адрес
     * respondToUpload() с набором поля — из него text-editor.js делает Ted.createUpload) и mediaPageUrl (путь
     * документа: подпапка файлов в public/uf/<вид>/)
     *
     * @param string $preset Набор блоков поля: self::PRESET_*
     * @param string $autosaveKey Ключ черновика в браузере (своя запись — свой ключ), пусто — без черновика
     * @param string $mediaPath Путь документа для файлов (/<таблица>/<запись>), пусто — без загрузки с компьютера
     * @return array<string, mixed>
     */
    public static function getInitOptions(
        string $preset,
        bool $canEdit = true,
        string $autosaveKey = '',
        string $mediaPath = ''
    ): array {
        $options = ['server' => static::getConfig()->getClient($preset, $canEdit)];
        if ($autosaveKey !== '') {
            $options['autosave'] = $autosaveKey;
        }
        if ($mediaPath !== '' && $canEdit && $preset !== self::PRESET_READONLY) {
            $options['uploadUrl'] = static::getUploadUrl() . '?preset=' . rawurlencode($preset);
            $options['mediaPageUrl'] = $mediaPath;
        }

        return $options;
    }

    /**
     * HTML поля, очищенный по набору блоков: запрещённые теги, атрибуты и адреса убираются, блоки вне набора
     * становятся текстом. Браузеру не доверяем — вызывается при сохранении
     *
     * @param string $preset Набор блоков поля: self::PRESET_*
     */
    public static function clean(string $html, string $preset): string
    {
        return static::getConfig()->clean($html, $preset);
    }
}

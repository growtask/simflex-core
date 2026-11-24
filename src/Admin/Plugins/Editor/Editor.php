<?php

namespace Simflex\Core\Admin\Plugins\Editor;

use Simflex\Core\Admin\Page;
use Simflex\Core\Http\Assets;
use Simflex\Core\System\Container;
use TedConfig;

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

    protected static ?TedConfig $config = null;

    /**
     * Подключает стили и скрипт редактора к странице. Форма, в которую поле с редактором приходит ajax-ответом
     * (параметры модуля), подключает его заранее: скрипты, добавленные в ответе, страница не загружает
     */
    public static function addScript(): void
    {
        $page = Page::get();
        $packageUrl = Assets::publish(static::getPackagePath());
        $page->css($packageUrl . '/dist/ted.css');
        $page->js($packageUrl . '/dist/ted.js', 10);
        $page->coreJsModule('/Plugins/Editor/text-editor.js');
    }

    /**
     * Каталог пакета simflex/texted (dist, fonts, tiles — статика редактора, php — сервер)
     */
    public static function getPackagePath(): string
    {
        return Container::getPaths()->getRoot('vendor/simflex/texted');
    }

    /**
     * Настройки texted на сервере: папка файлов public/uf и адрес /uf, остальное — по умолчанию пакета
     */
    public static function getConfig(): TedConfig
    {
        return static::$config ??= TedConfig::fromArray([
            'files' => [
                'dir' => Container::getPaths()->getPublic(static::FILES_DIR),
                'url' => static::FILES_URL,
            ],
        ]);
    }

    /**
     * Настройки Ted.init для поля (JSON в data-sf-text-editor): настройки сервера для браузера (адрес папки
     * файлов, лимиты, набор, право на правку) и ключ черновика
     *
     * @param string $preset Набор блоков поля: self::PRESET_*
     * @param string $autosaveKey Ключ черновика в браузере (своя запись — свой ключ), пусто — без черновика
     * @return array<string, mixed>
     */
    public static function getInitOptions(string $preset, bool $canEdit = true, string $autosaveKey = ''): array
    {
        $options = ['server' => static::getConfig()->client($preset, $canEdit)];
        if ($autosaveKey !== '') {
            $options['autosave'] = $autosaveKey;
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

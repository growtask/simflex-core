<?php

namespace Simflex\Core\Layout;

use Simflex\Core\Http\View;
use Simflex\Core\System\Container;

/**
 * Витрина компонентов Layout: находит компоненты с демо и рисует демо в темах.
 *
 * Файл витрины лежит в папке компонента рядом с Layout.php и layout.tpl:
 * - demo.tpl - все варианты компонента (стили, размеры, состояния) в теме $theme ('light' или 'dark').
 * Компоненты ищутся в Layout/Components ядра и в Layout/Components сайта. Компонент сайта с тем же путём
 * (UI/Badge) переопределяет компонент ядра: его demo.tpl заменяет ядровый. Если у сайта
 * его нет, берётся файл ядра, но он рисует класс ядра: чтобы показать сайтовую версию, добавьте в сайт свой demo.tpl.
 * Витрина (страница) живёт в шаблоне сайта и работает только в режиме разработки.
 */
class LayoutShowcase
{
    /** Имя файла демо в папке компонента */
    public const DEMO_FILE = 'demo.tpl';

    /** Разделы витрины: папка в Layout/Components => название */
    public const SECTIONS = ['UI' => 'UI-компоненты', 'Parts' => 'Части страниц'];

    /** Названия групп (папок блоков), которые отличаются от имени папки */
    public const GROUP_TITLES = ['Other' => 'Прочее (нет в Figma)'];

    /** Темы витрины: значение темы компонентов => название */
    public const THEMES = ['light' => 'Светлая', 'dark' => 'Тёмная'];

    /** Источник файла: ядро */
    public const SOURCE_CORE = 'core';

    /** Источник файла: сайт */
    public const SOURCE_SITE = 'site';

    /**
     * Находит компоненты раздела, у которых есть демо (в ядре или в сайте)
     *
     * @param string|null $section Раздел (ключ SECTIONS); null - все разделы
     * @return array<string, array{
     *     key: string, section: string, group: string, name: string,
     *     inCore: bool, inSite: bool, overrides: bool,
     *     demo: string|null, demoSource: string|null
     * }> Ключ - путь папки компонента от Layout/Components (UI/Badge), в порядке страницы UI в Figma (figma-docs.php), затем по алфавиту
     */
    public static function getComponents(?string $section = null): array
    {
        $core = static::scan(static::coreRoot());
        $site = static::scan(static::siteRoot());
        $components = [];
        foreach (array_keys($core + $site) as $key) {
            $sectionKey = strstr($key, '/', true);
            if (!isset(static::SECTIONS[$sectionKey]) || ($section !== null && $section !== $sectionKey)) {
                continue;
            }
            $demo = static::pick($key, static::DEMO_FILE, isset($core[$key]), isset($site[$key]));
            if ($demo === null) {
                continue;
            }
            $group = dirname($key) === $sectionKey ? '' : substr(dirname($key), strlen($sectionKey) + 1);
            $components[$key] = [
                'key' => $key,
                'section' => $sectionKey,
                'group' => $group,
                'name' => basename($key),
                'inCore' => isset($core[$key]),
                'inSite' => isset($site[$key]),
                'overrides' => isset($core[$key]) && isset($site[$key]),
                'demo' => $demo[0],
                'demoSource' => $demo[1],
            ];
        }
        // порядок как на странице UI в Figma (его задаёт figma-docs.php), остальные - по алфавиту в конце
        $figmaOrder = array_flip(array_keys(require __DIR__ . '/figma-docs.php'));
        uksort($components, static fn(string $left, string $right): int => [
            $figmaOrder[$left] ?? PHP_INT_MAX,
            strtolower($left),
        ] <=> [$figmaOrder[$right] ?? PHP_INT_MAX, strtolower($right)]);

        return $components;
    }

    /**
     * @param string $key Ключ компонента из getComponents()
     * @return array<string, mixed>|null Описание компонента или null, если такого нет
     */
    public static function getComponent(string $key): ?array
    {
        return static::getComponents()[$key] ?? null;
    }

    /**
     * Рисует демо компонента в теме
     *
     * @param string $key Ключ компонента
     * @param string $theme Тема: ключ THEMES
     * @return string HTML демо; пустая строка, если компонента, демо или темы нет; при ошибке - её описание
     */
    public static function renderDemo(string $key, string $theme): string
    {
        return static::renderFile($key, 'demo', $theme);
    }

    /**
     * Файлы папки компонента в ядре и в сайте
     *
     * @param string $key Ключ компонента
     * @return array<string, array{name: string, core: string|null, site: string|null, status: string}>
     *         Статус: core - только ядро, site - добавлен сайтом, replaced - сайт заменил файл ядра
     */
    public static function getFiles(string $key): array
    {
        $core = static::listFiles(static::coreRoot() . '/' . $key);
        $site = static::listFiles(static::siteRoot() . '/' . $key);
        $names = array_unique(array_merge(array_keys($core), array_keys($site)));
        sort($names, SORT_NATURAL | SORT_FLAG_CASE);
        $files = [];
        foreach ($names as $name) {
            $files[$name] = [
                'name' => $name,
                'core' => $core[$name] ?? null,
                'site' => $site[$name] ?? null,
                'status' => match (true) {
                    isset($core[$name], $site[$name]) => 'replaced',
                    isset($site[$name]) => 'site',
                    default => 'core',
                },
            ];
        }

        return $files;
    }

    /**
     * Краткие инструкции компонента из Figma (описания наборов страницы UI)
     *
     * @param string $key Ключ компонента
     * @return list<array{set: string, what: string, why: string, how: string, limits: string}>
     *         Пустой список, если у компонента нет набора в Figma
     */
    public static function getFigmaDocs(string $key): array
    {
        return static::getAllFigmaDocs()[$key] ?? [];
    }

    /**
     * Инструкции из Figma всех компонентов
     *
     * @return array<string, list<array{set: string, what: string, why: string, how: string, limits: string}>>
     *         Ключ - компонент (UI/Badge)
     */
    public static function getAllFigmaDocs(): array
    {
        $all = [];
        foreach (require __DIR__ . '/figma-docs.php' as $key => $rows) {
            foreach ($rows as [$set, $what, $why, $how, $limits]) {
                $all[$key][] = ['set' => $set, 'what' => $what, 'why' => $why, 'how' => $how, 'limits' => $limits];
            }
        }

        return $all;
    }

    protected static function coreRoot(): string
    {
        return __DIR__ . '/Components';
    }

    protected static function siteRoot(): string
    {
        return Container::getPaths()->getRoot('Layout/Components');
    }

    /**
     * Папки компонентов разделов витрины
     *
     * @return array<string, true> Ключ - путь папки от корня компонентов
     */
    protected static function scan(string $root): array
    {
        $keys = [];
        foreach (array_keys(static::SECTIONS) as $section) {
            if (!is_dir($root . '/' . $section)) {
                continue;
            }
            $iterator = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($root . '/' . $section, \FilesystemIterator::SKIP_DOTS)
            );
            /** @var \SplFileInfo $file */
            foreach ($iterator as $file) {
                if (in_array($file->getFilename(), ['Layout.php', static::DEMO_FILE], true)) {
                    $keys[str_replace('\\', '/', substr($file->getPath(), strlen($root) + 1))] = true;
                }
            }
        }

        return $keys;
    }

    /**
     * Файл витрины компонента: сайтовый заменяет ядровый
     *
     * @return array{0: string, 1: string}|null Путь файла и его источник (SOURCE_*)
     */
    protected static function pick(string $key, string $name, bool $inCore, bool $inSite): ?array
    {
        $site = static::siteRoot() . '/' . $key . '/' . $name;
        if ($inSite && is_file($site)) {
            return [$site, static::SOURCE_SITE];
        }
        $core = static::coreRoot() . '/' . $key . '/' . $name;
        if ($inCore && is_file($core)) {
            return [$core, static::SOURCE_CORE];
        }

        return null;
    }

    /**
     * @return array<string, string> Имя файла => путь (только файлы, без вложенных папок)
     */
    protected static function listFiles(string $directory): array
    {
        $files = [];
        foreach (is_dir($directory) ? (scandir($directory) ?: []) : [] as $name) {
            if (is_file($directory . '/' . $name)) {
                $files[$name] = $directory . '/' . $name;
            }
        }

        return $files;
    }

    protected static function renderFile(string $key, string $kind, string $theme): string
    {
        $file = static::getComponent($key)[$kind] ?? null;
        if ($file === null || !isset(static::THEMES[$theme])) {
            return '';
        }
        $level = ob_get_level();
        try {
            return View::render($file, ['theme' => $theme]);
        } catch (\Throwable $exception) {
            while (ob_get_level() > $level) {
                ob_end_clean();
            }

            return '<p class="ui-showcase__error">Не удалось нарисовать (' . htmlspecialchars($kind) . '): '
                . htmlspecialchars($exception->getMessage()) . '. Если компонент переопределён в сайте, '
                . 'добавьте в его папку свой ' . htmlspecialchars($kind) . '.tpl.</p>';
        }
    }
}

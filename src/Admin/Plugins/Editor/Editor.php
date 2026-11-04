<?php

namespace Simflex\Core\Admin\Plugins\Editor;

use Simflex\Core\Admin\Page;

/**
 * Визуальный редактор TinyMCE в форме админки: скин и стили содержимого по теме админки (светлая — oxide и
 * default, тёмная — oxide-dark и dark), шрифт и цвета содержимого — значения токенов дизайн-системы
 */
class Editor
{
    public static array $inited = [];

    /**
     * Подключает скрипт TinyMCE к странице. Форма, в которую редактор приходит ajax-ответом (параметры модуля),
     * подключает его заранее: скрипты, добавленные в ответе, страница не загружает
     */
    public static function addScript(): void
    {
        $tinyMcePath = Page::webVendorPath() . '/Plugins/Editor/tinymce/tinymce.min.js';
        Page::get()->js($tinyMcePath . '" referrerpolicy="origin', 10);
    }

    /**
     * Настройки TinyMCE без selector: скин и стили содержимого по теме админки. Их же берёт редактор, который
     * запускается скриптом (строка поля-таблицы в окне, theme/js/table-editor.js)
     *
     * @return array<string, mixed>
     */
    public static function getConfig(): array
    {
        $isDark = Page::get()->getTheme() === Page::THEME_DARK;
        // токены дизайн-системы: text-icon/gray/darker (white), main/gray/darker (black), color1/main
        $contentStyle = $isDark
            ? 'body { font: 400 16px/1.5 Inter, system-ui, sans-serif; color: #FFFFFF; background: #0D0D0D; }'
            . ' a { color: #63A1F7; }'
            : 'body { font: 400 16px/1.5 Inter, system-ui, sans-serif; color: #262626; background: #FFFFFF; }'
            . ' a { color: #1975F7; }';

        return [
            'language' => 'ru',
            'skin' => $isDark ? 'oxide-dark' : 'oxide',
            'content_css' => $isDark ? 'dark' : 'default',
            'content_style' => $contentStyle,
            // адреса картинок и ссылок — от корня сайта (/uf/...), а не относительно страницы админки
            'relative_urls' => false,
            'remove_script_host' => true,
            'branding' => false,
            'promotion' => false,
            'plugins' => 'fm lists table link emoticons code media',
            'menu' => [
                'file' => ['items' => ''],
                'view' => ['items' => ''],
                'insert' => ['title' => 'Insert', 'items' => 'hr fm media'],
                'format' => ['items' => ''],
            ],
            'toolbar' => 'undo redo | blocks | bold italic strikethrough | numlist bullist table link emoticons fm | code',
        ];
    }

    /**
     * Регистрирует скрипт TinyMCE и возвращает HTML инициализации редактора (один раз на тип редактора)
     */
    public static function tinymce(string $type, string $css_class = ''): string
    {
        static::addScript();

        if (!empty(self::$inited[$type])) {
            return '';
        }
        self::$inited[$type] = true;
        $config = json_encode(
            ['selector' => '.' . $css_class] + static::getConfig(),
            JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR
        );

        return <<<HTML
<script>
tinymce.init($config);
</script>
<style>
.tox-promotion {
    display: none !important;
}
</style>
HTML;
    }
}

<?php

namespace Simflex\Core\Admin\Handlers;

use Simflex\Core\Admin\Handler;
use Simflex\Core\Admin\Page;

/**
 * Витрина компонентов админки (/admin/ui): элементы UI из Layout и локальные компоненты макета SimflexCMS
 * в светлой и тёмной теме, все иконки спрайта админки. Для сверки с Figma на 2560/1920/1366/768/414;
 * раздел есть только в режиме разработки и только с привилегией DEV (Admin\Menu)
 */
class Ui extends Handler
{
    /** Ширины макетов, на которых сверяется вёрстка */
    public const WIDTHS = [2560, 1920, 1366, 768, 414];

    /** Темы витрины: значение enum темы компонентов Layout => название */
    public const THEMES = ['light' => 'Светлая', 'dark' => 'Тёмная'];

    public function content(): string
    {
        return $this->render(__DIR__ . '/tpl/ui.tpl', ['iconIds' => static::getIconIds()]);
    }

    /**
     * @return list<string> ID иконок спрайта админки (символы icon-<ID>)
     */
    public static function getIconIds(): array
    {
        $sprite = (string)@file_get_contents(Page::vendorPath() . '/theme/img/icons.svg');
        preg_match_all('/<symbol id="icon-([^"]+)"/', $sprite, $matches);

        return $matches[1];
    }
}

<?php

namespace Simflex\Core\Admin\Modules\Menu;

use Simflex\Core\Admin\Page;
use Simflex\Core\System\ModuleBase;

/**
 * Меню админки: группы и пункты (позиция menu, выводится в theme/tpl/partial/sidebar.tpl)
 */
class Menu extends ModuleBase
{
    protected string $name = 'menu';

    public function content(): string
    {
        $page = Page::get();

        return $this->render(__DIR__ . '/tpl/menu.tpl', [
            'menu' => $page->getMenu(),
            'currentId' => (string)$page->getCurrentMenuItem('id'),
            'theme' => $page->getTheme(),
        ]);
    }
}

<?php

namespace Simflex\Core\Admin\Handlers;

use Simflex\Core\Models\AdminWidget;
use Simflex\Core\Admin\Page;
use Simflex\Core\Admin\Handler;
use Simflex\Core\System\Container;

/**
 * Страница группы меню со списком подпунктов; главная страница админки показывает ещё и виджеты.
 * Раздел пункта меню без обработчика и адреса, которого нет в меню
 */
class Group extends Handler
{
    public function content(): string
    {
        return $this->widgets() . $this->subitems();
    }

    /**
     * Подпункты группы карточками; на главной админки — группы верхнего уровня с их пунктами
     */
    protected function subitems(): string
    {
        $page = Page::get();
        $currentId = (string)($page->getCurrentMenuItem('id') ?? '');
        $menu = $page->getMenu();
        if (!isset($menu[$currentId])) {
            return '';
        }

        return $this->render(__DIR__ . '/tpl/group.tpl', [
            'menu' => $menu,
            'currentId' => $currentId,
            'theme' => $page->getTheme(),
        ]);
    }

    protected function widgets(): string
    {
        $rows = AdminWidget::findAdv()->asArray()->where(['active' => 1])->orderBy('npp, widget_id')->all();
        $widgets = [];
        foreach ($rows as $row) {
            if (!$row['privilege'] || Container::getUser()?->ican($row['privilege'])) {
                $class = $row['class'];
                $widgets[] = new $class($row)->execute();
            }
        }

        return $widgets ? $this->render(__DIR__ . '/tpl/widgets.tpl', ['widgets' => $widgets]) : '';
    }
}

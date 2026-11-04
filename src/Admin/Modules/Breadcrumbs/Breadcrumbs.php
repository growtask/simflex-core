<?php

namespace Simflex\Core\Admin\Modules\Breadcrumbs;

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\Common\Breadcrumbs\BreadcrumbsTheme;
use Simflex\Core\Layout\Components\Common\Breadcrumbs\Layout as BreadcrumbsLayout;
use Simflex\Core\System\ModuleBase;

/**
 * Хлебные крошки текущего раздела (позиция breadcrumbs, выводится в page-head): путь пункта меню
 */
class Breadcrumbs extends ModuleBase
{
    protected string $name = 'breadcrumbs';

    public function content(): string
    {
        return static::draw(Page::get()->getCrumbs());
    }

    /**
     * @param list<array{name: string, link?: string}> $crumbs Пункты от корня до текущей страницы
     */
    public static function draw(array $crumbs): string
    {
        $page = Page::get();

        return BreadcrumbsLayout::drawBreadcrumbs(
            $crumbs,
            homeLink: Page::url(''),
            homeLabel: 'Главная админки',
            theme: BreadcrumbsTheme::from($page->getTheme()),
            className: 'page-head__breadcrumbs',
        );
    }
}

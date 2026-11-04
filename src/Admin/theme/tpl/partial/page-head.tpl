<?php

/**
 * Заголовок страницы (компонент макета page-head): хлебные крошки (на телефоне — «Назад»), название,
 * «На сайт» и одна главная кнопка. Выводится Admin\Page::drawPageHead()
 * @var \Simflex\Core\Admin\Page $page
 * @var string $title
 * @var string $action HTML главной кнопки
 * @var list<array{name: string, link?: string}> $crumbs Путь страницы (для «Назад»)
 * @var string $crumbsHtml HTML хлебных крошек
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;

$theme = $page->getTheme();
// «Назад» на телефоне — на предпоследний пункт крошек (родитель текущей страницы) или на главную админки
$parent = count($crumbs) > 1 ? $crumbs[count($crumbs) - 2] : null;
$backLink = $parent['link'] ?? Page::url('');
?>
<div class="page-head page-head-theme_<?= $theme ?>">
    <div class="page-head__crumbs">
        <?= $crumbsHtml ?>
        <?= Button::drawButton(
            className: 'page-head__back',
            text: 'Назад',
            link: $backLink,
            style: ButtonStyle::Flat,
            size: ButtonSize::Small,
            theme: ButtonTheme::from($theme),
            iconLeft: 'arrow-left',
        ) ?>
    </div>
    <div class="page-head__row">
        <h1 class="page-head__title"><?= htmlspecialchars($title) ?></h1>
        <div class="page-head__actions">
            <?= Button::drawButton(
                className: 'page-head__site',
                text: 'На сайт',
                link: '/',
                style: ButtonStyle::Secondary,
                size: ButtonSize::Small,
                theme: ButtonTheme::from($theme),
                attributes: ['target' => '_blank', 'rel' => 'noopener'],
                iconLeft: 'globe',
            ) ?>
            <?= $action ?>
        </div>
    </div>
</div>

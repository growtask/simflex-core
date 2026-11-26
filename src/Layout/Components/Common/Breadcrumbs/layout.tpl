<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;

$theme = $data['theme'];
$items = $data['items'];
$last = count($items) - 1;
// на телефоне видны дом, «…», родитель и текущая страница: середина сворачивается
$isCollapsible = $last >= 2;
?>
<nav class="breadcrumbs breadcrumbs-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>"
     aria-label="<?= htmlspecialchars($data['label']) ?>" data-sf-breadcrumbs>
    <ol class="breadcrumbs__list">
        <?php if ($data['homeLink'] !== ''): ?>
            <li class="breadcrumbs__home">
                <?= Button::drawButtonMain(
                    link: $data['homeLink'],
                    icon: 'home',
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::ExtraSmall,
                    theme: ButtonMainTheme::from($theme),
                    attributes: ['aria-label' => $data['homeLabel']],
                ) ?>
            </li>
        <?php endif; ?>
        <?php foreach ($items as $i => $item): ?>
            <?php if ($isCollapsible && $i === 1): ?>
                <li class="breadcrumbs__item breadcrumbs__more">
                    <?= Tab::drawTabMain(
                        text: '…',
                        style: TabMainStyle::Flat,
                        size: TabMainSize::ExtraSmall,
                        theme: TabMainTheme::from($theme),
                        attributes: [
                            'data-sf-breadcrumbs-more' => '',
                            'aria-label' => 'Показать все разделы',
                            'aria-expanded' => 'false',
                        ],
                    ) ?>
                </li>
            <?php endif; ?>
            <?php $isMiddle = $isCollapsible && $i > 0 && $i < $last - 1; ?>
            <li class="breadcrumbs__item<?= $isMiddle ? ' breadcrumbs__item_middle' : '' ?>">
                <?php if ($i < $last && ($item['link'] ?? '') !== ''): ?>
                    <?= Tab::drawTabMain(
                        text: htmlspecialchars($item['name']),
                        link: $item['link'],
                        style: TabMainStyle::Flat,
                        size: TabMainSize::ExtraSmall,
                        theme: TabMainTheme::from($theme),
                    ) ?>
                <?php elseif ($i < $last): ?>
                    <span class="breadcrumbs__text"><?= htmlspecialchars($item['name']) ?></span>
                <?php else: ?>
                    <span class="tab tab-flat tab-size_xs tab-theme_<?= $theme ?> active breadcrumbs__current"
                          aria-current="page"><span class="tab__text"><?= htmlspecialchars($item['name']) ?></span></span>
                <?php endif; ?>
            </li>
        <?php endforeach; ?>
    </ol>
</nav>

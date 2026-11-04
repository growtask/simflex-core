<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;

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
                <?= Button::drawButton(
                    link: $data['homeLink'],
                    icon: 'home',
                    style: ButtonStyle::Secondary,
                    size: ButtonSize::ExtraSmall,
                    theme: ButtonTheme::from($theme),
                    attributes: ['aria-label' => $data['homeLabel']],
                ) ?>
            </li>
        <?php endif; ?>
        <?php foreach ($items as $i => $item): ?>
            <?php if ($isCollapsible && $i === 1): ?>
                <li class="breadcrumbs__item breadcrumbs__more">
                    <?= Tab::drawTab(
                        text: '…',
                        style: TabStyle::Flat,
                        size: TabSize::ExtraSmall,
                        theme: TabTheme::from($theme),
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
                    <?= Tab::drawTab(
                        text: htmlspecialchars($item['name']),
                        link: $item['link'],
                        style: TabStyle::Flat,
                        size: TabSize::ExtraSmall,
                        theme: TabTheme::from($theme),
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

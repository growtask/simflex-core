<?php

/**
 * Страница группы меню: подпункты карточками (на главной админки — группы с их пунктами)
 * @var array<string, array<string, array>> $menu
 * @var string $currentId
 * @var string $theme
 */

use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;

$visible = fn(array $items) => array_filter($items, fn(array $item) => !$item['hidden']);
?>
<div class="group-cards group-cards-theme_<?= $theme ?>">
    <?php foreach ($visible($menu[$currentId]) as $id => $item): ?>
        <?php $children = $visible($menu[$id] ?? []); ?>
        <section class="group-card">
            <a class="group-card__head" href="<?= htmlspecialchars($item['link']) ?>">
                <span class="group-card__icon"><?= renderIcon($item['icon'] ?: 'layers', 'group-card__icon-svg') ?></span>
                <span class="group-card__name"><?= htmlspecialchars($item['name']) ?></span>
                <?= renderIcon('chevron-m-right', 'group-card__chevron') ?>
            </a>
            <?php if ($children): ?>
                <ul class="group-card__items">
                    <?php foreach ($children as $child): ?>
                        <li>
                            <?= Tab::drawTab(
                                className: 'group-card__item',
                                text: htmlspecialchars($child['name']),
                                link: $child['link'],
                                iconLeft: $child['icon'],
                                style: TabStyle::Flat,
                                size: TabSize::Small,
                                theme: TabTheme::from($theme),
                            ) ?>
                        </li>
                    <?php endforeach; ?>
                </ul>
            <?php endif; ?>
        </section>
    <?php endforeach; ?>
</div>

<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;

$theme = $data['theme'];
$uid = substr(md5(serialize($data['items'])), 0, 8);
?>
<nav class="nav-menu-list nav-menu-list-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>"
     aria-label="<?= htmlspecialchars($data['label']) ?>" data-sf-menu-list>
    <ul class="nav-menu-list__list">
        <?php foreach ($data['items'] as $i => $item): ?>
            <?php $children = $item['children'] ?? []; ?>
            <?php $open = $children !== [] && !empty($item['open']); ?>
            <li class="nav-menu-list__item<?= $open ? ' nav-menu-list__item_open' : '' ?>">
                <?php if ($children !== []): ?>
                    <?php $subId = "nav-menu-list-$uid-$i"; ?>
                    <?= Tab::drawTabMain(
                        className: 'nav-menu-list__tab nav-menu-list__toggle',
                        text: htmlspecialchars($item['text']),
                        iconRight: 'chevron-s-down',
                        style: TabMainStyle::Soft,
                        size: TabMainSize::Small,
                        theme: TabMainTheme::from($theme),
                        attributes: [
                            'aria-expanded' => $open ? 'true' : 'false',
                            'aria-controls' => $subId,
                            'data-sf-menu-toggle' => '',
                        ],
                        active: !empty($item['current']),
                    ) ?>
                    <div class="nav-menu-list__sub" id="<?= $subId ?>">
                        <ul class="nav-menu-list__sub-list">
                            <?php foreach ($children as $child): ?>
                                <li>
                                    <?= Tab::drawTabMain(
                                        className: 'nav-menu-list__tab',
                                        text: htmlspecialchars($child['text']),
                                        link: $child['link'],
                                        style: TabMainStyle::Soft,
                                        size: TabMainSize::Small,
                                        theme: TabMainTheme::from($theme),
                                        active: !empty($child['current']),
                                    ) ?>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php else: ?>
                    <?= Tab::drawTabMain(
                        className: 'nav-menu-list__tab',
                        text: htmlspecialchars($item['text']),
                        link: $item['link'] ?? '',
                        style: TabMainStyle::Soft,
                        size: TabMainSize::Small,
                        theme: TabMainTheme::from($theme),
                        active: !empty($item['current']),
                    ) ?>
                <?php endif; ?>
            </li>
        <?php endforeach; ?>
    </ul>
</nav>

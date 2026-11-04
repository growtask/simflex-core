<?php

/**
 * Группы и пункты меню админки (компоненты макета menu-group, menu-tab-compact): группа — раскрываемая плашка
 * (не ссылка), пункты — Tabs/main flat, текущий — soft active. Меню двухуровневое (Admin\Menu)
 * @var array<string, array<string, array>> $menu id родителя => id => пункт (Page::getMenu())
 * @var string $currentId id текущего пункта
 * @var string $theme Тема админки
 */

use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Core\Tooltip\TooltipTheme;

$tabTheme = TabTheme::from($theme);
$tooltipTheme = TooltipTheme::from($theme);
$drawItem = fn(array $item, bool $isCurrent) => Tab::drawTab(
    className: 'menu-item',
    text: htmlspecialchars($item['name']),
    link: $item['link'],
    iconLeft: $item['icon'],
    style: $isCurrent ? TabStyle::Soft : TabStyle::Flat,
    size: TabSize::Small,
    theme: $tabTheme,
    attributes: ['data-sf-menu-item' => mb_strtolower($item['name'])],
    active: $isCurrent,
);
$groupIndex = 0;
?>
<ul class="menu__groups">
    <?php foreach ($menu[''] ?? [] as $id => $item): ?>
        <?php if ($item['hidden']) {
            continue;
        } ?>
        <?php $children = array_filter($menu[$id] ?? [], fn(array $child) => !$child['hidden']); ?>
        <?php if (!$children): ?>
            <li class="menu__leaf">
                <?= Tooltip::drawTooltip(
                    $drawItem($item, $id === $currentId),
                    $item['name'],
                    position: TooltipPosition::Left,
                    theme: $tooltipTheme,
                    className: 'menu__tooltip',
                ) ?>
            </li>
            <?php continue; ?>
        <?php endif; ?>
        <?php
        $isCurrent = isset($children[$currentId]);
        $groupId = 'sf-menu-group-' . ++$groupIndex;
        $head = '<button type="button" class="menu-group__head" aria-expanded="' . ($isCurrent ? 'true' : 'false')
            . '" aria-controls="' . $groupId . '">'
            . '<span class="menu-group__icon">' . renderIcon($item['icon'] ?: 'layers', 'menu-group__icon-svg') . '</span>'
            . '<span class="menu-group__name">' . htmlspecialchars($item['name']) . '</span>'
            . renderIcon('chevron-m-down', 'menu-group__chevron')
            . '</button>';
        ?>
        <li class="menu-group<?= $isCurrent ? ' menu-group_current menu-group_open' : '' ?>"
            data-sf-menu-group="<?= htmlspecialchars($id) ?>">
            <?= Tooltip::drawTooltip(
                $head,
                $item['name'],
                position: TooltipPosition::Left,
                theme: $tooltipTheme,
                className: 'menu__tooltip',
            ) ?>
            <div class="menu-group__body" id="<?= $groupId ?>">
                <ul class="menu-group__items">
                    <?php foreach ($children as $childId => $child): ?>
                        <li><?= $drawItem($child, $childId === $currentId) ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        </li>
    <?php endforeach; ?>
</ul>
<p class="menu__empty" data-sf-menu-empty hidden>Ничего не найдено</p>

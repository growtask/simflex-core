<?php

/**
 * Демо SwitchTreeItem: уровень × раскрытие × выбор (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\Layout as TreeItem;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\SwitchTreeItemExpand;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\SwitchTreeItemState;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeTheme;

$treeTheme = SwitchTreeTheme::from($theme);

?>
<?php foreach (SwitchTreeSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <?php foreach ([0, 1, 2] as $level): ?>
        <div class="ui-showcase__row">
            <?php foreach (SwitchTreeItemState::cases() as $state): ?>
                <?= TreeItem::drawSwitchTreeItem('Категория', '12', $level, $level < 2 ? SwitchTreeItemExpand::Collapsed : SwitchTreeItemExpand::None, $state, size: $size, theme: $treeTheme) ?>
            <?php endforeach; ?>
            <?= TreeItem::drawSwitchTreeItem('Раскрыта', '4', $level, SwitchTreeItemExpand::Expanded, SwitchTreeItemState::Partial, size: $size, theme: $treeTheme) ?>
            <?= TreeItem::drawSwitchTreeItem('Недоступна', disabled: true, level: $level, size: $size, theme: $treeTheme) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

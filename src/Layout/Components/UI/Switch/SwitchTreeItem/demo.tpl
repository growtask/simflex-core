<?php

/**
 * Демо SwitchTreeItem: уровень × раскрытие × выбор (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\Layout as TreeItem;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\TreeItemExpand;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem\TreeItemState;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeTheme;

$treeTheme = TreeTheme::from($theme);

?>
<?php foreach (TreeSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <?php foreach ([0, 1, 2] as $level): ?>
        <div class="ui-showcase__row">
            <?php foreach (TreeItemState::cases() as $state): ?>
                <?= TreeItem::drawTreeItem('Категория', '12', $level, $level < 2 ? TreeItemExpand::Collapsed : TreeItemExpand::None, $state, size: $size, theme: $treeTheme) ?>
            <?php endforeach; ?>
            <?= TreeItem::drawTreeItem('Раскрыта', '4', $level, TreeItemExpand::Expanded, TreeItemState::Partial, size: $size, theme: $treeTheme) ?>
            <?= TreeItem::drawTreeItem('Недоступна', disabled: true, level: $level, size: $size, theme: $treeTheme) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

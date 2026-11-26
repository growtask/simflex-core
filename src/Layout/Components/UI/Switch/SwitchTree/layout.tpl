<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\Layout as Tree;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeTheme;

$size = SwitchTreeSize::from($data['size']);
$theme = SwitchTreeTheme::from($data['theme']);
$classes = ['tree', "tree-size_{$data['size']}", "tree-theme_{$data['theme']}", $data['className']];
$counter = 0;

$render = static function (array $nodes, bool $root) use (&$render, $data, $size, $theme, &$counter): void {
    ?>
    <ul class="<?= $root ? 'tree__list' : 'tree__group' ?>"<?= $root && $data['label'] !== '' ? ' aria-label="' . htmlspecialchars($data['label']) . '"' : '' ?>>
        <?php foreach ($nodes as $node): ?>
            <?php
            $hasChildren = $node['children'] !== [];
            $groupId = 'tree-group-' . ++$counter;
            ?>
            <li class="tree-node<?= $hasChildren && $node['expanded'] ? ' tree-node_expanded' : '' ?>">
                <div class="tree-item tree-item-size_<?= $data['size'] ?> tree-item-theme_<?= $data['theme'] ?><?= $node['disabled'] ? ' tree-item_disabled' : '' ?>">
                    <?php if ($hasChildren): ?>
                        <button type="button" class="tree-item__toggle" aria-expanded="<?= $node['expanded'] ? 'true' : 'false' ?>"
                                aria-controls="<?= $groupId ?>" aria-label="Раскрыть «<?= htmlspecialchars($node['label']) ?>»">
                            <?= renderIcon('chevron-s-right', 'tree-item__chevron') ?>
                        </button>
                    <?php else: ?>
                        <span class="tree-item__toggle tree-item__toggle_empty" aria-hidden="true"></span>
                    <?php endif; ?>
                    <span class="tree-item__control"><?= Tree::drawSwitchTreeControl($node, $data['name'], $size, $theme) ?></span>
                    <?php if ($node['count'] !== ''): ?>
                        <span class="tree-item__count"><?= htmlspecialchars($node['count']) ?></span>
                    <?php endif; ?>
                </div>
                <?php if ($hasChildren): ?>
                    <div id="<?= $groupId ?>" class="tree-node__children"<?= $node['expanded'] ? '' : ' hidden' ?>>
                        <?php $render($node['children'], false); ?>
                    </div>
                <?php endif; ?>
            </li>
        <?php endforeach; ?>
    </ul>
    <?php
};
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>">
    <?php $render($data['items'], true); ?>
</div>

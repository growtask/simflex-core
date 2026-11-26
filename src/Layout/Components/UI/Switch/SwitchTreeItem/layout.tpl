<?php
/** @var array $data */

$classes = ['tree', "tree-size_{$data['size']}", "tree-theme_{$data['theme']}", $data['className']];
$hasChildren = $data['expand'] !== 'none';
$expanded = $data['expand'] === 'expanded';
?>
<div class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>">
    <?php for ($i = 0; $i < $data['level']; $i++): ?><ul class="tree__group"><li class="tree-node"><div class="tree-node__children"><?php endfor; ?>
    <ul class="tree__list">
        <li class="tree-node<?= $expanded ? ' tree-node_expanded' : '' ?>">
            <div class="tree-item tree-item-size_<?= $data['size'] ?> tree-item-theme_<?= $data['theme'] ?><?= $data['disabled'] ? ' tree-item_disabled' : '' ?>">
                <?php if ($hasChildren): ?>
                    <button type="button" class="tree-item__toggle" aria-expanded="<?= $expanded ? 'true' : 'false' ?>"
                            aria-label="Раскрыть «<?= htmlspecialchars($data['label']) ?>»">
                        <?= renderIcon('chevron-s-right', 'tree-item__chevron') ?>
                    </button>
                <?php else: ?>
                    <span class="tree-item__toggle tree-item__toggle_empty" aria-hidden="true"></span>
                <?php endif; ?>
                <span class="tree-item__control"><?= $data['control'] ?></span>
                <?php if ($data['count'] !== ''): ?>
                    <span class="tree-item__count"><?= htmlspecialchars($data['count']) ?></span>
                <?php endif; ?>
            </div>
        </li>
    </ul>
    <?php for ($i = 0; $i < $data['level']; $i++): ?></div></li></ul><?php endfor; ?>
</div>

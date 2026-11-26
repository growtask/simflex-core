<?php

/**
 * Демо Tree: размеры S и M, три уровня, partial у родителя, отключённый узел, счётчики (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\Layout as Tree;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeTheme;

$treeTheme = TreeTheme::from($theme);
$items = [
    ['label' => 'Категория', 'count' => 12],
    [
        'label' => 'Категория с частью выбранных',
        'count' => 24,
        'expanded' => true,
        'children' => [
            ['label' => 'Подкатегория', 'checked' => true, 'count' => 8],
            ['label' => 'Подкатегория', 'checked' => true, 'count' => 6],
            [
                'label' => 'Подкатегория с вложением',
                'expanded' => true,
                'children' => [
                    ['label' => 'Третий уровень'],
                    ['label' => 'Третий уровень', 'checked' => true],
                ],
            ],
            ['label' => 'Подкатегория', 'disabled' => true],
        ],
    ],
    ['label' => 'Категория выбрана', 'checked' => true],
    ['label' => 'Категория отключена', 'disabled' => true],
];

?>
<?php foreach (TreeSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__field">
        <?= Tree::drawTree($items, $size, $treeTheme) ?>
    </div>
<?php endforeach; ?>

<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem;

use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\Layout as Tree;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\TreeTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Строка дерева (набор Figma Switches/tree-item): подпись с чекбоксом, счётчик и стрелка раскрытия. Живёт внутри
 * SwitchTree; отдельно показывает строку любого уровня. Стили и скрипт — у SwitchTree (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    /**
     * @param int $level Уровень вложенности 0–2 (отступ слева)
     * @param string $count Счётчик справа; пусто — без счётчика
     */
    public static function drawTreeItem(
        string          $label = '',
        string          $count = '',
        int             $level = 0,
        TreeItemExpand  $expand = TreeItemExpand::None,
        TreeItemState   $state = TreeItemState::Off,
        bool            $disabled = false,
        TreeSize        $size = TreeSize::Small,
        TreeTheme       $theme = TreeTheme::Light,
        string          $className = '',
    ): string {
        Tree::initAssets();
        $node = [
            'label' => $label,
            'value' => $label,
            'count' => $count,
            'disabled' => $disabled,
            'state' => $state->value,
        ];
        $control = Tree::drawControl($node, '', $size, $theme);

        return static::draw(compact('label', 'count', 'disabled', 'control', 'className') + [
            'level' => max(0, min(2, $level)),
            'expand' => $expand->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

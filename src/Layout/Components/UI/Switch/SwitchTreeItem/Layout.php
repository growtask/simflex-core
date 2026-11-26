<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem;

use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\Layout as Tree;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchTree\SwitchTreeTheme;
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
    public static function drawSwitchTreeItem(
        string          $label = '',
        string          $count = '',
        int             $level = 0,
        SwitchTreeItemExpand  $expand = SwitchTreeItemExpand::None,
        SwitchTreeItemState   $state = SwitchTreeItemState::Off,
        bool            $disabled = false,
        SwitchTreeSize        $size = SwitchTreeSize::Small,
        SwitchTreeTheme       $theme = SwitchTreeTheme::Light,
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
        $control = Tree::drawSwitchTreeControl($node, '', $size, $theme);

        return static::draw(compact('label', 'count', 'disabled', 'control', 'className') + [
            'level' => max(0, min(2, $level)),
            'expand' => $expand->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

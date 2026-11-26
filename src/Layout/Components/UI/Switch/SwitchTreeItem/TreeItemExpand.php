<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem;

/** Раскрытие строки дерева (набор Figma Switches/tree-item) */
enum TreeItemExpand: string
{
    case None = 'none';
    case Collapsed = 'collapsed';
    case Expanded = 'expanded';
}

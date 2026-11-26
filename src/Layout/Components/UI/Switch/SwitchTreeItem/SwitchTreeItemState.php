<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchTreeItem;

/** Выбор строки дерева: Partial — выбрана часть вложенных */
enum SwitchTreeItemState: string
{
    case Off = 'off';
    case On = 'on';
    case Partial = 'partial';
}

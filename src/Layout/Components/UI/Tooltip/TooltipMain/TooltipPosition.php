<?php

namespace Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain;

/**
 * Сторона, на которой стрелка: тултип стоит с противоположной стороны элемента (Top — под элементом,
 * Left — справа от него)
 */
enum TooltipPosition: string
{
    case Top = 'top';
    case Bottom = 'bottom';
    case Left = 'left';
    case Right = 'right';
}

<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchSort;

enum SortDirection: string
{
    case Ascending = 'ascending';
    case Descending = 'descending';
    case None = 'none';
}

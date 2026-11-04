<?php

namespace Simflex\Core\Layout\Components\UI\Core\SortButton;

enum SortDirection: string
{
    case Ascending = 'ascending';
    case Descending = 'descending';
    case None = 'none';
}

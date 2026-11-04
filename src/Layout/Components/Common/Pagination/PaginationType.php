<?php

namespace Simflex\Core\Layout\Components\Common\Pagination;

enum PaginationType: string
{
    /** Номера страниц */
    case Pages = 'pages';
    /** Стрелки и «10 / 20» */
    case Compact = 'compact';
}

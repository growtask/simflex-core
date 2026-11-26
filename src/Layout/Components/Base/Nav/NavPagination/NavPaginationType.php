<?php

namespace Simflex\Core\Layout\Components\Base\Nav\NavPagination;

enum NavPaginationType: string
{
    /** Номера страниц */
    case Pages = 'pages';
    /** Стрелки и «10 / 20» */
    case Compact = 'compact';
    /** Кнопка «Показать ещё» и подпись «20 из 120» */
    case More = 'more';
}

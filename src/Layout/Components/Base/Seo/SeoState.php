<?php

namespace Simflex\Core\Layout\Components\Base\Seo;

enum SeoState: string
{
    /** Весь текст */
    case Expanded = 'expanded';
    /** Текст обрезан после трёх строк, видна ссылка «Читать далее» */
    case Collapsed = 'collapsed';
}

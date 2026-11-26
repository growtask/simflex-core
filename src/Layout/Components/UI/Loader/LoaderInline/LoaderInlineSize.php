<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderInline;

/** Размер строки загрузки: спиннер 16, 24, 32 px и подпись ui/s, ui/m, ui/m */
enum LoaderInlineSize: string
{
    case Small = 's';
    case Medium = 'm';
    case Large = 'l';
}

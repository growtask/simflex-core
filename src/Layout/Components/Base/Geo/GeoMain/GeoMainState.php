<?php

namespace Simflex\Core\Layout\Components\Base\Geo\GeoMain;

/** Состояние (Figma state): вопрос, подтверждён, поиск, список, выбран, ничего не найдено */
enum GeoMainState: string
{
    case Static = 'static';
    case Active = 'active';
    case Choice = 'choice';
    case Dropdown = 'dropdown';
    case Selected = 'selected';
    case Empty = 'empty';
}

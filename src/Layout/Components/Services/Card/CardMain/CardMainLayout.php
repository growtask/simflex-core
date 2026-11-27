<?php

namespace Simflex\Core\Layout\Components\Services\Card\CardMain;

/** Раскладка (Figma layout): Card — для сетки, List — для длинного списка (картинка слева, всё в строку) */
enum CardMainLayout: string
{
    case Card = 'card';
    case List = 'list';
}

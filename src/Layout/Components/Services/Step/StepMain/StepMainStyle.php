<?php

namespace Simflex\Core\Layout\Components\Services\Step\StepMain;

/** Вид (Figma style): Default — на FullHD и HD ряд, на планшете сетка, на телефоне вертикальная линия; Scroll — карточки в слайдере */
enum StepMainStyle: string
{
    case Default = 'default';
    case Scroll = 'scroll';
}

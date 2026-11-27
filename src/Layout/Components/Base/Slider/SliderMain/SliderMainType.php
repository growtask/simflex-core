<?php

namespace Simflex\Core\Layout\Components\Base\Slider\SliderMain;

/** Управление рядом (Figma type): стрелки, индикатор шагов или ничего */
enum SliderMainType: string
{
    case Arrows = 'arrows';
    case Steps = 'steps';
    case None = 'none';
}

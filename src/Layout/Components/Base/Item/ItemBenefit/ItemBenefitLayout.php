<?php

namespace Simflex\Core\Layout\Components\Common\Benefit;

/**
 * Расположение знака: сверху или слева от текста
 */
enum BenefitLayout: string
{
    case Vertical = 'vertical';
    case Horizontal = 'horizontal';
}

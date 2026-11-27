<?php

namespace Simflex\Core\Layout\Components\Base\Item\ItemBenefit;

/**
 * Расположение знака: сверху или слева от текста
 */
enum ItemBenefitLayout: string
{
    case Vertical = 'vertical';
    case Horizontal = 'horizontal';
}

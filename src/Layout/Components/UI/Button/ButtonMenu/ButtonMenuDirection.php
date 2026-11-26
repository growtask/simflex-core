<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonMenu;

/**
 * Расположение иконки и подписи кнопки меню (Figma Buttons/menu, свойство direction)
 */
enum ButtonMenuDirection: string
{
    /** Иконка над подписью, бейдж в правом верхнем углу */
    case Vertical = 'vertical';
    /** Иконка, подпись и бейдж в одну строку */
    case Horizontal = 'horizontal';
}

<?php

namespace Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo;

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as TooltipMain;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Иконка «i» с подсказкой (набор Figma Tooltip/info): кнопка icon-small flat и подсказка TooltipMain
 */
class Layout extends LayoutBase
{
    /**
     * Иконка «i» с подсказкой (Tooltip/info): кнопка icon-small flat, подсказка справа
     * @param string $label Доступное имя кнопки
     */
    public static function drawInfo(
        string          $text,
        TooltipTheme    $theme = TooltipTheme::Light,
        TooltipPosition $position = TooltipPosition::Left,
        string          $label = 'Подсказка',
    ): string {
        $button = ButtonIcon::drawButtonIcon(
            icon: 'notify-info',
            label: $label,
            className: 'tooltip-info__button',
            theme: ButtonIconTheme::from($theme->value),
            attributes: ['title' => ''],
        );

        return TooltipMain::drawTooltip($button, $text, $position, theme: $theme, className: 'tooltip-info');
    }
}

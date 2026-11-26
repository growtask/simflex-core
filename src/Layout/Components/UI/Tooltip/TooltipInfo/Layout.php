<?php

namespace Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo;

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as TooltipMain;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;
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
    public static function drawTooltipInfo(
        string          $text,
        TooltipMainTheme    $theme = TooltipMainTheme::Light,
        TooltipMainPosition $position = TooltipMainPosition::Left,
        string          $label = 'Подсказка',
    ): string {
        $button = ButtonIcon::drawButtonIconSmall(
            icon: 'notify-info',
            label: $label,
            className: 'tooltip-info__button',
            theme: ButtonIconSmallTheme::from($theme->value),
            attributes: ['title' => ''],
        );

        return TooltipMain::drawTooltipMain($button, $text, $position, theme: $theme, className: 'tooltip-info');
    }
}

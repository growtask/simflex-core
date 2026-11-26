<?php

namespace Simflex\Core\Layout\Components\UI\Tab\TabDisabled;

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as TabMain;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Недоступная вкладка (набор Figma Tabs/disabled): раздел есть, но сейчас недоступен. Разметка и стили общие с TabMain
 * (у button атрибут disabled, у ссылки aria-disabled без href и вне порядка фокуса)
 */
class Layout extends LayoutBase
{
    public static function drawTabDisabled(
        string   $text = '',
        string   $link = '',
        string   $iconLeft = '',
        string   $iconRight = '',
        string   $badge = '',
        TabMainStyle $style = TabMainStyle::Primary,
        TabMainSize  $size = TabMainSize::Medium,
        TabMainTheme $theme = TabMainTheme::Light,
        string   $className = '',
    ): string {
        return TabMain::drawTabMain(
            className: $className,
            text: $text,
            link: $link,
            iconLeft: $iconLeft,
            iconRight: $iconRight,
            badge: $badge,
            style: $style,
            size: $size,
            theme: $theme,
            disabled: true,
        );
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarArrow;

use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\Layout as ScrollbarMain;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarSize;
use Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain\ScrollbarTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Стрелка полосы прокрутки (набор Figma Scrollbar/arrow): живёт внутри ScrollbarMain; отдельно показывает кнопку
 * во всех направлениях. Стили и скрипт — у ScrollbarMain (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    public static function drawScrollbarArrow(
        ScrollbarArrowStyle $style = ScrollbarArrowStyle::Down,
        ScrollbarSize       $size = ScrollbarSize::Medium,
        ScrollbarTheme      $theme = ScrollbarTheme::Light,
        string              $className = '',
    ): string {
        ScrollbarMain::initAssets();

        return static::draw(compact('className') + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

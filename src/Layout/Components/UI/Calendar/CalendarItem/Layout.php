<?php

namespace Simflex\Core\Layout\Components\UI\Calendar\CalendarItem;

use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\CalendarMainTheme;
use Simflex\Core\Layout\Components\UI\Calendar\CalendarMain\Layout as CalendarMain;
use Simflex\Core\Layout\LayoutBase;

/**
 * Ячейка месяца или года (набор Figma Calendar/item): живёт внутри CalendarMain (строит script.js); отдельно показывает
 * ячейку в состояниях обычная, текущая, выбранная. Стили — у CalendarMain (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    public static function drawCalendarItem(
        string        $text = 'Март',
        bool          $selected = false,
        bool          $current = false,
        CalendarMainTheme $theme = CalendarMainTheme::Light,
        string        $className = '',
    ): string {
        CalendarMain::initAssets();

        return static::draw(compact('text', 'selected', 'current', 'className') + ['theme' => $theme->value]);
    }
}

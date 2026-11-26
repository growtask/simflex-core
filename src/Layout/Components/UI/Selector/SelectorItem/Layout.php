<?php

namespace Simflex\Core\Layout\Components\UI\Selector\SelectorItem;

use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\Layout as SelectorMain;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorSize;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorStyle;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Вариант селектора (набор Figma Selector/item): один сегмент. Живёт внутри SelectorMain; отдельно показывает
 * сегмент во всех стилях, размерах и состояниях. Стили и скрипт — у SelectorMain (подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Подпись
     * @param string $icon Иконка слева
     * @param string $badge Бейдж справа
     * @param bool $active Сегмент выбран
     */
    public static function drawSelectorItem(
        string        $text = '',
        string        $icon = '',
        string        $badge = '',
        bool          $active = false,
        bool          $disabled = false,
        SelectorStyle $style = SelectorStyle::Filled,
        SelectorSize  $size = SelectorSize::Medium,
        SelectorTheme $theme = SelectorTheme::Light,
        string        $className = '',
    ): string {
        SelectorMain::initAssets();

        return static::draw(compact('text', 'icon', 'badge', 'active', 'disabled', 'className') + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

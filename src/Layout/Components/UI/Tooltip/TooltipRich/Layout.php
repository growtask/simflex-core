<?php

namespace Simflex\Core\Layout\Components\UI\Tooltip\TooltipRich;

use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as TooltipMain;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipSide;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Расширенная подсказка (набор Figma Tooltip/rich): заголовок, текст и действие. Стили и скрипт общие с TooltipMain (он подключается вместе с этим компонентом)
 */
class Layout extends LayoutBase
{
    /**
     * Расширенная подсказка (Tooltip/rich): заголовок, текст и действие («Подробнее»); от простой отличается
     * тем, что на неё можно навести курсор и нажать ссылку действия
     * @param string $trigger HTML элемента, к которому относится подсказка
     * @param string $title Заголовок (экранируется)
     * @param string $text Пояснение (экранируется)
     * @param string $actionText Текст действия; пустой — без действия
     * @param string $actionLink Ссылка действия
     * @param string $icon Иконка перед заголовком; пустая — без иконки
     */
    public static function drawRich(
        string          $trigger,
        string          $title,
        string          $text = '',
        string          $actionText = '',
        string          $actionLink = '',
        string          $icon = '',
        TooltipPosition $position = TooltipPosition::Top,
        TooltipSide     $side = TooltipSide::Center,
        TooltipTheme    $theme = TooltipTheme::Light,
        string          $className = '',
    ): string {
        TooltipMain::initAssets();
        $id = TooltipMain::nextId();
        $trigger = TooltipMain::bindTrigger($trigger, $id);

        return static::draw(compact('trigger', 'title', 'text', 'actionText', 'actionLink', 'icon', 'id', 'className') + [
            'position' => $position->value,
            'side' => $side->value,
            'theme' => $theme->value,
        ]);
    }
}

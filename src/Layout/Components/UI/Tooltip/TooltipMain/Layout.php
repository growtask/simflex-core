<?php

namespace Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Подсказка (набор Figma Tooltip/main): показывается при наведении и фокусе на элементе
 * с задержкой 150 мс, скрывается по уходу, потере фокуса и Esc, на тач-устройствах — по нажатию.
 * Расширенная подсказка — TooltipRich, иконка «i» — TooltipInfo; стили и скрипт общие для всех трёх
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string $trigger HTML элемента, к которому относится подсказка (первому тегу добавляется aria-describedby)
     * @param string $text Текст подсказки (экранируется)
     * @param TooltipPosition $position Сторона стрелки: Top — подсказка под элементом, Left — справа от него
     * @param TooltipSide $side Положение стрелки вдоль края (для Top и Bottom)
     * @param TooltipStyle $style Error — красная подсказка к полю с ошибкой
     */
    public static function drawTooltip(
        string          $trigger,
        string          $text,
        TooltipPosition $position = TooltipPosition::Top,
        TooltipSide     $side = TooltipSide::Center,
        TooltipStyle    $style = TooltipStyle::Default,
        TooltipTheme    $theme = TooltipTheme::Light,
        string          $className = '',
    ): string {
        $id = static::nextId();
        $trigger = static::bindTrigger($trigger, $id);

        return static::draw(compact('trigger', 'text', 'id', 'className') + [
            'position' => $position->value,
            'side' => $side->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }

    /** Следующий уникальный id подсказки (общий для TooltipMain и TooltipRich) */
    public static function nextId(): string
    {
        return 'sf-tooltip-' . ++self::$counter;
    }

    /** Добавляет первому тегу элемента aria-describedby с id подсказки */
    public static function bindTrigger(string $trigger, string $id): string
    {
        return (string)preg_replace('/^(\s*<[a-z][a-z0-9-]*)/i', '$1 aria-describedby="' . $id . '"', $trigger, 1);
    }
}

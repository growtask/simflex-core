<?php

namespace Simflex\Core\Layout\Components\UI\Core\Tooltip;

use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\LayoutBase;

/**
 * Подсказка (наборы Figma Tooltip/main и Tooltip/info): показывается при наведении и фокусе на элементе
 * с задержкой 150 мс, скрывается по уходу, потере фокуса и Esc, на тач-устройствах — по нажатию
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
        $id = 'sf-tooltip-' . ++self::$counter;
        $trigger = (string)preg_replace(
            '/^(\s*<[a-z][a-z0-9-]*)/i',
            '$1 aria-describedby="' . $id . '"',
            $trigger,
            1
        );

        return static::draw(compact('trigger', 'text', 'id', 'className') + [
            'position' => $position->value,
            'side' => $side->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }

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

        return static::drawTooltip($button, $text, $position, theme: $theme, className: 'tooltip-info');
    }
}

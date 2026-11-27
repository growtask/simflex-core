<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonMenu;

use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопка меню (набор Figma Buttons/menu): иконка, подпись и бейдж-счётчик — пункт навигации панелей.
 */
class Layout extends LayoutBase
{
    /**
     * @param string              $className Дополнительные CSS-классы (класс active — текущий раздел)
     * @param string              $text Подпись
     * @param string              $link Адрес: с ним выводится ссылка a, иначе button
     * @param string              $icon Иконка: имя из спрайта или HTML <svg…>; пусто — без иконки
     * @param string              $badge Бейдж-счётчик; пусто — без бейджа
     * @param ButtonMenuStyle     $style Стиль: flat, secondary
     * @param ButtonMenuSize      $size Размер (у s подпись скрыта)
     * @param ButtonMenuTheme     $theme Тема
     * @param array<string,mixed> $attributes HTML-атрибуты корня (disabled, type …)
     */
    public static function drawButtonMenu(
        string          $className = '',
        string          $text = '',
        string          $link = '',
        string          $icon = 'true',
        string          $badge = '',
        ButtonMenuStyle $style = ButtonMenuStyle::Flat,
        ButtonMenuSize  $size = ButtonMenuSize::Medium,
        ButtonMenuTheme $theme = ButtonMenuTheme::Light,
        array           $attributes = [],
        ButtonMenuDirection $direction = ButtonMenuDirection::Vertical
    ): string {
        return static::draw(
            compact(
                'className',
                'text',
                'link',
                'icon',
                'badge',
                'attributes'
            ) + [
                'style' => $style->value,
                'direction' => $direction->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

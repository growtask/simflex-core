<?php

namespace Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon;

use Simflex\Core\Layout\LayoutBase;

/**
 * Маленькая кнопка-иконка (набор Figma Buttons/icon-small): 24 px, иконка 16. Компактные действия внутри полей,
 * ячеек и карточек: очистить, скопировать, удалить, закрыть
 */
class Layout extends LayoutBase
{
    /**
     * @param string $icon ID иконки (renderIcon)
     * @param string $label Доступное имя кнопки (aria-label и подсказка title): у кнопки нет текста
     * @param string $link Адрес: с ним вместо button выводится ссылка a
     * @param array<string,string> $attributes Атрибуты элемента (type для button, по умолчанию button)
     * @param bool $disabled Кнопка недоступна
     */
    public static function drawButtonIcon(
        string          $icon,
        string          $label,
        string          $className = '',
        ButtonIconStyle $style = ButtonIconStyle::Flat,
        ButtonIconTheme $theme = ButtonIconTheme::Light,
        string          $link = '',
        array           $attributes = [],
        bool            $disabled = false,
    ): string {
        return static::draw(compact('icon', 'label', 'className', 'link', 'attributes', 'disabled') + [
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }
}

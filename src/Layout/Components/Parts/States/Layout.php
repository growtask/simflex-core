<?php

namespace Simflex\Core\Layout\Components\Parts\States;

use Simflex\Core\Layout\LayoutBase;

/**
 * Состояние вместо содержимого (Figma, блок States: empty, load, alert, success, error): маркер, заголовок, текст и кнопки.
 * Ставится вместо содержимого, а не поверх него. Размеры Figma (fullhd, hd, tablet, mobile) задаёт ширина экрана:
 * ширина блока 700, 628, 480 px и на весь экран на телефоне, на телефоне кнопки друг под другом
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Заголовок; пусто - заголовок состояния
     * @param string $text Текст; пусто - текст состояния
     * @param bool|null $buttons Показывать кнопки; null - как в Figma (нет только у load)
     * @param bool $secondaryButton Показывать вторую кнопку (светлую)
     * @param string $primaryText Подпись основной кнопки; пусто - подпись состояния
     * @param string $primaryLink Адрес основной кнопки: с ним вместо button выводится ссылка
     * @param string $secondaryText Подпись второй кнопки; пусто - подпись состояния
     * @param string $secondaryLink Адрес второй кнопки
     * @param array<string,string> $primaryAttributes Атрибуты основной кнопки (data-*, type)
     * @param array<string,string> $secondaryAttributes Атрибуты второй кнопки
     * @param string $titleTag Тег заголовка: h1-h6, по умолчанию h2
     * @param array<string,string> $attributes Атрибуты блока
     */
    public static function drawStates(
        StatesStyle $style = StatesStyle::Empty,
        StatesTheme $theme = StatesTheme::Light,
        string      $title = '',
        string      $text = '',
        ?bool       $buttons = null,
        bool        $secondaryButton = true,
        string      $primaryText = '',
        string      $primaryLink = '',
        string      $secondaryText = '',
        string      $secondaryLink = '',
        array       $primaryAttributes = [],
        array       $secondaryAttributes = [],
        string      $titleTag = 'h2',
        string      $className = '',
        array       $attributes = []
    ): string {
        $titleTag = in_array($titleTag, ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'], true) ? $titleTag : 'h2';

        return static::draw([
            'style' => $style->value,
            'theme' => $theme->value,
            'markerStyle' => $style->getMarkerStyle(),
            'title' => $title !== '' ? $title : $style->getTitle(),
            'text' => $text !== '' ? $text : $style->getText(),
            'buttons' => $buttons ?? $style->hasButtons(),
            'secondaryButton' => $secondaryButton,
            'primaryText' => $primaryText !== '' ? $primaryText : $style->getPrimaryText(),
            'primaryLink' => $primaryLink,
            'secondaryText' => $secondaryText !== '' ? $secondaryText : $style->getSecondaryText(),
            'secondaryLink' => $secondaryLink,
            'primaryAttributes' => $primaryAttributes,
            'secondaryAttributes' => $secondaryAttributes,
            'titleTag' => $titleTag,
            'className' => $className,
            'role' => $style->getRole(),
            'attributes' => $attributes,
        ]);
    }
}

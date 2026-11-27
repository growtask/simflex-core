<?php

namespace Simflex\Core\Layout\Components\UI\Accordion;

use Simflex\Core\Layout\LayoutBase;

/**
 * Пункт аккордеона (набор Figma Accordion/main): заголовок с шевроном, подзаголовок, комментарий, бейдж и
 * содержимое, которое раскрывается кнопкой (script.js: aria-expanded, закрытие соседних пунктов того же списка).
 * Выводится li — ставьте пункты в ul. Доступность: кнопка-шеврон с aria-expanded, aria-controls
 * и именем из заголовка (aria-labelledby), содержимое — region, закрытое недоступно с клавиатуры (inert).
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string              $className Дополнительные CSS-классы
     * @param string              $title Заголовок
     * @param string              $subtitle Подзаголовок под заголовком
     * @param string              $comment Комментарий справа от заголовка
     * @param string              $badge Текст бейджа у заголовка
     * @param string              $icon Иконка слева: имя из спрайта или HTML <svg…>
     * @param string              $description Содержимое (HTML, выводится как есть)
     * @param AccordionStyle      $style Стиль: filled, underline, button
     * @param AccordionSize       $size Размер
     * @param AccordionTheme      $theme Тема
     * @param array<string,mixed> $attributes HTML-атрибуты li
     * @param string              $id Префикс id заголовка и содержимого (пусто — sf-accordion-N)
     * @param bool                $open Открыт при выводе
     * @param bool                $multipleOpen true — при открытии соседние пункты списка не закрываются
     */
    public static function drawAccordion(
        string         $className = '',
        string         $title = '',
        string         $subtitle = '',
        string         $comment = '',
        string         $badge = '',
        string         $icon = '',
        string         $description = '',
        AccordionStyle $style = AccordionStyle::Filled,
        AccordionSize  $size = AccordionSize::Small,
        AccordionTheme $theme = AccordionTheme::Light,
        array          $attributes = [],
        string         $id = '',
        bool           $open = false,
        bool           $multipleOpen = false,
    ): string {
        $id = $id !== '' ? $id : 'sf-accordion-' . ++self::$counter;

        return static::draw(
            compact(
                'className',
                'title',
                'subtitle',
                'comment',
                'badge',
                'icon',
                'description',
                'attributes',
                'id',
                'open',
                'multipleOpen'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

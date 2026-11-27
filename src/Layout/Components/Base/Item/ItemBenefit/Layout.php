<?php

namespace Simflex\Core\Layout\Components\Common\Benefit;

use Simflex\Core\Layout\LayoutBase;

/**
 * Преимущество (Figma: Base/benefit): иконка в маркере или число, заголовок, текст, ссылка и бейдж.
 * Выводится элементом li, список собирает drawBenefitList() (ul) или страница.
 *
 * Классы-связи с Figma: .benefit, __sign (marker / number), __body, __title, __text, __link, __badge.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Заголовок
     * @param string $text Текст
     * @param string $icon Иконка спрайта (type=icon); без иконки знак не выводится
     * @param string $number Число (type=number), например «01»
     * @param array{text?:string,href?:string,label?:string}|null $link Ссылка «Подробнее»: текст, адрес и
     *        доступное имя (по умолчанию «<текст>: <заголовок>»)
     * @param string $badge Текст бейджа после текста (например, срок)
     * @param bool $card Блок с фоном и отступами
     * @param int $headingLevel Уровень заголовка (h3 по умолчанию, по месту h4)
     * @param string $className Дополнительные CSS-классы
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты li
     */
    public static function drawBenefit(
        string        $title = '',
        string        $text = '',
        string        $icon = '',
        string        $number = '',
        ?array        $link = null,
        string        $badge = '',
        BenefitSize   $size = BenefitSize::Medium,
        BenefitType   $type = BenefitType::Icon,
        BenefitLayout $layout = BenefitLayout::Vertical,
        BenefitAlign  $align = BenefitAlign::Left,
        bool          $card = false,
        BenefitTheme  $theme = BenefitTheme::Light,
        int           $headingLevel = 3,
        string        $className = '',
        array         $attributes = []
    ): string {
        // Центрирование есть только у вертикального расположения
        if ($layout === BenefitLayout::Horizontal) {
            $align = BenefitAlign::Left;
        }
        if ($link !== null && (($link['text'] ?? '') === '' || ($link['href'] ?? '') === '')) {
            $link = null;
        }

        return static::draw(
            compact(
                'title',
                'text',
                'icon',
                'number',
                'link',
                'badge',
                'card',
                'className',
                'attributes'
            ) + [
                'size' => $size->value,
                'type' => $type->value,
                'layout' => $layout->value,
                'align' => $align->value,
                'theme' => $theme->value,
                'headingLevel' => min(6, max(1, $headingLevel)),
            ]
        );
    }

    /**
     * Список преимуществ: ul с элементами li
     *
     * @param array<int,array{title?:string,text?:string,icon?:string,number?:string,link?:array,badge?:string}> $items
     *        Данные преимуществ; ключи совпадают с параметрами drawBenefit, пустые (без заголовка и текста) пропускаются
     * @param string $className Дополнительные CSS-классы списка
     * @param string $itemClassName Дополнительные CSS-классы каждого li
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ul
     */
    public static function drawBenefitList(
        array         $items = [],
        string        $className = '',
        string        $itemClassName = '',
        BenefitSize   $size = BenefitSize::Medium,
        BenefitType   $type = BenefitType::Icon,
        BenefitLayout $layout = BenefitLayout::Vertical,
        BenefitAlign  $align = BenefitAlign::Left,
        bool          $card = false,
        BenefitTheme  $theme = BenefitTheme::Light,
        int           $headingLevel = 3,
        array         $attributes = []
    ): string {
        $html = '';
        foreach ($items as $item) {
            if (!is_array($item) || (($item['title'] ?? '') === '' && ($item['text'] ?? '') === '')) {
                continue;
            }
            $html .= static::drawBenefit(
                title: (string)($item['title'] ?? ''),
                text: (string)($item['text'] ?? ''),
                icon: (string)($item['icon'] ?? ''),
                number: (string)($item['number'] ?? ''),
                link: $item['link'] ?? null,
                badge: (string)($item['badge'] ?? ''),
                size: $size,
                type: $type,
                layout: $layout,
                align: $align,
                card: $card,
                theme: $theme,
                headingLevel: $headingLevel,
                className: $itemClassName
            );
        }
        if ($html === '') {
            return '';
        }

        $classes = trim('benefit-list ' . $className);

        return '<ul class="' . htmlspecialchars($classes, ENT_QUOTES, 'UTF-8') . '" ' . buildAttrs($attributes) . '>'
            . $html . '</ul>';
    }
}

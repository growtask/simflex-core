<?php

namespace Simflex\Core\Layout\Components\UI\Core\Tag;

use Simflex\Core\Layout\LayoutBase;

/**
 * Тег (набор Figma Tags/main, design-ui-tags.md): фильтр-переключатель (кнопка, у активного крестик) или
 * удаляемый тег с отдельной кнопкой «Удалить …» (close: true — применённые фильтры, поле тегов)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $icon Иконка слева
     * @param bool|null $close true — тег с отдельной кнопкой удаления (кнопке — data-sf-tag-remove), false — без
     *        крестика, null — тег-кнопка, крестик виден у активного (.active)
     * @param string $closeLabel Доступное имя кнопки удаления, по умолчанию «Удалить <текст>»
     */
    public static function drawTag(
        string      $className = '',
        string      $text = '',
        TagStyle    $style = TagStyle::Primary,
        TagSize  $size = TagSize::Small,
        TagTheme $theme = TagTheme::Light,
        array       $attributes = [],
        string      $icon = '',
        ?bool       $close = null,
        string      $closeLabel = '',
    ): string {
        $closeLabel = $closeLabel !== '' ? $closeLabel : 'Удалить ' . strip_tags($text);
        return static::draw(
            compact(
                'className',
                'text',
                'attributes',
                'icon',
                'close',
                'closeLabel'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Accordion;

use Simflex\Core\Layout\LayoutBase;

class Layout extends LayoutBase
{
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
        array          $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'title',
                'subtitle',
                'comment',
                'badge',
                'icon',
                'description',
                'attributes'
            ) + [
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

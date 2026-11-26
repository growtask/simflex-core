<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonSocial;

use Simflex\Core\Layout\LayoutBase;

/**
 * Кнопка входа или «поделиться» через соцсеть (Figma Buttons/social): плашка с логотипом, подпись и стрелка.
 * Стили сетей рисуют логотип сети и её цвет, нейтральные (Primary, Secondary, Gray) — иконку $icon.
 * С $link кнопка становится ссылкой. Оригинальные цвета сетей — только в стилях сетей
 */
class Layout extends LayoutBase
{
    /**
     * @param string $text Подпись; пусто — название сети (у нейтральных стилей — «Button»); экранируется
     * @param string $link Ссылка; пусто — кнопка
     * @param string $icon Иконка плашки у нейтральных стилей (у стилей сетей — логотип сети)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawButtonSocial(
        string             $text = '',
        string             $link = '',
        string             $icon = 'check',
        ButtonSocialStyle  $style = ButtonSocialStyle::Primary,
        ButtonSocialType   $type = ButtonSocialType::Square,
        ButtonSocialSize   $size = ButtonSocialSize::Medium,
        ButtonSocialTheme  $theme = ButtonSocialTheme::Light,
        array              $attributes = [],
        string             $className = '',
    ): string {
        $text = $text !== '' ? $text : $style->label();
        $icon = $style->isNetwork() ? 'social-' . $style->value : $icon;

        return static::draw(compact('text', 'link', 'icon', 'attributes', 'className') + [
            'style' => $style->value,
            'type' => $type->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

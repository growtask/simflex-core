<?php

namespace Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar;

use Simflex\Core\Layout\LayoutBase;

/**
 * Заглушки (Figma Parts/placeholders, design-parts-placeholders.md): аватар (картинка, инициалы или силуэт, круг)
 * и «нет картинки» вместо изображения
 */
class Layout extends LayoutBase
{
    /**
     * @param string $name Имя: текстовая альтернатива аватара и источник инициалов
     * @param string $image Адрес картинки; пусто — инициалы или силуэт
     */
    public static function drawPlaceholderAvatar(
        string           $name,
        string           $image = '',
        PlaceholderAvatarSize       $size = PlaceholderAvatarSize::Medium,
        PlaceholderAvatarStyle      $style = PlaceholderAvatarStyle::Initials,
        PlaceholderAvatarTheme $theme = PlaceholderAvatarTheme::Light,
        string           $className = '',
    ): string {
        $initials = static::getInitials($name);
        if ($initials === '') {
            $style = PlaceholderAvatarStyle::Silhouette;
        }

        return static::draw(['view' => 'avatar'] + compact('name', 'image', 'initials', 'className') + [
            'size' => $size->value,
            'style' => $style->value,
            'theme' => $theme->value,
        ]);
    }

    /**
     * Заглушка «нет картинки»: иконка image на подложке, размер задаёт родитель
     * @param string $label Текстовая альтернатива
     */
    public static function drawPlaceholderAvatarNoImage(
        string           $label = 'Нет изображения',
        PlaceholderAvatarTheme $theme = PlaceholderAvatarTheme::Light,
        string           $className = '',
    ): string {
        return static::draw(['view' => 'no-image'] + compact('label', 'className') + ['theme' => $theme->value]);
    }

    /**
     * @return string До двух первых букв слов имени, заглавными: «Иван Петров» → «ИП»
     */
    public static function getInitials(string $name): string
    {
        $words = preg_split('/[\s._-]+/u', trim($name), -1, PREG_SPLIT_NO_EMPTY) ?: [];
        $letters = array_map(fn(string $word) => mb_substr($word, 0, 1), array_slice($words, 0, 2));

        return mb_strtoupper(implode('', $letters));
    }
}

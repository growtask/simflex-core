<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton;

use Simflex\Core\Layout\LayoutBase;

/**
 * Заглушка загружающегося содержимого (Figma Loaders/skeleton): серый блок с бегущим бликом — строка, круг или прямоугольник. Карточка — LoaderSkeletonCard.
 * Для скринридера заглушка скрыта (aria-hidden): о загрузке сообщает контейнер (aria-busy у блока)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $width Ширина CSS (160px, 50%); пусто — 160 px у текста и прямоугольника, круг — по размеру
     * @param bool $animation false — без бликующей анимации
     */
    public static function drawLoaderSkeleton(
        LoaderSkeletonShape $shape = LoaderSkeletonShape::Text,
        LoaderSkeletonSize  $size = LoaderSkeletonSize::Medium,
        LoaderSkeletonTheme $theme = LoaderSkeletonTheme::Light,
        bool          $animation = true,
        string        $width = '',
        string        $className = '',
    ): string {
        $classes = "skeleton skeleton_shape_{$shape->value} skeleton_size_{$size->value} skeleton-theme_{$theme->value}"
            . ($animation ? '' : ' skeleton_static') . ($className !== '' ? " $className" : '');
        $style = $width !== '' && $shape !== LoaderSkeletonShape::Circle ? ' style="width:' . htmlspecialchars($width) . '"' : '';

        return static::draw(['classes' => $classes, 'style' => $style]);
    }
}

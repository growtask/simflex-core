<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSkeletonCard;

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\Layout as Skeleton;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonShape;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Карточка-заглушка (Figma Loaders/skeleton-card): аватар, две строки и картинка из LoaderSkeleton; скрыта от скринридера (aria-hidden)
 */
class Layout extends LayoutBase
{
    /** Карточка-заглушка: аватар, две строки и картинка */
    public static function drawLoaderSkeletonCard(
        LoaderSkeletonTheme $theme = LoaderSkeletonTheme::Light,
        bool          $animation = true,
        string        $className = '',
    ): string {
        $block = static fn(LoaderSkeletonShape $shape, LoaderSkeletonSize $size, string $width = '') => Skeleton::drawLoaderSkeleton(
            $shape,
            $size,
            $theme,
            $animation,
            $width
        );

        return static::draw([
            'theme' => $theme->value,
            'className' => $className,
            'avatar' => $block(LoaderSkeletonShape::Circle, LoaderSkeletonSize::Medium),
            'title' => $block(LoaderSkeletonShape::Text, LoaderSkeletonSize::Medium, '60%'),
            'line' => $block(LoaderSkeletonShape::Text, LoaderSkeletonSize::Small, '40%'),
            'image' => $block(LoaderSkeletonShape::Rect, LoaderSkeletonSize::Large, '100%'),
        ]);
    }
}

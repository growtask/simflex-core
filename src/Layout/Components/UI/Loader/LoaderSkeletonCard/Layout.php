<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderSkeletonCard;

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\Layout as Skeleton;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonShape;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Карточка-заглушка (Figma Loaders/skeleton-card): аватар, две строки и картинка из LoaderSkeleton; скрыта от скринридера (aria-hidden)
 */
class Layout extends LayoutBase
{
    /** Карточка-заглушка: аватар, две строки и картинка */
    public static function drawSkeletonCard(
        SkeletonTheme $theme = SkeletonTheme::Light,
        bool          $animation = true,
        string        $className = '',
    ): string {
        $block = static fn(SkeletonShape $shape, SkeletonSize $size, string $width = '') => Skeleton::drawSkeleton(
            $shape,
            $size,
            $theme,
            $animation,
            $width
        );

        return static::draw([
            'theme' => $theme->value,
            'className' => $className,
            'avatar' => $block(SkeletonShape::Circle, SkeletonSize::Medium),
            'title' => $block(SkeletonShape::Text, SkeletonSize::Medium, '60%'),
            'line' => $block(SkeletonShape::Text, SkeletonSize::Small, '40%'),
            'image' => $block(SkeletonShape::Rect, SkeletonSize::Large, '100%'),
        ]);
    }
}

<?php

/**
 * Демо LoaderSkeletonCard: с анимацией и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeletonCard\Layout as SkeletonCard;

$skeletonTheme = LoaderSkeletonTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?= SkeletonCard::drawLoaderSkeletonCard($skeletonTheme) ?>
    <?= SkeletonCard::drawLoaderSkeletonCard($skeletonTheme, animation: false) ?>
</div>

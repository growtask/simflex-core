<?php

/**
 * Демо LoaderSkeletonCard: с анимацией и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonTheme;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeletonCard\Layout as SkeletonCard;

$skeletonTheme = SkeletonTheme::from($theme);

?>
<div class="ui-showcase__row">
    <?= SkeletonCard::drawSkeletonCard($skeletonTheme) ?>
    <?= SkeletonCard::drawSkeletonCard($skeletonTheme, animation: false) ?>
</div>

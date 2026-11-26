<?php

/**
 * Демо LoaderSkeleton: форма × размер, без анимации (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\Layout as Skeleton;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonShape;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\SkeletonTheme;

$skeletonTheme = SkeletonTheme::from($theme);

?>
<?php foreach (SkeletonShape::cases() as $shape): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $shape->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (SkeletonSize::cases() as $size): ?>
            <?= Skeleton::drawSkeleton($shape, $size, $skeletonTheme) ?>
            <?= Skeleton::drawSkeleton($shape, $size, $skeletonTheme, animation: false) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<?php

/**
 * Демо LoaderSkeleton: форма × размер, без анимации (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\Layout as Skeleton;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonShape;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderSkeleton\LoaderSkeletonTheme;

$skeletonTheme = LoaderSkeletonTheme::from($theme);

?>
<?php foreach (LoaderSkeletonShape::cases() as $shape): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $shape->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LoaderSkeletonSize::cases() as $size): ?>
            <?= Skeleton::drawLoaderSkeleton($shape, $size, $skeletonTheme) ?>
            <?= Skeleton::drawLoaderSkeleton($shape, $size, $skeletonTheme, animation: false) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

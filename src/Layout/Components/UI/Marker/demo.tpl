<?php

/**
 * Демо Marker: размеры × стили, с иконкой и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Marker\Layout as Marker;
use Simflex\Core\Layout\Components\UI\Marker\MarkerSize;
use Simflex\Core\Layout\Components\UI\Marker\MarkerStyle;
use Simflex\Core\Layout\Components\UI\Marker\MarkerTheme;

$markerTheme = MarkerTheme::from($theme);

?>
<?php foreach (MarkerSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (MarkerStyle::cases() as $style): ?>
            <?= Marker::drawMarker(
                size: $size,
                style: $style,
                theme: $markerTheme,
                label: $style->name,
            ) ?>
            <?= Marker::drawMarker(
                icon: 'check',
                size: $size,
                style: $style,
                theme: $markerTheme,
                label: $style->name . ', иконка',
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

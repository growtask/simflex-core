<?php

/**
 * Демо TabHeading: размеры × стили, активный, отключённый, со счётчиком (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabHeading\Layout as TabHeading;
use Simflex\Core\Layout\Components\UI\Tab\TabHeading\TabHeadingSize;
use Simflex\Core\Layout\Components\UI\Tab\TabHeading\TabHeadingStyle;

$tabTheme = TabMainTheme::from($theme);

?>
<?php foreach (TabHeadingSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TabHeadingStyle::cases() as $style): ?>
            <?= TabHeading::drawTabHeading(text: $style->name, badge: '12', style: $style, size: $size, theme: $tabTheme) ?>
            <?= TabHeading::drawTabHeading(text: 'active', badge: '12', style: $style, size: $size, theme: $tabTheme, active: true) ?>
            <?= TabHeading::drawTabHeading(text: 'no badge', style: $style, size: $size, theme: $tabTheme) ?>
            <?= TabHeading::drawTabHeading(text: 'disabled', style: $style, size: $size, theme: $tabTheme, disabled: true) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

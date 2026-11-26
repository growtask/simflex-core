<?php

/**
 * Демо TabMarker: размеры × стили, активный, отключённый, без описания и бейджа, свой слот (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMarker\Layout as TabMarker;
use Simflex\Core\Layout\Components\UI\Tab\TabMarker\TabMarkerSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMarker\TabMarkerStyle;

$tabTheme = TabTheme::from($theme);

?>
<?php foreach (TabMarkerSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <?php foreach (TabMarkerStyle::cases() as $style): ?>
        <div class="ui-showcase__row">
            <?= TabMarker::drawTabMarker(
                text: $style->name,
                description: 'Description',
                icon: 'check',
                badge: '3',
                iconRight: 'chevron-m-down',
                style: $style,
                size: $size,
                theme: $tabTheme,
            ) ?>
            <?= TabMarker::drawTabMarker(
                text: 'active',
                description: 'Description',
                icon: 'check',
                iconRight: 'chevron-m-down',
                style: $style,
                size: $size,
                theme: $tabTheme,
                active: true,
            ) ?>
            <?= TabMarker::drawTabMarker(
                text: 'disabled',
                description: 'Description',
                icon: 'check',
                style: $style,
                size: $size,
                theme: $tabTheme,
                disabled: true,
            ) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без описания, без слота, свой слот</h3>
<div class="ui-showcase__row">
    <?= TabMarker::drawTabMarker(text: 'Без описания', icon: 'check', theme: $tabTheme) ?>
    <?= TabMarker::drawTabMarker(text: 'Без слота', description: 'Description', iconRight: 'chevron-m-down', theme: $tabTheme) ?>
    <?= TabMarker::drawTabMarker(
        text: 'Свой слот',
        description: 'Любой HTML слева',
        slot: '<strong>Pro</strong>',
        link: '#tab-marker',
        theme: $tabTheme,
    ) ?>
</div>

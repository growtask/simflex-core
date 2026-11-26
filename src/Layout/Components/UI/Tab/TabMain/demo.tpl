<?php

/**
 * Демо Tab: размеры × стили, активная, с иконками и бейджем, отключённая (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme;

$tabTheme = TabTheme::from($theme);

?>
<?php foreach (TabSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TabStyle::cases() as $style): ?>
            <?= Tab::drawTab(text: $style->name, style: $style, size: $size, theme: $tabTheme) ?>
            <?= Tab::drawTab(text: 'active', style: $style, size: $size, theme: $tabTheme, active: true) ?>
            <?= Tab::drawTab(text: 'disabled', style: $style, size: $size, theme: $tabTheme, disabled: true) ?>
        <?php endforeach; ?>
    </div>
    <div class="ui-showcase__row">
        <?php foreach (TabStyle::cases() as $style): ?>
            <?= Tab::drawTab(
                text: 'Иконки',
                iconLeft: 'home',
                iconRight: 'chevron-s-down',
                badge: '5',
                style: $style,
                size: $size,
                theme: $tabTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

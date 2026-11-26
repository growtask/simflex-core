<?php

/**
 * Демо TabDisabled: стиль × размер, с иконками и бейджем (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabDisabled\Layout as TabDisabled;

$tabTheme = TabMainTheme::from($theme);

?>
<?php foreach (TabMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TabMainStyle::cases() as $style): ?>
            <?= TabDisabled::drawTabDisabled('Раздел', style: $style, size: $size, theme: $tabTheme) ?>
            <?= TabDisabled::drawTabDisabled('С иконкой', iconLeft: 'plus', badge: '3', style: $style, size: $size, theme: $tabTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

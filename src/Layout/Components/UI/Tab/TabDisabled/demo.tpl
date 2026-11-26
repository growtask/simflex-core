<?php

/**
 * Демо TabDisabled: стиль × размер, с иконками и бейджем (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabDisabled\Layout as TabDisabled;

$tabTheme = TabTheme::from($theme);

?>
<?php foreach (TabSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TabStyle::cases() as $style): ?>
            <?= TabDisabled::drawTabDisabled('Раздел', style: $style, size: $size, theme: $tabTheme) ?>
            <?= TabDisabled::drawTabDisabled('С иконкой', iconLeft: 'plus', badge: '3', style: $style, size: $size, theme: $tabTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

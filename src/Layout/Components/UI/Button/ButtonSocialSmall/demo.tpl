<?php

/**
 * Демо Social: размеры × стили, все соцсети (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallTheme;

$socialTheme = ButtonSocialSmallTheme::from($theme);

?>
<?php foreach (ButtonSocialSmallSize::cases() as $size): ?>
    <?php foreach (ButtonSocialSmallStyle::cases() as $style): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?>, <?= $style->name ?></h3>
        <div class="ui-showcase__row">
            <?php foreach (ButtonSocialSmallNetwork::cases() as $network): ?>
                <?= Social::drawButtonSocialSmall(
                    network: $network,
                    href: '#' . $network->value,
                    style: $style,
                    size: $size,
                    theme: $socialTheme,
                ) ?>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

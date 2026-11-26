<?php

/**
 * Демо Social: размеры × стили, все соцсети (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialTheme;

$socialTheme = SocialTheme::from($theme);

?>
<?php foreach (SocialSize::cases() as $size): ?>
    <?php foreach (SocialStyle::cases() as $style): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?>, <?= $style->name ?></h3>
        <div class="ui-showcase__row">
            <?php foreach (SocialNetwork::cases() as $network): ?>
                <?= Social::drawSocial(
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

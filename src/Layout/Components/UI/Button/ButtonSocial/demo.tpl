<?php

/**
 * Демо ButtonSocial: форма × размер × все стили (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonSocial\ButtonSocialSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocial\ButtonSocialStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocial\ButtonSocialTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocial\ButtonSocialType;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocial\Layout as ButtonSocial;

$socialTheme = ButtonSocialTheme::from($theme);

?>
<?php foreach (ButtonSocialType::cases() as $type): ?>
    <?php foreach (ButtonSocialSize::cases() as $size): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $type->name ?>, <?= $size->name ?></h3>
        <div class="ui-showcase__row">
            <?php foreach (ButtonSocialStyle::cases() as $style): ?>
                <?= ButtonSocial::drawButtonSocial(style: $style, type: $type, size: $size, theme: $socialTheme) ?>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

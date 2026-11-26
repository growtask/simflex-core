<?php

/**
 * Демо Logo: все типы логотипа, с подписью и без (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Other\Logo\Layout as Logo;
use Simflex\Core\Layout\Components\UI\Other\Logo\LogoTheme;
use Simflex\Core\Layout\Components\UI\Other\Logo\LogoType;

$logoTheme = LogoTheme::from($theme);

?>
<?php foreach (LogoType::cases() as $type): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $type->name ?></h3>
    <div class="ui-showcase__row">
        <?= Logo::drawLogo(name: 'Мой сайт', caption: 'Shop', type: $type, theme: $logoTheme) ?>
        <?= Logo::drawLogo(name: 'Мой сайт', text: false, type: $type, theme: $logoTheme) ?>
    </div>
<?php endforeach; ?>

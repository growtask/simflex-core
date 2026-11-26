<?php

/**
 * Демо Link: размеры × стили, с иконками, внешняя ссылка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainTheme;

$linkTheme = LinkMainTheme::from($theme);

?>
<?php foreach (LinkMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LinkMainStyle::cases() as $style): ?>
            <?= Link::drawLinkMain(text: $style->name, href: '#link', style: $style, size: $size, theme: $linkTheme) ?>
            <?= Link::drawLinkMain(
                text: 'С иконками',
                href: '#link',
                iconLeft: 'home',
                iconRight: 'arrow-right',
                style: $style,
                size: $size,
                theme: $linkTheme,
            ) ?>
            <?= Link::drawLinkMain(
                text: 'Внешняя',
                href: 'https://example.com',
                external: true,
                style: $style,
                size: $size,
                theme: $linkTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

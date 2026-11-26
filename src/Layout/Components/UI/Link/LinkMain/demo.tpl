<?php

/**
 * Демо Link: размеры × стили, с иконками, внешняя ссылка (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkTheme;

$linkTheme = LinkTheme::from($theme);

?>
<?php foreach (LinkSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LinkStyle::cases() as $style): ?>
            <?= Link::drawLink(text: $style->name, href: '#link', style: $style, size: $size, theme: $linkTheme) ?>
            <?= Link::drawLink(
                text: 'С иконками',
                href: '#link',
                iconLeft: 'home',
                iconRight: 'arrow-right',
                style: $style,
                size: $size,
                theme: $linkTheme,
            ) ?>
            <?= Link::drawLink(
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

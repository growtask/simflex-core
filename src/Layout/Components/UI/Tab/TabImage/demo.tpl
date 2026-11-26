<?php

/**
 * Демо TabImage: размеры × стили, активный, отключённый, с картинкой и иконкой (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabImage\Layout as TabImage;
use Simflex\Core\Layout\Components\UI\Tab\TabImage\TabImageSize;
use Simflex\Core\Layout\Components\UI\Tab\TabImage\TabImageStyle;

$tabTheme = TabMainTheme::from($theme);
// встроенная картинка (градиент), чтобы демо не зависело от файлов
$picture = 'data:image/svg+xml,' . rawurlencode(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">'
    . '<stop offset="0" stop-color="#7fa8e6"/><stop offset="1" stop-color="#d2e2f7"/></linearGradient></defs>'
    . '<rect width="64" height="64" fill="url(#g)"/></svg>'
);

?>
<?php foreach (TabImageSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <?php foreach (TabImageStyle::cases() as $style): ?>
        <div class="ui-showcase__row">
            <?= TabImage::drawTabImage(
                text: $style->name,
                description: 'Description',
                image: $picture,
                badge: '3',
                iconRight: 'chevron-m-down',
                style: $style,
                size: $size,
                theme: $tabTheme,
            ) ?>
            <?= TabImage::drawTabImage(
                text: 'active',
                description: 'Description',
                image: $picture,
                iconRight: 'chevron-m-down',
                style: $style,
                size: $size,
                theme: $tabTheme,
                active: true,
            ) ?>
            <?= TabImage::drawTabImage(
                text: 'disabled',
                description: 'Description',
                image: $picture,
                style: $style,
                size: $size,
                theme: $tabTheme,
                disabled: true,
            ) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Иконка вместо картинки, без описания</h3>
<div class="ui-showcase__row">
    <?= TabImage::drawTabImage(text: 'Иконка', description: 'Description', icon: 'home', theme: $tabTheme) ?>
    <?= TabImage::drawTabImage(text: 'Без описания', image: $picture, link: '#tab-image', theme: $tabTheme) ?>
</div>

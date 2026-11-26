<?php

/**
 * Демо Tag: размеры × стили, с иконкой и закрытием (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Tag\TagSize;
use Simflex\Core\Layout\Components\UI\Tag\TagStyle;
use Simflex\Core\Layout\Components\UI\Tag\TagTheme;

$tagTheme = TagTheme::from($theme);

?>
<?php foreach (TagSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TagStyle::cases() as $style): ?>
            <?= Tag::drawTag(text: $style->name, style: $style, size: $size, theme: $tagTheme) ?>
            <?= Tag::drawTag(
                text: 'с иконкой',
                style: $style,
                size: $size,
                theme: $tagTheme,
                icon: 'filter',
                close: true,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

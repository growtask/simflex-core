<?php

/**
 * Демо PlaceholderAvatar: аватары всех размеров и стилей, заглушка изображения (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\AvatarSize;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\AvatarStyle;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\Layout as Placeholder;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\AvatarTheme;

$placeholderTheme = AvatarTheme::from($theme);

?>
<?php foreach (AvatarStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m">Аватар: <?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (AvatarSize::cases() as $size): ?>
            <?= Placeholder::drawAvatar('Иван Петров', size: $size, style: $style, theme: $placeholderTheme) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Нет изображения</h3>
<div class="ui-showcase__row">
    <span class="ui-showcase__image"><?= Placeholder::drawNoImage(theme: $placeholderTheme) ?></span>
</div>

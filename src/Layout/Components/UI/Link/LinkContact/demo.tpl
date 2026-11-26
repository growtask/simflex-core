<?php

/**
 * Демо Contact: типы × стили × размеры (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactTheme;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;

$contactTheme = LinkContactTheme::from($theme);
$values = [
    LinkContactType::Phone->value => '+7 (999) 123-45-67',
    LinkContactType::Email->value => 'info@example.com',
    LinkContactType::Custom->value => '#custom',
];

?>
<?php foreach (LinkContactSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (LinkContactStyle::cases() as $style): ?>
            <?php foreach (LinkContactType::cases() as $type): ?>
                <?= Contact::drawLinkContact(
                    text: $style->name . ', ' . $type->name,
                    value: $values[$type->value],
                    type: $type,
                    style: $style,
                    size: $size,
                    theme: $contactTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

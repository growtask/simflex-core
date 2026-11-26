<?php

/**
 * Демо Contact: типы × стили × размеры (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactTheme;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;

$contactTheme = ContactTheme::from($theme);
$values = [
    ContactType::Phone->value => '+7 (999) 123-45-67',
    ContactType::Email->value => 'info@example.com',
    ContactType::Custom->value => '#custom',
];

?>
<?php foreach (ContactSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ContactStyle::cases() as $style): ?>
            <?php foreach (ContactType::cases() as $type): ?>
                <?= Contact::drawContact(
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

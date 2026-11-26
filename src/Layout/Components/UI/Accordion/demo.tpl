<?php

/**
 * Демо Accordion: размеры × стили, поля иконка, подзаголовок, комментарий и бейдж (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Accordion\AccordionSize;
use Simflex\Core\Layout\Components\UI\Accordion\AccordionStyle;
use Simflex\Core\Layout\Components\UI\Accordion\AccordionTheme;
use Simflex\Core\Layout\Components\UI\Accordion\Layout as Accordion;

$accordionTheme = AccordionTheme::from($theme);
$description = '<p>Содержимое раскрытого блока: любой HTML.</p>';

?>
<?php foreach (AccordionSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <?php foreach (AccordionStyle::cases() as $style): ?>
        <ul class="ui-showcase__list">
            <?= Accordion::drawAccordion(
                title: $style->name,
                description: $description,
                style: $style,
                size: $size,
                theme: $accordionTheme,
            ) ?>
            <?= Accordion::drawAccordion(
                title: $style->name . ', все поля',
                subtitle: 'Подзаголовок',
                comment: 'Комментарий',
                badge: 'Бейдж',
                icon: 'check',
                description: $description,
                style: $style,
                size: $size,
                theme: $accordionTheme,
            ) ?>
        </ul>
    <?php endforeach; ?>
<?php endforeach; ?>

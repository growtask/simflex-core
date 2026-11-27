<?php

/**
 * Демо ItemBenefit: размеры, иконка и число, вертикально и горизонтально, по левому краю и по центру, карточка,
 * ссылка, линия и бейдж (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitAlign;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitLayout;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitSize;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitTheme;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitType;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\Layout as Benefit;

$benefitTheme = ItemBenefitTheme::from($theme);
$items = [
    ['title' => 'Бесплатная доставка', 'text' => 'При заказе от 3000 ₽ привезём в удобное время', 'icon' => 'truck', 'number' => '01'],
    ['title' => 'Поддержка 24/7', 'text' => 'Ответим в чате и по телефону в любое время', 'icon' => 'messages-circle', 'number' => '02',
        'link' => ['text' => 'Написать', 'href' => '#chat']],
    ['title' => '10 лет на рынке', 'text' => 'Работаем с 2016 года, больше 40 000 клиентов', 'icon' => 'star', 'number' => '03',
        'badge' => 'Новое'],
];

?>
<?php foreach (ItemBenefitLayout::cases() as $layout): ?>
    <?php foreach (ItemBenefitAlign::cases() as $align): ?>
        <?php if ($layout === ItemBenefitLayout::Horizontal && $align === ItemBenefitAlign::Center) { continue; } ?>
        <?php foreach (ItemBenefitType::cases() as $type): ?>
            <h3 class="ui-showcase__subtitle ui-m"><?= $layout->name ?>, <?= $align->name ?>, <?= $type->name ?></h3>
            <?php foreach (ItemBenefitSize::cases() as $size): ?>
                <?= Benefit::drawItemBenefitList(
                    items: $items,
                    className: 'ui-showcase__row',
                    size: $size,
                    type: $type,
                    layout: $layout,
                    align: $align,
                    theme: $benefitTheme,
                ) ?>
            <?php endforeach; ?>
        <?php endforeach; ?>
    <?php endforeach; ?>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Карточка (card) и без линии (line)</h3>
<?= Benefit::drawItemBenefitList(items: $items, className: 'ui-showcase__row', card: true, theme: $benefitTheme) ?>
<ul class="ui-showcase__row">
    <?= Benefit::drawItemBenefit(title: 'Без линии', text: 'Знак без линии рядом', icon: 'check', line: false, theme: $benefitTheme) ?>
    <?= Benefit::drawItemBenefit(title: 'Без знака', text: 'Только заголовок и текст', line: false, theme: $benefitTheme) ?>
</ul>

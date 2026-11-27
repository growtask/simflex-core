<?php

/**
 * Демо Tab: размеры × стили, активная, с иконками и бейджем, отключённая (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;

$tabTheme = TabMainTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Группа вкладок: клик, стрелки, Home/End; подложка переезжает к новой</h3>
<?php foreach (TabMainStyle::cases() as $style): ?>
    <div class="ui-showcase__row" data-sf-tabs role="tablist" aria-label="Вкладки <?= $style->name ?>">
        <?php foreach (['Описание', 'Характеристики', 'Отзывы', 'Доставка'] as $i => $text): ?>
            <?= Tab::drawTabMain(
                text: $text,
                style: $style,
                size: TabMainSize::Medium,
                theme: $tabTheme,
                active: $i === 0,
                disabled: $i === 3,
                attributes: ['role' => 'tab'],
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>
<?php foreach (TabMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (TabMainStyle::cases() as $style): ?>
            <?= Tab::drawTabMain(text: $style->name, style: $style, size: $size, theme: $tabTheme) ?>
            <?= Tab::drawTabMain(text: 'active', style: $style, size: $size, theme: $tabTheme, active: true) ?>
            <?= Tab::drawTabMain(text: 'disabled', style: $style, size: $size, theme: $tabTheme, disabled: true) ?>
        <?php endforeach; ?>
    </div>
    <div class="ui-showcase__row">
        <?php foreach (TabMainStyle::cases() as $style): ?>
            <?= Tab::drawTabMain(
                text: 'Иконки',
                iconLeft: 'home',
                iconRight: 'chevron-s-down',
                badge: '5',
                style: $style,
                size: $size,
                theme: $tabTheme,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

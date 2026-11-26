<?php

/**
 * Демо NavPagination: типы, положения текущей страницы, переход на страницу (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Nav\NavPagination\Layout as NavPagination;
use Simflex\Core\Layout\Components\Base\Nav\NavPagination\NavPaginationTheme;
use Simflex\Core\Layout\Components\Base\Nav\NavPagination\NavPaginationType;

$theme = NavPaginationTheme::from($theme);
$positions = ['Первая' => 1, 'Середина' => 10, 'Последняя' => 20];

?>
<?php foreach (NavPaginationType::cases() as $type): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $type->name ?></h3>
    <?php foreach ($positions as $title => $page): ?>
        <div class="ui-showcase__row">
            <?= NavPagination::drawNavPagination(
                $page,
                20,
                '#page-{page}',
                type: $type,
                theme: $theme,
                search: false,
                caption: $page . '0 из 200',
            ) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">С переходом на страницу</h3>
<div class="ui-showcase__row">
    <?= NavPagination::drawNavPagination(10, 20, '#page-{page}', theme: $theme) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Мало страниц</h3>
<div class="ui-showcase__row">
    <?= NavPagination::drawNavPagination(2, 5, '#page-{page}', theme: $theme, search: false) ?>
</div>

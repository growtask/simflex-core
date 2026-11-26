<?php

/**
 * Демо Dropdown: список во всех размерах, список с поиском, отключённый, меню (выравнивание × положение)
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainAlign;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainPosition;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as Dropdown;

$dropdownTheme = DropdownMainTheme::from($theme);
$statuses = ['new' => 'Новый', 'work' => 'В работе', 'done' => 'Выполнен', 'cancel' => 'Отменён'];
$cities = array_combine(
    range(1, 12),
    ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань', 'Нижний Новгород',
        'Челябинск', 'Самара', 'Омск', 'Ростов-на-Дону', 'Уфа', 'Красноярск']
);
$menuItems = [
    ['text' => 'Редактировать', 'icon' => 'pencil-line', 'link' => '#edit'],
    ['text' => 'Копировать', 'icon' => 'copy'],
    ['text' => 'Удалить', 'icon' => 'trash'],
];

?>
<?php foreach (DropdownMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m">Список: <?= $size->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <span class="ui-showcase__field">
            <?= Dropdown::drawDropdownMainSelect(
                'ui_status_' . $size->name . '_' . $theme,
                $statuses,
                'work',
                size: $size,
                theme: $dropdownTheme,
                attributes: ['aria-label' => 'Статус'],
            ) ?>
        </span>
        <span class="ui-showcase__field">
            <?= Dropdown::drawDropdownMainSelect(
                'ui_city_' . $size->name . '_' . $theme,
                $cities,
                placeholder: 'Город с поиском',
                size: $size,
                theme: $dropdownTheme,
                search: true,
                attributes: ['aria-label' => 'Город'],
            ) ?>
        </span>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Прокрутка списка (scroll)</h3>
<div class="ui-showcase__row ui-showcase__row_dropdowns">
    <span class="ui-showcase__field">
        <?= Dropdown::drawDropdownMainSelect(
            'ui_scroll_on_' . $theme,
            $cities,
            placeholder: 'С прокруткой',
            theme: $dropdownTheme,
            attributes: ['aria-label' => 'Город'],
        ) ?>
    </span>
    <span class="ui-showcase__field">
        <?= Dropdown::drawDropdownMainSelect(
            'ui_scroll_off_' . $theme,
            $statuses,
            placeholder: 'Без прокрутки',
            theme: $dropdownTheme,
            scroll: false,
            attributes: ['aria-label' => 'Статус'],
        ) ?>
    </span>
</div>

<h3 class="ui-showcase__subtitle ui-m">Отключённый список</h3>
<div class="ui-showcase__row">
    <span class="ui-showcase__field">
        <?= Dropdown::drawDropdownMainSelect(
            'ui_disabled_' . $theme,
            $statuses,
            'work',
            theme: $dropdownTheme,
            disabled: true,
            attributes: ['aria-label' => 'Статус'],
        ) ?>
    </span>
</div>

<?php foreach (DropdownMainPosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Меню: <?= $position->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <?php foreach (DropdownMainAlign::cases() as $align): ?>
            <?= Dropdown::drawDropdownMainMenu(
                ButtonIcon::drawButtonIconSmall(
                    icon: 'dots-vertical',
                    label: 'Ещё, ' . $align->name,
                    style: ButtonIconSmallStyle::Secondary,
                    theme: ButtonIconSmallTheme::from($theme),
                ),
                $menuItems,
                theme: $dropdownTheme,
                align: $align,
                position: $position,
                side: 'left',
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

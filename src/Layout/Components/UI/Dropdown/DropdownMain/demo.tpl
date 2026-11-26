<?php

/**
 * Демо Dropdown: список во всех размерах, список с поиском, отключённый, меню (выравнивание × положение)
 * (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownAlign;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownPosition;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as Dropdown;

$dropdownTheme = DropdownTheme::from($theme);
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
<?php foreach (DropdownSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m">Список: <?= $size->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <span class="ui-showcase__field">
            <?= Dropdown::drawSelect(
                'ui_status_' . $size->name . '_' . $theme,
                $statuses,
                'work',
                size: $size,
                theme: $dropdownTheme,
                attributes: ['aria-label' => 'Статус'],
            ) ?>
        </span>
        <span class="ui-showcase__field">
            <?= Dropdown::drawSelect(
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
        <?= Dropdown::drawSelect(
            'ui_scroll_on_' . $theme,
            $cities,
            placeholder: 'С прокруткой',
            theme: $dropdownTheme,
            attributes: ['aria-label' => 'Город'],
        ) ?>
    </span>
    <span class="ui-showcase__field">
        <?= Dropdown::drawSelect(
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
        <?= Dropdown::drawSelect(
            'ui_disabled_' . $theme,
            $statuses,
            'work',
            theme: $dropdownTheme,
            disabled: true,
            attributes: ['aria-label' => 'Статус'],
        ) ?>
    </span>
</div>

<?php foreach (DropdownPosition::cases() as $position): ?>
    <h3 class="ui-showcase__subtitle ui-m">Меню: <?= $position->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <?php foreach (DropdownAlign::cases() as $align): ?>
            <?= Dropdown::drawMenu(
                ButtonIcon::drawButtonIcon(
                    icon: 'dots-vertical',
                    label: 'Ещё, ' . $align->name,
                    style: ButtonIconStyle::Secondary,
                    theme: ButtonIconTheme::from($theme),
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

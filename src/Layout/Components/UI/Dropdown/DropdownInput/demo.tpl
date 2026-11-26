<?php

/**
 * Демо DropdownInput: размер, с поиском и недоступное (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownInput\Layout as DropdownInput;

$dropdownTheme = DropdownMainTheme::from($theme);
$options = ['red' => 'Красный', 'green' => 'Зелёный', 'blue' => 'Синий'];

?>
<?php foreach (DropdownMainSize::cases() as $size): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $size->name ?></h3>
    <div class="ui-showcase__row ui-showcase__row_dropdowns">
        <span class="ui-showcase__field"><?= DropdownInput::drawDropdownInput('color-' . $size->value, $options, size: $size, theme: $dropdownTheme, attributes: ['aria-label' => 'Цвет']) ?></span>
        <span class="ui-showcase__field"><?= DropdownInput::drawDropdownInput('color-s-' . $size->value, $options, 'green', size: $size, theme: $dropdownTheme, search: true, attributes: ['aria-label' => 'Цвет']) ?></span>
        <span class="ui-showcase__field"><?= DropdownInput::drawDropdownInput('color-d-' . $size->value, $options, size: $size, theme: $dropdownTheme, disabled: true, attributes: ['aria-label' => 'Цвет']) ?></span>
    </div>
<?php endforeach; ?>

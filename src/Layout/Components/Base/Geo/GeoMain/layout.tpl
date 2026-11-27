<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Geo\GeoList\GeoListStyle;
use Simflex\Core\Layout\Components\Base\Geo\GeoList\GeoListTheme;
use Simflex\Core\Layout\Components\Base\Geo\GeoList\Layout as GeoList;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$state = $data['state'];
$search = in_array($state, ['choice', 'dropdown', 'selected', 'empty'], true);
$shown = $state === 'active' && $data['city'] !== '' ? $data['city'] : $data['guess'];
$buttonTheme = ButtonMainTheme::from($data['theme']);
$button = static fn(string $text, ButtonMainStyle $style, array $attrs, bool $hidden, string $class = ''): string => Button::drawButtonMain(
    className: $class,
    text: $text,
    style: $style,
    size: ButtonMainSize::Small,
    theme: $buttonTheme,
    attributes: $attrs + ($hidden ? ['hidden' => ''] : []),
    disabled: ($attrs['data-sf-geo-save'] ?? null) !== null && $state !== 'selected',
);
$listOpen = in_array($state, ['dropdown', 'empty'], true);
$cities = $data['cities'];
if ($state === 'dropdown' && $data['query'] !== '') {
    $q = mb_strtolower($data['query']);
    $cities = array_values(array_filter($cities, static fn($c) => str_contains(mb_strtolower($c), $q)));
}
$classes = ['geo-main', "geo-main-theme_{$data['theme']}", $data['style'] === 'mobile' ? 'geo-main-screen_mobile' : '',
    $data['className']];
?>
<div class="<?= $esc(implode(' ', array_filter($classes))) ?>" data-sf-geo-main data-state="<?= $esc($state) ?>">
    <p class="geo-main__question">
        <span>Ваш город:</span>
        <span class="geo-main__city" data-sf-geo-city <?= $search ? 'hidden' : '' ?>><?= $esc($shown) ?><?= $state === 'static' ? '?' : '' ?></span>
    </p>
    <div class="geo-main__search" <?= $search ? '' : 'hidden' ?> data-sf-geo-search>
        <?= TextInput::drawInputMain(
            placeholder: 'Ваш город',
            labelText: 'Поиск города',
            size: InputMainSize::Small,
            theme: InputMainTheme::from($data['theme']),
            icon: 'search',
            attributes: [
                'type' => 'search',
                'autocomplete' => 'off',
                'role' => 'combobox',
                'aria-autocomplete' => 'list',
                'aria-expanded' => $listOpen ? 'true' : 'false',
                'aria-controls' => $data['id'] . '-list',
                'data-sf-geo-input' => '',
            ],
            value: $data['query'],
            counter: true,
            maxLength: 50,
        ) ?>
        <?= GeoList::drawGeoList(
            cities: $cities,
            id: $data['id'] . '-list',
            style: $data['style'] === 'mobile' ? GeoListStyle::Mobile : GeoListStyle::Desktop,
            theme: GeoListTheme::from($data['theme']),
            empty: $state === 'empty',
            hidden: !$listOpen,
        ) ?>
    </div>
    <div class="geo-main__actions">
        <?= $button('Да', ButtonMainStyle::Gray, ['data-sf-geo-yes' => ''], $state !== 'static', 'geo-main__action_primary') ?>
        <?= $button('Нет', ButtonMainStyle::Secondary, ['data-sf-geo-no' => ''], $state !== 'static') ?>
        <?= $button('Изменить', ButtonMainStyle::Secondary, ['data-sf-geo-no' => ''], $state !== 'active') ?>
        <?= $button('Принять', ButtonMainStyle::Gray, ['data-sf-geo-yes' => ''], $state !== 'active', 'geo-main__action_primary') ?>
        <?= $button('Сохранить', ButtonMainStyle::Gray, ['data-sf-geo-save' => ''], !$search, 'geo-main__action_primary') ?>
    </div>
</div>

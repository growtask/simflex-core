<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\ToggleSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\ToggleTheme;

$id = 'sf-cookie-' . substr(md5(uniqid('', true)), 0, 6);
$theme = $data['theme'];
$classes = [
    'cookie',
    "cookie-state_{$data['state']}",
    "cookie-theme_{$theme}",
    "cookie-position_{$data['position']}",
    $data['inline'] ? 'cookie_inline' : '',
    $data['className'],
];
$attributes = $data['attributes'] + ['role' => 'region', 'aria-labelledby' => "{$id}-title", 'data-sf-cookie' => ''];
$button = static fn (string $text, ButtonStyle $style, string $action, string $class) => Button::drawButton(
    className: $class,
    text: htmlspecialchars($text),
    style: $style,
    size: ButtonSize::Small,
    theme: ButtonTheme::from($theme),
    attributes: ['type' => 'button', 'data-sf-cookie-action' => $action],
);
?>
<section class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <div class="cookie__line" aria-hidden="true"></div>
    <div class="cookie__container">
        <div class="cookie__text">
            <p class="cookie__title cookie__only-default" id="<?= $id ?>-title"><?= htmlspecialchars($data['title']) ?></p>
            <p class="cookie__title cookie__only-settings"><?= htmlspecialchars($data['settingsTitle']) ?></p>
            <p class="cookie__desc cookie__only-default"><?= htmlspecialchars($data['text']) ?></p>
            <p class="cookie__desc cookie__only-settings"><?= htmlspecialchars($data['settingsText']) ?></p>
            <fieldset class="cookie__list cookie__only-settings">
                <legend class="visually-hidden"><?= htmlspecialchars($data['settingsTitle']) ?></legend>
                <?php foreach ($data['categories'] as $category): ?>
                    <?= Toggle::drawToggle(
                        text: htmlspecialchars($category['text']),
                        size: ToggleSize::Small,
                        theme: ToggleTheme::from($theme),
                        attributes: ['name' => 'cookie-' . $category['key']]
                            + (!empty($category['required']) ? ['checked' => 'checked', 'aria-disabled' => 'true'] : []),
                    ) ?>
                <?php endforeach; ?>
            </fieldset>
            <?php if ($data['policyUrl'] !== ''): ?>
                <p class="cookie__more">
                    <span>Подробнее в</span>
                    <?= Link::drawLink(
                        className: 'cookie__policy',
                        text: 'политике обработки персональных данных',
                        href: $data['policyUrl'],
                        size: LinkSize::Small,
                        theme: LinkTheme::from($theme),
                    ) ?>
                </p>
            <?php endif; ?>
        </div>
        <div class="cookie__actions cookie__only-default">
            <?= $button('Принять все', ButtonStyle::Gray, 'accept', 'cookie__accept') ?>
            <?= $button('Настройки', ButtonStyle::Monochrome, 'settings', 'cookie__settings') ?>
            <?= $button('Отклонить', ButtonStyle::Flat, 'decline', 'cookie__decline') ?>
        </div>
        <div class="cookie__actions cookie__only-settings">
            <?= $button('Сохранить выбор', ButtonStyle::Gray, 'save', 'cookie__save') ?>
            <?= $button('Принять все', ButtonStyle::Monochrome, 'accept', 'cookie__accept') ?>
        </div>
    </div>
</section>

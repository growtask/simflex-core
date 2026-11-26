<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleTheme;

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
$button = static fn (string $text, ButtonMainStyle $style, string $action, string $class) => Button::drawButtonMain(
    className: $class,
    text: htmlspecialchars($text),
    style: $style,
    size: ButtonMainSize::Small,
    theme: ButtonMainTheme::from($theme),
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
                    <?= Toggle::drawSwitchToggle(
                        text: htmlspecialchars($category['text']),
                        size: SwitchToggleSize::Small,
                        theme: SwitchToggleTheme::from($theme),
                        attributes: ['name' => 'cookie-' . $category['key']]
                            + (!empty($category['required']) ? ['checked' => 'checked', 'aria-disabled' => 'true'] : []),
                    ) ?>
                <?php endforeach; ?>
            </fieldset>
            <?php if ($data['policyUrl'] !== ''): ?>
                <p class="cookie__more">
                    <span>Подробнее в</span>
                    <?= Link::drawLinkMain(
                        className: 'cookie__policy',
                        text: 'политике обработки персональных данных',
                        href: $data['policyUrl'],
                        size: LinkMainSize::Small,
                        theme: LinkMainTheme::from($theme),
                    ) ?>
                </p>
            <?php endif; ?>
        </div>
        <div class="cookie__actions cookie__only-default">
            <?= $button('Принять все', ButtonMainStyle::Gray, 'accept', 'cookie__accept') ?>
            <?= $button('Настройки', ButtonMainStyle::Monochrome, 'settings', 'cookie__settings') ?>
            <?= $button('Отклонить', ButtonMainStyle::Flat, 'decline', 'cookie__decline') ?>
        </div>
        <div class="cookie__actions cookie__only-settings">
            <?= $button('Сохранить выбор', ButtonMainStyle::Gray, 'save', 'cookie__save') ?>
            <?= $button('Принять все', ButtonMainStyle::Monochrome, 'accept', 'cookie__accept') ?>
        </div>
    </div>
</section>

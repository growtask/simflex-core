<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Marker\Layout as Marker;
use Simflex\Core\Layout\Components\UI\Marker\MarkerSize;
use Simflex\Core\Layout\Components\UI\Marker\MarkerTheme;

$classes = ['states', "states-{$data['style']}", "states-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'];
if ($data['role'] !== '') {
    $attributes['role'] ??= $data['role'];
}
if ($data['style'] === 'load') {
    $attributes['aria-busy'] ??= 'true';
}
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <div class="states__container">
        <?= Marker::drawMarker(
            className: 'states__marker',
            size: MarkerSize::ExtraLarge,
            style: $data['markerStyle'],
            theme: MarkerTheme::from($data['theme']),
        ) ?>
        <div class="states__text">
            <<?= $data['titleTag'] ?> class="states__title"><?= htmlspecialchars($data['title']) ?></<?= $data['titleTag'] ?>>
            <?php if ($data['text'] !== ''): ?>
                <p class="states__desc"><?= htmlspecialchars($data['text']) ?></p>
            <?php endif; ?>
        </div>
        <?php if ($data['buttons']): ?>
            <div class="states__buttons">
                <?php if ($data['secondaryButton']): ?>
                    <?= Button::drawButtonMain(
                        className: 'states__button',
                        text: $data['secondaryText'],
                        link: $data['secondaryLink'],
                        style: ButtonMainStyle::Secondary,
                        theme: ButtonMainTheme::from($data['theme']),
                        attributes: $data['secondaryAttributes'],
                    ) ?>
                <?php endif; ?>
                <?= Button::drawButtonMain(
                    className: 'states__button',
                    text: $data['primaryText'],
                    link: $data['primaryLink'],
                    style: ButtonMainStyle::Primary,
                    theme: ButtonMainTheme::from($data['theme']),
                    attributes: $data['primaryAttributes'],
                ) ?>
            </div>
        <?php endif; ?>
    </div>
</div>

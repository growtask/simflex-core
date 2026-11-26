<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$classes = ['browser-support', "browser-support-theme_{$data['theme']}", $data['inline'] ? 'browser-support_inline' : '', $data['className']];
$attributes = $data['attributes'] + ['role' => 'region', 'aria-label' => 'Устаревший браузер'];
if ($data['check']) {
    $attributes += ['hidden' => 'hidden', 'data-sf-browser-support' => ''];
}
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <?= renderIcon('triangle-alert', 'browser-support__icon') ?>
    <p class="browser-support__text"><?= htmlspecialchars($data['text']) ?></p>
    <?php if ($data['buttonText'] !== '' && $data['buttonLink'] !== ''): ?>
        <?= Button::drawButton(
            className: 'browser-support__action',
            text: htmlspecialchars($data['buttonText']),
            link: $data['buttonLink'],
            style: ButtonStyle::Gray,
            size: ButtonSize::Small,
            theme: ButtonTheme::from($data['theme']),
        ) ?>
    <?php endif; ?>
</div>

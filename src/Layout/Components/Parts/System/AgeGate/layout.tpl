<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$id = 'sf-age-gate-' . substr(md5(uniqid('', true)), 0, 6);
$classes = ['age-gate', "age-gate-theme_{$data['theme']}", $data['inline'] ? 'age-gate_inline' : '', $data['className']];
$attributes = $data['attributes'] + ($data['inline'] ? [] : ['data-sf-age-gate' => '']);
$button = static fn (string $text, ButtonStyle $style, string $action) => Button::drawButton(
    className: "age-gate__{$action}",
    text: htmlspecialchars($text),
    style: $style,
    size: ButtonSize::Large,
    theme: ButtonTheme::from($data['theme']),
    attributes: ['type' => 'button', 'data-sf-age-gate-action' => $action],
);
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" <?= buildAttrs($attributes) ?>>
    <div class="age-gate__window" role="dialog" aria-modal="true" aria-labelledby="<?= $id ?>-title" aria-describedby="<?= $id ?>-text">
        <?= $data['logoHtml'] ?>
        <div class="age-gate__body">
            <p class="age-gate__title" id="<?= $id ?>-title"><?= htmlspecialchars($data['title']) ?></p>
            <p class="age-gate__text" id="<?= $id ?>-text"><?= htmlspecialchars($data['text']) ?></p>
        </div>
        <div class="age-gate__actions">
            <?= $button($data['confirmText'], ButtonStyle::Primary, 'confirm') ?>
            <?= $button($data['declineText'], ButtonStyle::Secondary, 'decline') ?>
        </div>
    </div>
</div>

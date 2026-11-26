<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;

$classes = ['notice', "notice_style_{$data['style']}", "notice-theme_{$data['theme']}", $data['className']];
$attributes = $data['attributes'];
$attributes['role'] ??= in_array($data['style'], ['error', 'alert'], true) ? 'alert' : 'status';
?>
<div class="<?= htmlspecialchars(trim(implode(' ', array_filter($classes)))) ?>" data-sf-notice <?= buildAttrs($attributes) ?>>
    <div class="notice__main">
        <?php if ($data['icon']): ?>
            <?= renderIcon($data['iconId'], 'notice__icon') ?>
        <?php endif; ?>
        <div class="notice__body">
            <div class="notice__title"><?= htmlspecialchars($data['title']) ?></div>
            <?php if ($data['text'] !== ''): ?>
                <div class="notice__text"><?= htmlspecialchars($data['text']) ?></div>
            <?php endif; ?>
        </div>
        <?php if ($data['close']): ?>
            <?= ButtonIcon::drawButtonIconSmall(
                icon: 'close',
                label: 'Закрыть',
                className: 'notice__close',
                theme: ButtonIconSmallTheme::from($data['theme']),
                attributes: ['data-sf-notice-close' => ''],
            ) ?>
        <?php endif; ?>
    </div>
    <?php if ($data['buttons'] !== ''): ?>
        <div class="notice__buttons"><?= $data['buttons'] ?></div>
    <?php endif; ?>
</div>

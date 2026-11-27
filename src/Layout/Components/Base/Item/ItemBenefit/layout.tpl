<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Badge\BadgeSize;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainSize;
use Simflex\Core\Layout\Components\UI\Marker\Layout as Marker;
use Simflex\Core\Layout\Components\UI\Marker\MarkerSize;
use Simflex\Core\Layout\Components\UI\Marker\MarkerTheme;

$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$h = 'h' . (int)$data['headingLevel'];

$classes = [
    'benefit',
    "benefit-size_{$data['size']}",
    "benefit-type_{$data['type']}",
    "benefit-layout_{$data['layout']}",
    "benefit-align_{$data['align']}",
    "benefit-theme_{$data['theme']}",
    $data['card'] ? 'benefit-card' : '',
    $data['className'] ?? ''
];

$markerSize = match ($data['size']) {
    's' => MarkerSize::ExtraSmall,
    'l' => MarkerSize::Large,
    default => MarkerSize::Medium,
};
$hasSign = $data['type'] === 'number' ? $data['number'] !== '' : $data['icon'] !== '';
?>

<li class="<?= $esc(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <?php $line = $data['line'] ?? true; ?>
    <?php if ($hasSign || $line): ?>
        <div class="benefit__head" aria-hidden="true">
            <?php if ($line && $data['align'] === 'center'): ?>
                <span class="benefit__line"></span>
            <?php endif; ?>
            <?php if ($hasSign && $data['type'] === 'number'): ?>
                <span class="benefit__sign benefit__number"><?= $esc($data['number']) ?></span>
            <?php elseif ($hasSign): ?>
                <?= Marker::drawMarker(
                    className: 'benefit__sign',
                    icon: $data['icon'],
                    size: $markerSize,
                    theme: $data['theme'] === 'dark' ? MarkerTheme::Dark : MarkerTheme::Light
                ) ?>
            <?php endif; ?>
            <?php if ($line): ?>
                <span class="benefit__line"></span>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <div class="benefit__body">
        <?php if ($data['title'] !== ''): ?>
            <<?= $h ?> class="benefit__title"><?= $esc($data['title']) ?></<?= $h ?>>
        <?php endif; ?>
        <?php if ($data['text'] !== ''): ?>
            <p class="benefit__text"><?= $esc($data['text']) ?></p>
        <?php endif; ?>
        <?php if ($data['badge'] !== ''): ?>
            <?= Badge::drawBadge(
                className: 'benefit__badge',
                text: $esc($data['badge']),
                style: BadgeStyle::Secondary,
                size: BadgeSize::Medium,
                icon: 'clock'
            ) ?>
        <?php endif; ?>
        <?php if ($data['link']): ?>
            <?= Link::drawLinkMain(
                className: 'benefit__link',
                text: (string)$data['link']['text'],
                href: (string)$data['link']['href'],
                iconRight: 'chevron-right',
                size: $data['size'] === 's' ? LinkMainSize::Small : LinkMainSize::Medium,
                attributes: [
                    // Имя ссылки включает видимый текст и называет, о чём она
                    'aria-label' => (string)($data['link']['label']
                        ?? ($data['link']['text'] . ($data['title'] !== '' ? ': ' . $data['title'] : ''))),
                ]
            ) ?>
        <?php endif; ?>
    </div>
</li>

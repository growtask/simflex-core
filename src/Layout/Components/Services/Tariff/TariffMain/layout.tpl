<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo\Layout as TooltipInfo;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$h = 'h' . $data['headingLevel'];
$priceBlock = static function (array $p, string $period) use ($esc): string {
    $html = '<p class="tariff__price" data-tariff-period="' . $period . '">'
        . '<span class="tariff__value">' . $esc($p['price'] ?? '') . '</span>';
    if (($p['period'] ?? '') !== '') {
        $html .= '<span class="tariff__period">' . $esc($p['period']) . '</span>';
    }
    if (($p['oldPrice'] ?? '') !== '') {
        $html .= '<s class="tariff__old"><span class="visually-hidden">Старая цена: </span>' . $esc($p['oldPrice']) . '</s>';
    }
    if (($p['discount'] ?? '') !== '') {
        $html .= '<span class="tariff__discount">' . $esc($p['discount']) . '</span>';
    }
    return $html . '</p>';
};
$month = ['price' => $data['price'], 'period' => $data['period'], 'oldPrice' => $data['oldPrice'], 'discount' => $data['discount']];
$classes = ['tariff', "tariff-theme_{$data['theme']}", $data['featured'] ? 'tariff_featured' : '',
    $data['disabled'] ? 'tariff_disabled' : '', $data['className']];
$attrs = $data['attributes'] + ($data['disabled'] ? ['aria-disabled' => 'true'] : []);
?>
<article class="<?= $esc(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attrs) ?>>
    <div class="tariff__head">
        <div class="tariff__top">
            <<?= $h ?> class="tariff__name"><?= $esc($data['name']) ?></<?= $h ?>>
            <?php if ($data['label'] !== ''): ?>
                <?= Badge::drawBadge(className: 'tariff__label', text: $esc($data['label']), style: BadgeStyle::PrimaryLight) ?>
            <?php endif; ?>
        </div>
        <?php if ($data['description'] !== ''): ?>
            <p class="tariff__description"><?= $esc($data['description']) ?></p>
        <?php endif; ?>
    </div>
    <?php if ($data['price'] !== ''): ?>
        <?= $priceBlock($month, 'month') ?>
        <?php if (($data['year']['price'] ?? '') !== ''): ?>
            <?= $priceBlock($data['year'], 'year') ?>
        <?php endif; ?>
    <?php endif; ?>
    <?php if ($data['features']): ?>
        <span class="tariff__line" aria-hidden="true"></span>
        <ul class="tariff__features">
            <?php foreach ($data['features'] as $feature): ?>
                <?php $in = $feature['included'] ?? true; ?>
                <li class="tariff__feature<?= $in ? '' : ' tariff__feature_off' ?>">
                    <?= renderIcon($in ? 'check' : 'close', 'tariff__feature-icon') ?>
                    <span class="tariff__feature-body">
                        <span class="tariff__feature-text"><span class="visually-hidden"><?= $in ? 'Входит: ' : 'Не входит: ' ?></span><?= $esc($feature['text']) ?></span>
                        <?php if (($feature['description'] ?? '') !== ''): ?>
                            <span class="tariff__feature-description"><?= $esc($feature['description']) ?></span>
                        <?php endif; ?>
                    </span>
                    <?php if (($feature['hint'] ?? '') !== ''): ?>
                        <?= TooltipInfo::drawTooltipInfo($esc($feature['hint']), TooltipMainTheme::from($data['theme']), label: 'Подробнее: ' . $esc($feature['text'])) ?>
                    <?php endif; ?>
                </li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
    <?php if ($data['buttonText'] !== ''): ?>
        <?= Button::drawButtonMain(
            className: 'tariff__button',
            text: $esc($data['buttonText']),
            link: $data['buttonLink'],
            style: $data['featured'] ? ButtonMainStyle::Primary : ButtonMainStyle::Gray,
            theme: ButtonMainTheme::from($data['theme']),
            attributes: $data['buttonAttributes'],
            disabled: $data['disabled'],
        ) ?>
    <?php endif; ?>
</article>

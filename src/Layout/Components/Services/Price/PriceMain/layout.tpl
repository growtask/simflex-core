<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainState;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$buttonTheme = ButtonMainTheme::from($data['theme']);
$sticky = $data['style'] === 'sticky';
$actions = '';
if ($data['style'] !== 'compact') {
    if ($data['unavailable']) {
        $actions .= Button::drawButtonMain(className: 'price__action', text: 'Недоступно', theme: $buttonTheme, disabled: true);
    } elseif ($data['orderText'] !== '') {
        $actions .= Button::drawButtonMain(className: 'price__action', text: $esc($data['orderText']), link: $data['orderLink'],
            style: ButtonMainStyle::Primary, theme: $buttonTheme, attributes: $data['orderAttributes']);
    }
    if ($data['askText'] !== '' && !$sticky) {
        $actions .= Button::drawButtonMain(className: 'price__action', text: $esc($data['askText']), link: $data['askLink'],
            style: ButtonMainStyle::Secondary, theme: $buttonTheme, attributes: $data['askAttributes']);
    }
}
$classes = ['price', "price_style_{$data['style']}", "price-theme_{$data['theme']}",
    $sticky && $data['inline'] ? 'price_inline' : '', $data['className']];
$attrs = $data['attributes'];
if ($sticky && !$data['inline']) {
    $attrs += ['data-sf-price-sticky' => $data['watch'], 'aria-hidden' => 'true'];
}
?>
<div class="<?= $esc(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attrs) ?>>
    <div class="price__info">
        <?php if ($data['type'] === 'special'): ?>
            <p class="price__special"><?= $esc($data['special']) ?></p>
        <?php else: ?>
            <p class="price__row">
                <?php if ($data['from'] !== ''): ?><span class="price__from"><?= $esc($data['from']) ?></span><?php endif; ?>
                <span class="price__sum">
                    <span class="price__value"><?= $esc($data['price']) ?></span>
                    <?php if ($data['unit'] !== ''): ?><span class="price__unit"><?= $esc($data['unit']) ?></span><?php endif; ?>
                    <?php if ($data['oldPrice'] !== ''): ?><s class="price__old"><span class="visually-hidden">Старая цена: </span><?= $esc($data['oldPrice']) ?></s><?php endif; ?>
                </span>
                <?php if ($data['discount'] !== ''): ?><span class="price__discount"><?= $esc($data['discount']) ?></span><?php endif; ?>
            </p>
        <?php endif; ?>
        <?php if ($data['time'] !== '' && !$sticky): ?>
            <p class="price__time"><?= renderIcon('clock', 'price__time-icon') ?><span><?= $esc($data['time']) ?></span></p>
        <?php endif; ?>
    </div>
    <?php if ($actions !== ''): ?>
        <div class="price__actions"><?= $actions ?></div>
    <?php endif; ?>
</div>

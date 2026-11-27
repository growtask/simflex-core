<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\Layout as Selector;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainTheme;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$classes = ['tariff-list', "tariff-list-theme_{$data['theme']}", "tariff-list_period_{$data['period']}", $data['className']];
?>
<section class="<?= $esc(implode(' ', array_filter($classes))) ?>" data-sf-tariff-list>
    <?php if ($data['periods']): ?>
        <?= Selector::drawSelectorMain(
            items: [
                ['text' => $data['monthText'], 'value' => 'month', 'active' => $data['period'] === 'month'],
                ['text' => $data['yearText'], 'value' => 'year', 'badge' => $data['yearBadge'], 'active' => $data['period'] === 'year'],
            ],
            theme: SelectorMainTheme::from($data['theme']),
            label: 'Период оплаты',
            className: 'tariff-list__periods',
        ) ?>
    <?php endif; ?>
    <div class="tariff-list__viewport swiper" data-sf-tariff-viewport>
        <div class="tariff-list__track swiper-wrapper">
            <?php foreach ($data['cards'] as $card): ?>
                <div class="tariff-list__item swiper-slide"><?= $card ?></div>
            <?php endforeach; ?>
        </div>
    </div>
    <div class="tariff-list__dots" data-sf-tariff-dots></div>
</section>

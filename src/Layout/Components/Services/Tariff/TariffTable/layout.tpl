<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\Layout as Selector;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainSize;
use Simflex\Core\Layout\Components\UI\Selector\SelectorMain\SelectorMainTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo\Layout as TooltipInfo;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$theme = $data['theme'];
$button = static fn(array $plan, ButtonMainSize $size, string $class): string => Button::drawButtonMain(
    className: $class,
    text: $esc($plan['buttonText'] ?? 'Выбрать'),
    link: (string)($plan['buttonLink'] ?? ''),
    style: !empty($plan['featured']) ? ButtonMainStyle::Primary : ButtonMainStyle::Secondary,
    size: $size,
    theme: ButtonMainTheme::from($theme),
);
$col = static fn(int $i, array $plan): string => 'tariff-table__col tariff-table__col_' . $i . (!empty($plan['featured']) ? ' tariff-table__col_featured' : '');
$classes = ['tariff-table', "tariff-table-theme_{$theme}", 'tariff-table_plan_' . $data['active'], $data['className']];
?>
<section class="<?= $esc(implode(' ', array_filter($classes))) ?>" data-sf-tariff-table>
    <div class="tariff-table__mobile">
        <?= Selector::drawSelectorMain(
            items: array_map(static fn(array $p, int $i) => ['text' => $p['name'], 'value' => (string)$i, 'active' => $i === $data['active']],
                $data['plans'], array_keys($data['plans'])),
            size: SelectorMainSize::Small,
            theme: SelectorMainTheme::from($theme),
            fill: true,
            label: 'Тариф',
            className: 'tariff-table__selector',
        ) ?>
        <?php foreach ($data['plans'] as $i => $plan): ?>
            <div class="tariff-table__plan tariff-table__plan_<?= $i ?>">
                <p class="tariff-table__plan-name"><?= $esc($plan['name']) ?></p>
                <?php if (($plan['price'] ?? '') !== ''): ?><p class="tariff-table__plan-price"><?= $esc($plan['price']) ?></p><?php endif; ?>
                <?php if ($data['buttons']): ?><?= $button($plan + ['featured' => true], ButtonMainSize::Medium, 'tariff-table__plan-button') ?><?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>
    <table class="tariff-table__table">
        <thead>
            <tr>
                <th class="tariff-table__title" scope="col"><?= $esc($data['title']) ?></th>
                <?php foreach ($data['plans'] as $i => $plan): ?>
                    <th class="<?= $col($i, $plan) ?>" scope="col">
                        <span class="tariff-table__name"><?= $esc($plan['name']) ?></span>
                        <?php if (($plan['price'] ?? '') !== ''): ?><span class="tariff-table__price"><?= $esc($plan['price']) ?></span><?php endif; ?>
                        <?php if ($data['buttons']): ?><?= $button($plan, ButtonMainSize::Small, 'tariff-table__button') ?><?php endif; ?>
                    </th>
                <?php endforeach; ?>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($data['features'] as $feature): ?>
                <tr class="tariff-table__row">
                    <th class="tariff-table__feature" scope="row">
                        <span class="tariff-table__feature-text"><?= $esc($feature['text']) ?></span>
                        <?php if (($feature['hint'] ?? '') !== ''): ?>
                            <?= TooltipInfo::drawTooltipInfo($esc($feature['hint']), TooltipMainTheme::from($theme), label: 'Подробнее: ' . $esc($feature['text'])) ?>
                        <?php endif; ?>
                    </th>
                    <?php foreach ($data['plans'] as $i => $plan): ?>
                        <?php $in = (bool)($feature['values'][$i] ?? false); ?>
                        <td class="<?= $col($i, $plan) ?> tariff-table__mark<?= $in ? '' : ' tariff-table__mark_off' ?>">
                            <?= renderIcon($in ? 'check' : 'close', 'tariff-table__icon') ?>
                            <span class="visually-hidden"><?= $in ? 'входит' : 'не входит' ?></span>
                        </td>
                    <?php endforeach; ?>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</section>

<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitLayout;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitSize;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitTheme;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\Layout as Benefit;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as Img;
use Simflex\Core\Layout\Components\Services\Price\PriceMain\Layout as Price;
use Simflex\Core\Layout\Components\Services\Price\PriceMain\PriceMainTheme;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$cover = $data['layout'] === 'cover';
// у cover текст на тёмной подложке: содержимое в тёмной теме
$inner = $cover ? 'dark' : $data['theme'];
$media = $data['media'] !== '' ? $data['media']
    : ($data['image'] !== '' ? Img::drawPlaceholderImg(src: $data['image'], alt: $data['imageAlt'], imgClass: 'hero__img',
        attributes: ['loading' => 'eager', 'fetchpriority' => 'high']) : '');
$benefits = '';
foreach ($data['benefits'] as $benefit) {
    $benefits .= Benefit::drawItemBenefit(
        title: (string)$benefit['title'],
        text: (string)($benefit['text'] ?? ''),
        icon: (string)($benefit['icon'] ?? 'check'),
        line: false,
        size: ItemBenefitSize::Small,
        layout: ItemBenefitLayout::Horizontal,
        theme: ItemBenefitTheme::from($inner),
        headingLevel: 2,
    );
}
$classes = ['hero', "hero_layout_{$data['layout']}", "hero-theme_{$data['theme']}",
    $media === '' || $data['layout'] === 'center' ? 'hero_no-media' : '', $data['className']];
?>
<section class="<?= $esc(implode(' ', array_filter($classes))) ?>">
    <?php if ($cover && $media !== ''): ?>
        <div class="hero__cover" aria-hidden="true"><?= $media ?></div>
    <?php endif; ?>
    <div class="hero__content">
        <div class="hero__text">
            <?php if ($data['badges']): ?>
                <div class="hero__badges">
                    <?php foreach (array_values($data['badges']) as $i => $badge): ?>
                        <?= Badge::drawBadge(text: $esc($badge), style: $i === 0 ? BadgeStyle::PrimaryLight : BadgeStyle::Secondary) ?>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
            <h1 class="hero__title"><?= $esc($data['title']) ?></h1>
            <?php if ($data['description'] !== ''): ?>
                <p class="hero__description"><?= $esc($data['description']) ?></p>
            <?php endif; ?>
            <?php if ($benefits !== ''): ?>
                <ul class="hero__benefits"><?= $benefits ?></ul>
            <?php endif; ?>
        </div>
        <?php if ($data['price']): ?>
            <?= Price::drawPriceMain(...$data['price'] + ['theme' => PriceMainTheme::from($inner), 'className' => 'hero__price']) ?>
        <?php endif; ?>
        <?php if ($data['portfolioText'] !== '' && $data['portfolioLink'] !== ''): ?>
            <?= Button::drawButtonMain(className: 'hero__portfolio', text: $esc($data['portfolioText']), link: $data['portfolioLink'],
                style: ButtonMainStyle::Secondary, theme: ButtonMainTheme::from($inner)) ?>
        <?php endif; ?>
    </div>
    <?php if (!$cover && $media !== '' && $data['layout'] !== 'center'): ?>
        <div class="hero__media"><?= $media ?></div>
    <?php endif; ?>
</section>

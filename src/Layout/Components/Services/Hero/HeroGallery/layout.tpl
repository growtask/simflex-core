<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepTheme;
use Simflex\Core\Layout\Components\Base\Slider\SliderStepItem\Layout as StepItem;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as Img;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$count = count($data['images']);
$classes = ['hero-gallery', "hero-gallery-theme_{$data['theme']}", $data['className']];
?>
<div class="<?= $esc(implode(' ', array_filter($classes))) ?>" role="region" aria-roledescription="галерея"
     aria-label="<?= $esc($data['label']) ?>" data-sf-hero-gallery data-active="<?= (int)$data['active'] ?>">
    <div class="hero-gallery__main swiper" data-sf-hero-gallery-main>
        <div class="hero-gallery__track swiper-wrapper">
            <?php foreach ($data['images'] as $i => $image): ?>
                <div class="hero-gallery__slide swiper-slide" role="group" aria-roledescription="слайд" aria-label="<?= $i + 1 ?> из <?= $count ?>">
                    <?= Img::drawPlaceholderImg(src: $image['src'], alt: (string)($image['alt'] ?? ''), imgClass: 'hero-gallery__img',
                        attributes: $i === 0 ? ['loading' => 'eager'] : []) ?>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
    <?php if ($count > 1): ?>
        <div class="hero-gallery__thumbs">
            <?php foreach ($data['images'] as $i => $image): ?>
                <button type="button" class="hero-gallery__thumb<?= $i === $data['active'] ? ' hero-gallery__thumb_active' : '' ?>"
                        aria-label="Картинка <?= $i + 1 ?> из <?= $count ?>" aria-pressed="<?= $i === $data['active'] ? 'true' : 'false' ?>"
                        data-sf-hero-gallery-thumb="<?= $i ?>">
                    <?= Img::drawPlaceholderImg(src: $image['src'], imgClass: 'hero-gallery__img') ?>
                </button>
            <?php endforeach; ?>
        </div>
        <div class="hero-gallery__steps" aria-hidden="true">
            <?php foreach ($data['images'] as $i => $image): ?>
                <?= StepItem::drawSliderStepItem(active: $i === $data['active'], theme: SliderStepTheme::from($data['theme'])) ?>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

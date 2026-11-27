<?php
/** @var array $data */

$classes = ['slider', "slider-theme_{$data['theme']}", "slider_type_{$data['type']}", "slider_step_{$data['step']}",
    $data['className']];
$h = 'h' . $data['headingLevel'];
?>
<section class="<?= htmlspecialchars(implode(' ', array_filter($classes))) ?>" data-sf-slider <?= buildAttrs($data['attributes']) ?>>
    <?php if ($data['heading'] || $data['arrows'] !== ''): ?>
        <div class="slider__top">
            <?php if ($data['heading']): ?>
                <<?= $h ?> class="slider__title"><?= htmlspecialchars($data['title']) ?></<?= $h ?>>
            <?php endif; ?>
            <div class="slider__buttons">
                <?= $data['allTop'] ?>
                <?php if ($data['arrows'] !== ''): ?>
                    <div class="slider__arrows"><?= $data['arrows'] ?></div>
                <?php endif; ?>
            </div>
        </div>
    <?php endif; ?>
    <div class="slider__viewport swiper" tabindex="0" role="region" aria-roledescription="карусель"
         aria-label="<?= htmlspecialchars($data['label']) ?>" data-sf-slider-viewport>
        <div class="slider__track swiper-wrapper">
            <?php foreach ($data['cards'] as $i => $card): ?>
                <div class="slider__item swiper-slide" role="group" aria-roledescription="слайд"
                     aria-label="<?= $i + 1 ?> из <?= count($data['cards']) ?>"><?= $card ?></div>
            <?php endforeach; ?>
        </div>
    </div>
    <?php if ($data['steps'] !== '' || $data['allBottom'] !== ''): ?>
        <div class="slider__bottom"><?= $data['steps'] ?><?= $data['allBottom'] ?></div>
    <?php endif; ?>
</section>

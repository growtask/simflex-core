<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as PlaceholderImg;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Other\StepIndicator\Layout as StepIndicator;
use Simflex\Core\Layout\Components\UI\Other\StepIndicator\StepIndicatorSize;
use Simflex\Core\Layout\Components\UI\Other\StepIndicator\StepIndicatorTheme;

$slides = $data['slides'];
$total = count($slides);
$multiple = $total > 1;
$h = 'h' . (int)$data['headingLevel'];
$esc = static fn($value) => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');

$classes = ['banner', "banner-theme_{$data['theme']}", $multiple ? 'banner_multiple' : '', $data['className'] ?? ''];
$attrs = ($data['attributes'] ?? []) + [
    'role' => 'region',
    'aria-roledescription' => 'carousel',
    'aria-label' => $data['label'],
];
if ($multiple) {
    $attrs += [
        'data-banner' => '',
        'data-autoplay' => $data['autoplay'] ? '1' : '0',
        'data-interval' => (string)(int)$data['interval'],
    ];
}
?>

<section class="<?= $esc(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attrs) ?>>
    <div class="banner__viewport">
        <div class="banner__track" <?= $multiple ? 'data-banner-track' : '' ?>>
            <?php foreach ($slides as $i => $slide): ?>
                <?php
                $slideAttrs = [
                    'role' => 'group',
                    'aria-roledescription' => 'slide',
                ];
                if ($multiple) {
                    $slideAttrs['aria-label'] = sprintf($data['slideLabel'], $i + 1, $total);
                }
                // Неактивные слайды скрыты от скринридеров и выпадают из порядка фокуса
                if ($i > 0) {
                    $slideAttrs['aria-hidden'] = 'true';
                    $slideAttrs['inert'] = '';
                }
                ?>
                <div class="banner__slide" <?= buildAttrs($slideAttrs) ?>>
                    <?php if (($slide['image'] ?? '') !== ''): ?>
                        <?= PlaceholderImg::drawPlaceholderImg(
                            src: $slide['image'],
                            alt: $slide['alt'] ?? '',
                            imgClass: 'banner__img',
                            attributes: ['loading' => $i === 0 ? 'eager' : 'lazy', 'draggable' => 'false']
                        ) ?>
                    <?php endif; ?>
                    <div class="banner__content">
                        <?php if (($slide['title'] ?? '') !== ''): ?>
                            <<?= $h ?> class="banner__title"><?= $esc($slide['title']) ?></<?= $h ?>>
                        <?php endif; ?>
                        <?php if (($slide['text'] ?? '') !== ''): ?>
                            <p class="banner__text"><?= $esc($slide['text']) ?></p>
                        <?php endif; ?>
                        <?php if (($slide['buttonText'] ?? '') !== '' && ($slide['buttonLink'] ?? '') !== ''): ?>
                            <?= Button::drawButtonMain(
                                className: 'banner__button',
                                text: $esc($slide['buttonText']),
                                link: (string)$slide['buttonLink'],
                                style: ButtonMainStyle::Primary,
                                size: ButtonMainSize::Medium,
                                iconRight: 'arrow-up-right'
                            ) ?>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <?php if ($multiple): ?>
            <div class="banner__arrows">
                <?= Button::drawButtonMain(
                    className: 'banner__arrow banner__arrow_prev',
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::Medium,
                    iconLeft: 'arrow-left',
                    disabled: true,
                    attributes: ['aria-label' => $data['prevLabel'], 'data-banner-prev' => '']
                ) ?>
                <?= Button::drawButtonMain(
                    className: 'banner__arrow banner__arrow_next',
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::Medium,
                    iconLeft: 'arrow-right',
                    attributes: ['aria-label' => $data['nextLabel'], 'data-banner-next' => '']
                ) ?>
            </div>
        <?php endif; ?>
    </div>

    <?php if ($multiple): ?>
        <?= StepIndicator::drawStepIndicator(
            className: 'banner__steps',
            count: $total,
            active: 0,
            label: $data['label'],
            size: StepIndicatorSize::Medium,
            theme: $data['theme'] === 'dark' ? StepIndicatorTheme::Dark : StepIndicatorTheme::Light,
            attributes: ['data-banner-steps' => '']
        ) ?>
    <?php endif; ?>
</section>

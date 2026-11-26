<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;

$bannerClasses = [
    'header-banner',
    $data['className'] ?? ''
];
$hasButton = $data['buttonText'] !== '' && $data['buttonLink'] !== '';
?>

<section class="<?= htmlspecialchars(trim(implode(' ', $bannerClasses))) ?>" role="region"
    aria-label="<?= htmlspecialchars($data['label']) ?>" data-header-banner="<?= htmlspecialchars($data['key']) ?>"
    <?= buildAttrs($data['attributes'] ?? []) ?>>
    <?php // Ранее закрытую строку скрываем до первой отрисовки, чтобы она не мелькала ?>
    <script>try{if(localStorage.getItem('simflex:header-banner')==='<?= htmlspecialchars($data['key']) ?>'){document.currentScript.parentNode.hidden=true}}catch(e){}</script>
    <div class="header-banner__container">
        <div class="header-banner__content">
            <p class="header-banner__text"><?= htmlspecialchars($data['text']) ?></p>
            <?php if ($hasButton): ?>
            <?= Button::drawButtonMain(
                className: 'header-banner__button',
                text: htmlspecialchars($data['buttonText']),
                link: $data['buttonLink'],
                style: $data['buttonStyle'],
                size: ButtonMainSize::Small
            ) ?>
            <?php endif; ?>
        </div>
        <?= Button::drawButtonMain(
            className: 'header-banner__close',
            iconLeft: 'close',
            style: \Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle::Flat,
            size: ButtonMainSize::Small,
            theme: $data['closeTheme'],
            attributes: ['aria-label' => $data['closeLabel'], 'data-header-banner-close' => '']
        ) ?>
    </div>
</section>

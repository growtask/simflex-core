<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg\Layout as Img;
use Simflex\Core\Layout\Components\UI\Badge\BadgeSize;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$h = 'h' . $data['headingLevel'];
$isLink = $data['link'] !== '' && !$data['disabled'];
$classes = ['service-card', "service-card_layout_{$data['layout']}", "service-card-theme_{$data['theme']}",
    $data['disabled'] ? 'service-card_disabled' : '', $data['className']];
$attrs = $data['attributes'] + ($data['disabled'] ? ['aria-disabled' => 'true'] : []);
?>
<article class="<?= $esc(implode(' ', array_filter($classes))) ?>" <?= buildAttrs($attrs) ?>>
    <?php if ($data['image'] !== ''): ?>
        <div class="service-card__image"><?= Img::drawPlaceholderImg(src: $data['image'], imgClass: 'service-card__img') ?></div>
    <?php endif; ?>
    <div class="service-card__info">
        <div class="service-card__text">
            <?php if ($data['label'] !== ''): ?>
                <?= Badge::drawBadge(className: 'service-card__label', text: $esc($data['label']), style: BadgeStyle::PrimaryLight) ?>
            <?php endif; ?>
            <<?= $h ?> class="service-card__head">
                <?php if ($data['arrow']): ?>
                    <span class="service-card__arrow" aria-hidden="true"><?= renderIcon('arrow-up-right', 'service-card__arrow-icon service-card__arrow-icon_static') ?><?= renderIcon('arrow-right', 'service-card__arrow-icon service-card__arrow-icon_hover') ?></span>
                <?php endif; ?>
                <?php if ($isLink): ?>
                    <a class="service-card__title" href="<?= $esc($data['link']) ?>"><?= $esc($data['title']) ?></a>
                <?php else: ?>
                    <span class="service-card__title"><?= $esc($data['title']) ?></span>
                <?php endif; ?>
            </<?= $h ?>>
            <?php if ($data['description'] !== ''): ?>
                <p class="service-card__description"><?= $esc($data['description']) ?></p>
            <?php endif; ?>
        </div>
        <?php if ($data['price'] !== '' || $data['time'] !== ''): ?>
            <div class="service-card__badges">
                <?php if ($data['price'] !== ''): ?>
                    <p class="service-card__price">
                        <?php if ($data['from'] !== ''): ?><span class="service-card__from"><?= $esc($data['from']) ?></span><?php endif; ?>
                        <?= Badge::drawBadge(className: 'service-card__badge', text: $esc($data['price']), style: BadgeStyle::Secondary, size: BadgeSize::Medium, icon: 'banknote') ?>
                        <?php if ($data['oldPrice'] !== ''): ?><s class="service-card__old"><span class="visually-hidden">Старая цена: </span><?= $esc($data['oldPrice']) ?></s><?php endif; ?>
                    </p>
                <?php endif; ?>
                <?php if ($data['time'] !== ''): ?>
                    <?= Badge::drawBadge(className: 'service-card__badge', text: $esc($data['time']), style: BadgeStyle::Secondary, size: BadgeSize::Medium, icon: 'clock') ?>
                <?php endif; ?>
            </div>
        <?php endif; ?>
        <?php if ($data['orderText'] !== '' && !$data['disabled']): ?>
            <?= Button::drawButtonMain(
                className: 'service-card__action',
                text: $esc($data['orderText']),
                style: ButtonMainStyle::Primary,
                size: ButtonMainSize::ExtraSmall,
                theme: ButtonMainTheme::from($data['theme']),
                attributes: $data['orderAttributes'],
            ) ?>
        <?php endif; ?>
    </div>
</article>

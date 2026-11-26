<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Common\MobileMenu\Layout as MobileMenu;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim\Layout as BrandLogoAnim;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;

$id = htmlspecialchars($data['id']);
$items = MobileMenu::getListItems($data['items']);
?>

<div class="mobile-menu <?= htmlspecialchars($data['className']) ?>" id="<?= $id ?>" role="dialog" aria-modal="true"
    aria-label="<?= htmlspecialchars($data['label']) ?>" data-mobile-menu hidden>
    <div class="mobile-menu__panel">
        <div class="mobile-menu__head">
            <?= BrandLogoAnim::drawBrandLogoAnim(
                className: 'mobile-menu__logo',
                href: $data['logoHref'],
                name: $data['logoName'],
                src: $data['logoSrc']
            ) ?>
            <?= Button::drawButtonMain(
                className: 'mobile-menu__close',
                iconLeft: 'close',
                style: ButtonMainStyle::Secondary,
                size: ButtonMainSize::Medium,
                attributes: ['aria-label' => $data['closeLabel'], 'data-mobile-menu-close' => '']
            ) ?>
        </div>
        <?= Separator::drawSeparator() ?>

        <div class="mobile-menu__body">
            <?php if ($data['geo'] !== ''): ?>
                <div class="mobile-menu__geo"><?= $data['geo'] ?></div>
            <?php endif; ?>

            <?php if ($items): ?>
                <nav class="mobile-menu__nav" aria-label="Основное меню">
                    <ul class="mobile-menu__list">
                        <?php foreach ($items as $i => $item): ?>
                            <li class="mobile-menu__item">
                                <?php if ($item['children']): ?>
                                    <?php $subId = $id . '-sub-' . $i; ?>
                                    <?= Tab::drawTabMain(
                                        className: 'mobile-menu__toggle',
                                        text: htmlspecialchars((string)$item['text']),
                                        iconRight: 'chevron-down-sm',
                                        style: TabMainStyle::Secondary,
                                        size: TabMainSize::Small,
                                        attributes: [
                                            'aria-expanded' => 'false',
                                            'aria-controls' => $subId,
                                            'data-mobile-menu-toggle' => '',
                                        ],
                                        active: !empty($item['active'])
                                    ) ?>
                                    <ul class="mobile-menu__sublist" id="<?= $subId ?>" hidden>
                                        <?php foreach ($item['children'] as $child): ?>
                                            <li class="mobile-menu__item">
                                                <?= Tab::drawTabMain(
                                                    text: htmlspecialchars((string)$child['text']),
                                                    link: (string)$child['link'],
                                                    style: TabMainStyle::Secondary,
                                                    size: TabMainSize::Small,
                                                    active: !empty($child['active'])
                                                ) ?>
                                            </li>
                                        <?php endforeach; ?>
                                    </ul>
                                <?php else: ?>
                                    <?= Tab::drawTabMain(
                                        text: htmlspecialchars((string)$item['text']),
                                        link: (string)$item['link'],
                                        style: TabMainStyle::Secondary,
                                        size: TabMainSize::Small,
                                        active: !empty($item['active'])
                                    ) ?>
                                <?php endif; ?>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </nav>
            <?php endif; ?>
        </div>

        <div class="mobile-menu__footer">
            <?php if ($data['phone'] !== ''): ?>
                <?= Contact::drawLinkContact(text: $data['phone'], value: $data['phone'], type: LinkContactType::Phone, size: LinkContactSize::Small) ?>
            <?php endif; ?>
            <?php if ($data['email'] !== ''): ?>
                <?= Contact::drawLinkContact(text: $data['email'], value: $data['email'], type: LinkContactType::Email, size: LinkContactSize::Small) ?>
            <?php endif; ?>
            <?php if ($data['socials']): ?>
                <div class="mobile-menu__socials">
                    <?php foreach ($data['socials'] as $network => $href): ?>
                        <?php if ($href !== '' && ButtonSocialSmallNetwork::tryFrom((string)$network)): ?>
                            <?= Social::drawButtonSocialSmall(network: ButtonSocialSmallNetwork::from((string)$network), href: $href, size: ButtonSocialSmallSize::Small) ?>
                        <?php endif; ?>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
            <?php if ($data['buttonText'] !== ''): ?>
                <?= Button::drawButtonMain(
                    className: 'mobile-menu__cta',
                    text: htmlspecialchars($data['buttonText']),
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::Medium,
                    attributes: $data['buttonModal'] !== '' ? ['data-modal' => $data['buttonModal']] : []
                ) ?>
            <?php endif; ?>
        </div>
    </div>
</div>

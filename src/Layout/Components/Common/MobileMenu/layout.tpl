<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Common\MobileMenu\Layout as MobileMenu;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\UI\Other\Logo\Layout as Logo;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;

$id = htmlspecialchars($data['id']);
$items = MobileMenu::getListItems($data['items']);
?>

<div class="mobile-menu <?= htmlspecialchars($data['className']) ?>" id="<?= $id ?>" role="dialog" aria-modal="true"
    aria-label="<?= htmlspecialchars($data['label']) ?>" data-mobile-menu hidden>
    <div class="mobile-menu__panel">
        <div class="mobile-menu__head">
            <?= Logo::drawLogo(
                className: 'mobile-menu__logo',
                href: $data['logoHref'],
                name: $data['logoName'],
                src: $data['logoSrc']
            ) ?>
            <?= Button::drawButton(
                className: 'mobile-menu__close',
                iconLeft: 'close',
                style: ButtonStyle::Secondary,
                size: ButtonSize::Medium,
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
                                    <?= Tab::drawTab(
                                        className: 'mobile-menu__toggle',
                                        text: htmlspecialchars((string)$item['text']),
                                        iconRight: 'chevron-down-sm',
                                        style: TabStyle::Secondary,
                                        size: TabSize::Small,
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
                                                <?= Tab::drawTab(
                                                    text: htmlspecialchars((string)$child['text']),
                                                    link: (string)$child['link'],
                                                    style: TabStyle::Secondary,
                                                    size: TabSize::Small,
                                                    active: !empty($child['active'])
                                                ) ?>
                                            </li>
                                        <?php endforeach; ?>
                                    </ul>
                                <?php else: ?>
                                    <?= Tab::drawTab(
                                        text: htmlspecialchars((string)$item['text']),
                                        link: (string)$item['link'],
                                        style: TabStyle::Secondary,
                                        size: TabSize::Small,
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
                <?= Contact::drawContact(text: $data['phone'], value: $data['phone'], type: ContactType::Phone, size: ContactSize::Small) ?>
            <?php endif; ?>
            <?php if ($data['email'] !== ''): ?>
                <?= Contact::drawContact(text: $data['email'], value: $data['email'], type: ContactType::Email, size: ContactSize::Small) ?>
            <?php endif; ?>
            <?php if ($data['socials']): ?>
                <div class="mobile-menu__socials">
                    <?php foreach ($data['socials'] as $network => $href): ?>
                        <?php if ($href !== '' && SocialNetwork::tryFrom((string)$network)): ?>
                            <?= Social::drawSocial(network: SocialNetwork::from((string)$network), href: $href, size: SocialSize::Small) ?>
                        <?php endif; ?>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
            <?php if ($data['buttonText'] !== ''): ?>
                <?= Button::drawButton(
                    className: 'mobile-menu__cta',
                    text: htmlspecialchars($data['buttonText']),
                    style: ButtonStyle::Secondary,
                    size: ButtonSize::Medium,
                    attributes: $data['buttonModal'] !== '' ? ['data-modal' => $data['buttonModal']] : []
                ) ?>
            <?php endif; ?>
        </div>
    </div>
</div>

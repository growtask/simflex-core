<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Base\Nav\NavMenuList\Layout as NavMenuList;
use Simflex\Core\Layout\Components\Base\Nav\NavMenuList\NavMenuListTheme;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\BrandLogoTheme;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;

$theme = $data['theme'];
?>
<div class="nav-menu nav-menu-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>" role="dialog" aria-modal="true"
     aria-label="<?= htmlspecialchars($data['label']) ?>" data-sf-nav-menu>
    <div class="nav-menu__head">
        <?php if ($data['logoHref'] !== ''): ?>
            <?= BrandLogo::drawBrandLogo(theme: BrandLogoTheme::from($theme), href: $data['logoHref']) ?>
        <?php endif; ?>
        <?= Button::drawButtonMain(
            className: 'nav-menu__close',
            icon: 'close',
            style: ButtonMainStyle::Secondary,
            size: ButtonMainSize::Medium,
            theme: ButtonMainTheme::from($theme),
            attributes: ['aria-label' => $data['closeLabel'], 'data-sf-nav-menu-close' => ''],
        ) ?>
    </div>
    <hr class="nav-menu__line">
    <?php if ($data['location'] !== ''): ?>
        <?= Tab::drawTabMain(
            className: 'nav-menu__location',
            text: htmlspecialchars($data['location']),
            iconLeft: 'marker',
            style: TabMainStyle::Soft,
            size: TabMainSize::Medium,
            theme: TabMainTheme::from($theme),
        ) ?>
    <?php endif; ?>
    <?= NavMenuList::drawNavMenuList($data['items'], NavMenuListTheme::from($theme), className: 'nav-menu__list') ?>
    <?php if ($data['contacts'] !== []): ?>
        <div class="nav-menu__contacts">
            <?php foreach ($data['contacts'] as $contact): ?>
                <?= Contact::drawLinkContact(
                    text: $contact['text'] ?? '',
                    value: $contact['value'],
                    type: $contact['type'],
                    size: LinkContactSize::Small,
                    theme: LinkContactTheme::from($theme),
                ) ?>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
    <?php if ($data['socials'] !== []): ?>
        <div class="nav-menu__socials">
            <?php foreach ($data['socials'] as $social): ?>
                <?= Social::drawButtonSocialSmall(
                    network: $social['network'],
                    href: $social['href'],
                    size: ButtonSocialSmallSize::Medium,
                    theme: ButtonSocialSmallTheme::from($theme),
                ) ?>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
    <?php if ($data['buttonText'] !== ''): ?>
        <?= Button::drawButtonMain(
            className: 'nav-menu__button',
            text: htmlspecialchars($data['buttonText']),
            link: $data['buttonLink'],
            style: ButtonMainStyle::Secondary,
            size: ButtonMainSize::Medium,
            theme: ButtonMainTheme::from($theme),
            attributes: $data['buttonAttributes'],
        ) ?>
    <?php endif; ?>
</div>

<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Common\Header\Layout as Header;
use Simflex\Core\Layout\Components\Common\MobileMenu\Layout as MobileMenu;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim\Layout as BrandLogoAnim;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallSize;

$headerClasses = ['header', $data['className'] ?? ''];
$hasCta = $data['buttonText'] !== '';
$ctaAttrs = $data['buttonModal'] !== '' ? ['data-modal' => $data['buttonModal']] : [];

/**
 * Полоса шапки: top, bottom и line. Закреплённая копия отличается префиксом идентификаторов подменю и не содержит слот $geo (чтобы элемент пакета не дублировался)
 */
$drawBar = function (string $idPrefix, bool $fixed) use ($data, $hasCta, $ctaAttrs): string {
    ob_start();
    ?>
    <div class="header__bar">
        <div class="header__top">
            <div class="header__container header__top-container">
                <?= BrandLogoAnim::drawBrandLogoAnim(
                    className: 'header__logo',
                    href: $data['logoHref'],
                    name: $data['logoName'],
                    src: $data['logoSrc']
                ) ?>
                <?php if ($hasCta): ?>
                    <?= Button::drawButtonMain(
                        className: 'header__cta header__cta_top',
                        text: htmlspecialchars($data['buttonText']),
                        style: ButtonMainStyle::Secondary,
                        size: ButtonMainSize::Small,
                        attributes: $ctaAttrs
                    ) ?>
                <?php endif; ?>
                <?= Button::drawButtonMain(
                    className: 'header__burger',
                    iconLeft: 'menu-2-line',
                    style: ButtonMainStyle::Gray,
                    size: ButtonMainSize::Medium,
                    attributes: [
                        'aria-label' => 'Открыть меню',
                        'aria-haspopup' => 'dialog',
                        'aria-controls' => $data['mobileMenuId'],
                        'aria-expanded' => 'false',
                        'data-mobile-menu-open' => $data['mobileMenuId'],
                    ]
                ) ?>
            </div>
        </div>
        <div class="header__bottom">
            <div class="header__container header__bottom-container">
                <?php if ($data['geo'] !== '' && !$fixed): ?>
                    <div class="header__geo"><?= $data['geo'] ?></div>
                <?php endif; ?>
                <?= Header::drawNav($data['items'], $idPrefix, 'header__nav') ?>
                <div class="header__right">
                    <?php if ($data['socials']): ?>
                        <div class="header__socials">
                            <?php foreach ($data['socials'] as $network => $href): ?>
                                <?php if ($href !== '' && ButtonSocialSmallNetwork::tryFrom((string)$network)): ?>
                                    <?= Social::drawButtonSocialSmall(
                                        network: ButtonSocialSmallNetwork::from((string)$network),
                                        href: $href,
                                        size: ButtonSocialSmallSize::Small
                                    ) ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                    <?php if ($data['phone'] !== '' || $data['email'] !== ''): ?>
                        <div class="header__contacts">
                            <?php if ($data['phone'] !== ''): ?>
                                <?= Contact::drawLinkContact(
                                    text: $data['phone'],
                                    value: $data['phone'],
                                    type: LinkContactType::Phone,
                                    style: LinkContactStyle::Filled,
                                    size: LinkContactSize::ExtraSmall
                                ) ?>
                            <?php endif; ?>
                            <?php if ($data['email'] !== ''): ?>
                                <?= Contact::drawLinkContact(
                                    text: $data['email'],
                                    value: $data['email'],
                                    type: LinkContactType::Email,
                                    style: LinkContactStyle::Filled,
                                    size: LinkContactSize::ExtraSmall
                                ) ?>
                            <?php endif; ?>
                        </div>
                    <?php endif; ?>
                    <?php if ($hasCta): ?>
                        <?= Button::drawButtonMain(
                            className: 'header__cta',
                            text: htmlspecialchars($data['buttonText']),
                            style: ButtonMainStyle::Secondary,
                            size: ButtonMainSize::Small,
                            attributes: $ctaAttrs
                        ) ?>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <div class="header__line">
            <div class="header__container">
                <?= Separator::drawSeparator() ?>
            </div>
        </div>
    </div>
    <?php
    return (string)ob_get_clean();
};
?>

<header class="<?= htmlspecialchars(trim(implode(' ', $headerClasses))) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <?= $data['banner'] ?>
    <?= $drawBar('header-nav', false) ?>
</header>

<?php // Закреплённая копия: вне потока (position: fixed), поэтому вёрстка не сдвигается; скрыта и недоступна, пока не показана ?>
<div class="header header--fixed" data-header-fixed aria-hidden="true" inert>
    <?= $drawBar('header-fixed-nav', true) ?>
</div>

<?= MobileMenu::drawMobileMenu(
    id: $data['mobileMenuId'],
    items: $data['items'],
    logoName: $data['logoName'],
    logoSrc: $data['logoSrc'],
    logoHref: $data['logoHref'],
    phone: $data['phone'],
    email: $data['email'],
    socials: $data['socials'],
    buttonText: $data['buttonText'],
    buttonModal: $data['buttonModal'],
    geo: $data['geo']
) ?>

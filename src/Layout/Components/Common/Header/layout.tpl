<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Common\Header\Layout as Header;
use Simflex\Core\Layout\Components\Common\MobileMenu\Layout as MobileMenu;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactStyle;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogoAnim\Layout as BrandLogoAnim;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialSize;

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
                    <?= Button::drawButton(
                        className: 'header__cta header__cta_top',
                        text: htmlspecialchars($data['buttonText']),
                        style: ButtonStyle::Secondary,
                        size: ButtonSize::Small,
                        attributes: $ctaAttrs
                    ) ?>
                <?php endif; ?>
                <?= Button::drawButton(
                    className: 'header__burger',
                    iconLeft: 'menu-2-line',
                    style: ButtonStyle::Gray,
                    size: ButtonSize::Medium,
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
                                <?php if ($href !== '' && SocialNetwork::tryFrom((string)$network)): ?>
                                    <?= Social::drawSocial(
                                        network: SocialNetwork::from((string)$network),
                                        href: $href,
                                        size: SocialSize::Small
                                    ) ?>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                    <?php if ($data['phone'] !== '' || $data['email'] !== ''): ?>
                        <div class="header__contacts">
                            <?php if ($data['phone'] !== ''): ?>
                                <?= Contact::drawContact(
                                    text: $data['phone'],
                                    value: $data['phone'],
                                    type: ContactType::Phone,
                                    style: ContactStyle::Filled,
                                    size: ContactSize::ExtraSmall
                                ) ?>
                            <?php endif; ?>
                            <?php if ($data['email'] !== ''): ?>
                                <?= Contact::drawContact(
                                    text: $data['email'],
                                    value: $data['email'],
                                    type: ContactType::Email,
                                    style: ContactStyle::Filled,
                                    size: ContactSize::ExtraSmall
                                ) ?>
                            <?php endif; ?>
                        </div>
                    <?php endif; ?>
                    <?php if ($hasCta): ?>
                        <?= Button::drawButton(
                            className: 'header__cta',
                            text: htmlspecialchars($data['buttonText']),
                            style: ButtonStyle::Secondary,
                            size: ButtonSize::Small,
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

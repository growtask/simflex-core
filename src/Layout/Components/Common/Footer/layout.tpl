<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\LinkContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\Parts\Brand\BrandLogo\Layout as BrandLogo;
use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeBy\Layout as BrandMadeBy;
use Simflex\Core\Layout\Components\Parts\Brand\BrandMadeIn\Layout as BrandMadeIn;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Other\Separator\SeparatorOrientation;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\ButtonSocialSmallTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;

$e = fn(string $s): string => htmlspecialchars($s, ENT_QUOTES, 'UTF-8');
$columns = $data['columns'];
$buttonAttrs = $data['modal'] !== '' ? ['data-modal' => $data['modal']] : [];
?>

<footer class="<?= $e(trim('footer ' . ($data['className'] ?? ''))) ?>">
    <?php // Контейнер: слева контакты, затем вертикальная линия и колонки меню ?>
    <div class="footer__container">
        <div class="footer__contact-us">
            <div class="footer__callback">
                <?= BrandLogo::drawBrandLogo(
                    className: 'footer__logo',
                    name: $data['logoName'],
                    src: $data['logoSrc']
                ) ?>
                <?= Button::drawButtonMain(
                    className: 'footer__button',
                    text: $data['callbackText'],
                    style: ButtonMainStyle::Primary,
                    size: ButtonMainSize::Medium,
                    attributes: $buttonAttrs
                ) ?>
            </div>

            <?php if ($data['phone'] !== '' || $data['email'] !== '' || $data['socials']): ?>
                <div class="footer__contacts">
                    <?php if ($data['phone'] !== ''): ?>
                        <div class="footer__phone">
                            <span class="footer__desc">Телефон:</span>
                            <?= Contact::drawLinkContact(
                                text: $data['phone'],
                                value: $data['phone'],
                                type: LinkContactType::Phone,
                                size: LinkContactSize::Small
                            ) ?>
                        </div>
                    <?php endif; ?>

                    <?php if ($data['email'] !== ''): ?>
                        <div class="footer__mail">
                            <span class="footer__desc">Почта:</span>
                            <?= Contact::drawLinkContact(
                                text: $data['email'],
                                value: $data['email'],
                                type: LinkContactType::Email,
                                size: LinkContactSize::Small
                            ) ?>
                        </div>
                    <?php endif; ?>

                    <?php if ($data['socials']): ?>
                        <div class="footer__socials-container">
                            <span class="footer__desc">Соцсети:</span>
                            <div class="footer__socials">
                                <?php foreach ($data['socials'] as $network => $href): ?>
                                    <?= Social::drawButtonSocialSmall(
                                        network: ButtonSocialSmallNetwork::from($network),
                                        href: $href,
                                        size: ButtonSocialSmallSize::Small,
                                        theme: ButtonSocialSmallTheme::Dark
                                    ) ?>
                                <?php endforeach; ?>
                            </div>
                        </div>
                    <?php endif; ?>
                </div>
            <?php endif; ?>
        </div>

        <?php if ($columns): ?>
            <?= Separator::drawSeparator(className: 'footer__line', orientation: SeparatorOrientation::Vertical) ?>

            <nav class="footer__menu" aria-label="Меню подвала">
                <?php foreach ($columns as $column): ?>
                    <div class="footer__column">
                        <p class="footer__column-title"><?= $e(rtrim($column['title'], ':')) ?>:</p>
                        <ul class="footer__tab-list">
                            <?php foreach ($column['links'] as $link): ?>
                                <li class="footer__tab-item">
                                    <?= Tab::drawTabMain(
                                        text: $e($link['text']),
                                        link: $link['href'],
                                        style: TabMainStyle::Flat,
                                        size: TabMainSize::Small,
                                        active: !empty($link['active'])
                                    ) ?>
                                </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endforeach; ?>
            </nav>
        <?php endif; ?>
    </div>

    <?= Separator::drawSeparator(className: 'footer__bottom-line') ?>

    <div class="footer__bottom-info">
        <p class="footer__copyright">© <?= $e($data['company']) ?> <?= (int)$data['year'] ?></p>
        <div class="footer__dev-info">
            <?= BrandMadeIn::drawBrandMadeIn(
                className: 'footer__made-in',
                href: $data['madeInHref'],
                name: $data['madeInName'],
                label: 'Создано в студии ' . $data['madeInName']
            ) ?>
            <?= BrandMadeBy::drawBrandMadeBy(
                className: 'footer__made-by',
                href: $data['madeByHref'],
                name: $data['madeByName'],
                label: 'Сайт работает на ' . $data['madeByName']
            ) ?>
        </div>
    </div>
</footer>

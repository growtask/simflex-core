<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactSize;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\ContactType;
use Simflex\Core\Layout\Components\UI\Link\LinkContact\Layout as Contact;
use Simflex\Core\Layout\Components\UI\Other\Logo\Layout as Logo;
use Simflex\Core\Layout\Components\UI\Other\Logo\LogoType;
use Simflex\Core\Layout\Components\UI\Other\Separator\Layout as Separator;
use Simflex\Core\Layout\Components\UI\Other\Separator\SeparatorOrientation;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\Layout as Social;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialNetwork;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall\SocialTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;

$e = fn(string $s): string => htmlspecialchars($s, ENT_QUOTES, 'UTF-8');
$columns = $data['columns'];
$buttonAttrs = $data['modal'] !== '' ? ['data-modal' => $data['modal']] : [];
?>

<footer class="<?= $e(trim('footer ' . ($data['className'] ?? ''))) ?>">
    <?php // Контейнер: слева контакты, затем вертикальная линия и колонки меню ?>
    <div class="footer__container">
        <div class="footer__contact-us">
            <div class="footer__callback">
                <?= Logo::drawLogo(
                    className: 'footer__logo',
                    name: $data['logoName'],
                    src: $data['logoSrc'],
                    type: LogoType::Static
                ) ?>
                <?= Button::drawButton(
                    className: 'footer__button',
                    text: $data['callbackText'],
                    style: ButtonStyle::Primary,
                    size: ButtonSize::Medium,
                    attributes: $buttonAttrs
                ) ?>
            </div>

            <?php if ($data['phone'] !== '' || $data['email'] !== '' || $data['socials']): ?>
                <div class="footer__contacts">
                    <?php if ($data['phone'] !== ''): ?>
                        <div class="footer__phone">
                            <span class="footer__desc">Телефон:</span>
                            <?= Contact::drawContact(
                                text: $data['phone'],
                                value: $data['phone'],
                                type: ContactType::Phone,
                                size: ContactSize::Small
                            ) ?>
                        </div>
                    <?php endif; ?>

                    <?php if ($data['email'] !== ''): ?>
                        <div class="footer__mail">
                            <span class="footer__desc">Почта:</span>
                            <?= Contact::drawContact(
                                text: $data['email'],
                                value: $data['email'],
                                type: ContactType::Email,
                                size: ContactSize::Small
                            ) ?>
                        </div>
                    <?php endif; ?>

                    <?php if ($data['socials']): ?>
                        <div class="footer__socials-container">
                            <span class="footer__desc">Соцсети:</span>
                            <div class="footer__socials">
                                <?php foreach ($data['socials'] as $network => $href): ?>
                                    <?= Social::drawSocial(
                                        network: SocialNetwork::from($network),
                                        href: $href,
                                        size: SocialSize::Small,
                                        theme: SocialTheme::Dark
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
                                    <?= Tab::drawTab(
                                        text: $e($link['text']),
                                        link: $link['href'],
                                        style: TabStyle::Flat,
                                        size: TabSize::Small,
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
            <?= Logo::drawLogo(
                className: 'footer__made-in',
                href: $data['madeInHref'],
                name: $data['madeInName'],
                label: 'Создано в студии ' . $data['madeInName'],
                external: true,
                type: LogoType::MadeIn
            ) ?>
            <?= Logo::drawLogo(
                className: 'footer__made-by',
                href: $data['madeByHref'],
                name: $data['madeByName'],
                label: 'Сайт работает на ' . $data['madeByName'],
                external: true,
                type: LogoType::MadeBy
            ) ?>
        </div>
    </div>
</footer>

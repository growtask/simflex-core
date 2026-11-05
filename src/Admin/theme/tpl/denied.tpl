<?php

/**
 * Нет доступа к админке (вошёл пользователь без привилегии admin): карточка как у входа, «Выйти» и «На сайт»
 * @var \Simflex\Core\Admin\Page $page
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;

$theme = $page->getTheme();
// компоненты рисуются до head: их стили собирает $page->getMeta()
$card = $page->drawLogo('auth__logo', '/')
    . '<div class="auth-card auth-card-theme_' . $theme . '">'
    . '<h1 class="auth-card__title">Недостаточно прав для входа в панель управления</h1>'
    . '<p class="auth-card__text">Войдите под учётной записью с доступом к админке.</p>'
    . '<div class="auth-card__buttons">'
    . Button::drawButton(text: 'Выйти', link: Page::url('logout'), theme: ButtonTheme::from($theme), iconLeft: 'log-out')
    . Button::drawButton(text: 'На сайт', link: '/', style: ButtonStyle::Secondary, theme: ButtonTheme::from($theme))
    . '</div></div>'
    . '<p class="auth__version">Simflex CMS v' . htmlspecialchars(getSimflexVersion()) . '</p>';
?>
<!DOCTYPE html>
<html lang="ru" data-theme="<?= $theme ?>">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="<?= asset('fonts/inter.css') ?>"/>
        <link rel="shortcut icon" href="<?= asset('img/favicon-admin.ico') ?>" type="image/x-icon">
        <title>Нет доступа | Simflex Admin</title>
        <?= $page->getMeta() ?>
    </head>
    <body>
        <main class="auth"><?= $card ?></main>
    </body>
</html>

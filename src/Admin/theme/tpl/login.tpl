<?php

/**
 * Вход в админку (компонент макета login-card): логин и пароль с иконками, «Запомнить меня», ошибка входа
 * уведомлением над полями, «Не помню пароль» — форма восстановления growtask.ru в iframe
 * @var \Simflex\Core\Admin\Page $page
 * @var string $back Адрес, на который вернуться после входа
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Extensions\Alert\Alert;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\System\Container;

$theme = $page->getTheme();
$messages = Alert::drawAdminMessages($theme);
$errorAttributes = $messages['notices'] !== '' ? ['aria-invalid' => 'true'] : [];
$action = Page::url('login') . '?r=' . urlencode($back);
// компоненты рисуются до head: их стили собирает $page->getMeta()
$card = $page->drawLogo('auth__logo', '/')
    . '<form class="auth-card auth-card-theme_' . $theme . '" method="post" action="'
    . htmlspecialchars($action) . '">'
    . '<h1 class="auth-card__title">Вход в панель управления</h1>'
    . $messages['notices']
    . '<div class="auth-card__fields">'
    . TextInput::drawInputMain(
        placeholder: 'Логин',
        labelText: 'Логин',
        theme: InputMainTheme::from($theme),
        icon: 'user',
        attributes: [
            'name' => 'login[login]',
            'autocomplete' => 'username',
            'autocapitalize' => 'off',
            'required' => 'required',
            'autofocus' => 'autofocus',
        ] + $errorAttributes,
    )
    . TextInput::drawInputMain(
        placeholder: 'Пароль',
        labelText: 'Пароль',
        theme: InputMainTheme::from($theme),
        icon: 'lock-on',
        attributes: ['name' => 'login[password]', 'required' => 'required'] + $errorAttributes,
        kind: InputMainKind::Password,
    )
    . '</div>'
    . Checkbox::drawSwitchCheckbox(
        text: 'Запомнить меня',
        theme: SwitchCheckboxTheme::from($theme),
        attributes: ['name' => 'login[remember]', 'checked' => 'checked'],
    )
    . '<div class="auth-card__buttons">'
    . Button::drawButtonMain(
        text: 'Войти',
        theme: ButtonMainTheme::from($theme),
        attributes: ['type' => 'submit'],
    )
    . Button::drawButtonMain(
        className: 'auth-card__restore',
        text: 'Не помню пароль',
        style: ButtonMainStyle::Secondary,
        theme: ButtonMainTheme::from($theme),
    )
    . '</div>'
    . '<p class="auth-card__text" id="login-restore-sent" role="status" hidden>Заявка успешно отправлена</p>'
    . '</form>'
    . '<p class="auth__version">Simflex CMS v' . htmlspecialchars(getSimflexVersion()) . '</p>';
$restoreUrl = 'https://growtask.ru/remoteform.php?tpl=pass&ws=https://' . Container::getRequest()->getHost();
?>
<!DOCTYPE html>
<html lang="ru" data-theme="<?= $theme ?>">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="<?= asset('fonts/inter.css') ?>"/>
        <?= $page->drawFavicon() ?>
        <title>Simflex Admin</title>
        <?= $page->getMeta() ?>
    </head>
    <body>
        <main class="auth"><?= $card ?></main>
        <iframe class="auth__restore-frame" id="iframe-login" title="Восстановление пароля"
                src="<?= htmlspecialchars($restoreUrl) ?>" hidden></iframe>
        <script>
            // восстановление пароля: форма growtask.ru поверх страницы, ответ — postMessage close-iframe / success
            (() => {
                const frame = document.getElementById('iframe-login');
                document.querySelector('.auth-card__restore').addEventListener('click', () => {
                    frame.hidden = false;
                });
                window.addEventListener('message', (event) => {
                    if (event.data === 'close-iframe' || event.data === 'success') {
                        frame.hidden = true;
                    }
                    if (event.data === 'success') {
                        document.getElementById('login-restore-sent').hidden = false;
                    }
                });
            })();
        </script>
    </body>
</html>

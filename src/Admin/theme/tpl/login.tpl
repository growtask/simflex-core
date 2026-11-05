<?php

/**
 * Вход в админку (компонент макета login-card): логин и пароль с иконками, «Запомнить меня», ошибка входа
 * уведомлением над полями, «Не помню пароль» — форма восстановления growtask.ru в iframe
 * @var \Simflex\Core\Admin\Page $page
 * @var string $back Адрес, на который вернуться после входа
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Extensions\Alert\Alert;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Core\Checkbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;
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
    . TextInput::drawInput(
        placeholder: 'Логин',
        labelText: 'Логин',
        theme: TextInputTheme::from($theme),
        icon: 'user',
        attributes: [
            'name' => 'login[login]',
            'autocomplete' => 'username',
            'autocapitalize' => 'off',
            'required' => 'required',
            'autofocus' => 'autofocus',
        ] + $errorAttributes,
    )
    . TextInput::drawInput(
        placeholder: 'Пароль',
        labelText: 'Пароль',
        theme: TextInputTheme::from($theme),
        icon: 'lock-on',
        attributes: ['name' => 'login[password]', 'required' => 'required'] + $errorAttributes,
        kind: TextInputKind::Password,
    )
    . '</div>'
    . Checkbox::drawCheckbox(
        text: 'Запомнить меня',
        theme: CheckboxTheme::from($theme),
        attributes: ['name' => 'login[remember]', 'checked' => 'checked'],
    )
    . '<div class="auth-card__buttons">'
    . Button::drawButton(
        text: 'Войти',
        theme: ButtonTheme::from($theme),
        attributes: ['type' => 'submit'],
    )
    . Button::drawButton(
        className: 'auth-card__restore',
        text: 'Не помню пароль',
        style: ButtonStyle::Secondary,
        theme: ButtonTheme::from($theme),
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
        <link rel="shortcut icon" href="<?= asset('img/favicon-admin.ico') ?>" type="image/x-icon">
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

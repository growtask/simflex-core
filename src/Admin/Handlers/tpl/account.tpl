<?php

/**
 * Профиль текущего пользователя (Handlers\Account): роль и логин, имя, email, новый пароль; выход
 * @var array{role_name: string, login: string, name: string, email: string} $data
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputKind;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputLabelPos;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$theme = Page::get()->getTheme();
$input = fn(string $label, string $name, string $value, array $attributes = [], TextInputKind $kind = TextInputKind::Text)
    => '<div class="form-input">' . TextInput::drawInput(
        placeholder: $label,
        labelText: $label,
        labelPos: TextInputLabelPos::Standard,
        theme: TextInputTheme::from($theme),
        id: 'account-' . $name,
        attributes: $attributes + ($name !== '' ? ['name' => $name] : []),
        kind: $kind,
        value: $value,
        reset: false,
    ) . '</div>';
$save = Button::drawButton(
    text: 'Сохранить',
    size: ButtonSize::Small,
    theme: ButtonTheme::from($theme),
    attributes: ['type' => 'submit'],
    iconLeft: 'check',
);
?>
<form class="edit-form edit-form-theme_<?= $theme ?>" action="" method="post" data-sf="edit-form">
    <?= Page::get()->drawPageHead('Данные пользователя', $save) ?>
    <div class="edit-layout">
        <div class="edit-main">
            <section class="form-section form-section_open" data-sf-form-section>
                <h2 class="form-section__title">
                    <button type="button" class="form-section__head" aria-expanded="true" aria-controls="account-main">
                        <span class="form-section__name">Учётная запись</span>
                        <?= renderIcon('chevron-m-down', 'form-section__chevron') ?>
                    </button>
                </h2>
                <div class="form-section__body" id="account-main">
                    <div class="form-section__grid">
                        <?= $input('Роль', '', (string)$data['role_name'], ['disabled' => 'disabled']) ?>
                        <?= $input('Логин', '', (string)$data['login'], ['disabled' => 'disabled']) ?>
                        <?= $input('Имя', 'name', (string)$data['name']) ?>
                        <?= $input('E-mail', 'email', (string)$data['email'], kind: TextInputKind::Email) ?>
                        <?= $input('Новый пароль', 'password', '', [
                            'autocomplete' => 'new-password',
                            'placeholder' => 'Оставьте пустым, если не требуется изменить',
                        ], TextInputKind::Password) ?>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <div class="edit-bar edit-bar-theme_<?= $theme ?>" role="toolbar" aria-label="Сохранение">
        <?= $save ?>
        <?= Button::drawButton(
            text: 'Выйти из админки',
            link: Page::url('logout'),
            style: ButtonStyle::Outline,
            size: ButtonSize::Small,
            theme: ButtonTheme::from($theme),
            iconLeft: 'log-out',
        ) ?>
    </div>
</form>

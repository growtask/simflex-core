<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormCallback;

use Simflex\Core\Extensions\Form\FormGuard;
use Simflex\Core\Layout\Components\Base\Form\FormResult\Layout as Result;
use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultStyle;
use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultTheme;
use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultType;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Textarea\Layout as Textarea;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaState;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\System\Container;

/**
 * Форма «Связаться с нами» (Figma: Base/Form/callback): имя, телефон, почта, комментарий, согласие и кнопка.
 *
 * Форма отправляется скриптом компонента (fetch, JSON) на $action; результат показывается на месте формы
 * компонентом Result. Клиентская проверка: обязательные поля, формат телефона и почты, согласие; фокус уходит
 * на первое поле с ошибкой, у поля aria-invalid и текст ошибки в aria-describedby. Ответ сервера:
 * {success: bool, errors: {поле: текст}, message: текст}. Сервер всё проверяет сам, см. FormGuard.
 *
 * Скрипт реагирует на кнопки результата: data-callback-action="reset" (новая форма, у формы в окне Modal -
 * закрывает окно), "retry" (вернуться к форме с введёнными данными).
 */
class Layout extends LayoutBase
{
    /**
     * @param string $id Идентификатор формы (префикс id полей); если пуст, создаётся автоматически
     * @param string $action Адрес отправки
     * @param string $form Тип формы, уходит на сервер полем form (callback, ...)
     * @param bool $name Поле «Имя» (обязательное)
     * @param bool $phone Поле «Телефон» (обязательное)
     * @param bool $email Поле «Почта»
     * @param bool $comment Поле «Комментарий»
     * @param bool $emailRequired Почта обязательна (подписка на рассылку)
     * @param bool $consent Согласие на обработку данных (обязательно для отправки)
     * @param string $policyUrl Адрес политики обработки персональных данных
     * @param string $consentText HTML подписи согласия; пусто - стандартная со ссылкой на политику
     * @param string $captcha HTML виджета капчи (стоит перед кнопкой), по умолчанию пусто
     * @param bool $guard Добавить защиту от ботов (ловушка и токен, см. FormGuard)
     * @param string $submitText Текст кнопки отправки
     * @param array<string,string> $values Значения полей: name, phone, email, comment
     * @param array<string,string> $errors Ошибки полей (при state=error): name, phone, email, comment, consent
     * @param array<string,string> $texts Тексты результата: successTitle, successText, successButton, errorTitle, errorText, errorButton
     * @param array<string,string> $hidden Дополнительные скрытые поля: имя => значение
     * @param string $className Дополнительные CSS-классы корня
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawFormCallback(
        string $id = '',
        string $action = '/form/callback',
        string $form = 'callback',
        bool $name = true,
        bool $phone = true,
        bool $email = true,
        bool $comment = true,
        bool $emailRequired = false,
        bool $consent = true,
        string $policyUrl = '/policy',
        string $consentText = '',
        string $captcha = '',
        bool $guard = true,
        string $submitText = 'Отправить',
        array $values = [],
        array $errors = [],
        array $texts = [],
        array $hidden = [],
        FormCallbackLayout $layout = FormCallbackLayout::Grid,
        FormCallbackState $state = FormCallbackState::Default,
        FormCallbackTheme $theme = FormCallbackTheme::Light,
        string $className = '',
        array $attributes = []
    ): string {
        if ($id === '') {
            $id = 'callback-' . substr(md5(uniqid('', true)), 0, 8);
        }

        $texts += [
            'successTitle' => 'Заявка отправлена',
            'successText' => 'Мы свяжемся с вами в ближайшее время',
            'successButton' => 'OK',
            'errorTitle' => 'Не удалось отправить',
            'errorText' => 'Попробуйте ещё раз немного позже',
            'errorButton' => 'Повторить',
        ];

        $dark = $theme === FormCallbackTheme::Dark;
        $inputTheme = $dark ? InputMainTheme::Dark : InputMainTheme::Light;
        $hasErrors = $state === FormCallbackState::Error;
        $sending = $state === FormCallbackState::Sending;
        $err = fn(string $field): string => $hasErrors ? (string)($errors[$field] ?? '') : '';
        $fieldAttrs = fn(string $field, array $attrs): array => $attrs
            + ($err($field) !== '' ? ['aria-invalid' => 'true'] : [])
            + ($sending ? ['readonly' => ''] : []);

        $fields = [];
        if ($name) {
            $fields['name'] = TextInput::drawInputMain(
                className: 'callback__field callback__field_name',
                placeholder: 'Иван',
                labelText: 'Имя*',
                labelPos: InputMainLabelPos::Standard,
                theme: $inputTheme,
                id: "$id-name",
                attributes: $fieldAttrs('name', [
                    'name' => 'name', 'type' => 'text', 'required' => '', 'aria-required' => 'true',
                    'autocomplete' => 'name', 'maxlength' => '100', 'value' => (string)($values['name'] ?? ''),
                ]),
            );
        }
        if ($phone) {
            $fields['phone'] = TextInput::drawInputMain(
                className: 'callback__field callback__field_phone',
                placeholder: '+7 999 123-45-67',
                labelText: 'Телефон*',
                labelPos: InputMainLabelPos::Standard,
                theme: $inputTheme,
                icon: 'phone',
                id: "$id-phone",
                attributes: $fieldAttrs('phone', [
                    'name' => 'phone', 'type' => 'tel', 'required' => '', 'aria-required' => 'true',
                    'autocomplete' => 'tel', 'inputmode' => 'tel', 'maxlength' => '30',
                    'value' => (string)($values['phone'] ?? ''),
                ]),
            );
        }
        if ($email) {
            $fields['email'] = TextInput::drawInputMain(
                className: 'callback__field callback__field_email',
                placeholder: 'name@example.com',
                labelText: $emailRequired ? 'Почта*' : 'Почта',
                labelPos: InputMainLabelPos::Standard,
                theme: $inputTheme,
                icon: 'mail',
                id: "$id-email",
                attributes: $fieldAttrs('email', [
                    'name' => 'email', 'type' => 'email', 'autocomplete' => 'email', 'maxlength' => '100',
                    ...($emailRequired ? ['required' => '', 'aria-required' => 'true'] : []),
                    'value' => (string)($values['email'] ?? ''),
                ]),
            );
        }
        if ($comment) {
            $fields['comment'] = Textarea::drawTextarea(
                className: 'callback__field callback__field_comment',
                value: (string)($values['comment'] ?? ''),
                placeholder: 'Что вас интересует?',
                labelText: 'Комментарий',
                maxLength: 300,
                id: "$id-comment",
                theme: $dark ? TextareaTheme::Dark : TextareaTheme::Light,
                state: $err('comment') !== '' ? TextareaState::Error : TextareaState::Default,
                attributes: ['name' => 'comment', 'rows' => '2'] + ($sending ? ['readonly' => ''] : []),
            );
        }

        $consentHtml = '';
        if ($consent) {
            $policy = htmlspecialchars($policyUrl, ENT_QUOTES);
            $consentHtml = Checkbox::drawSwitchCheckbox(
                className: 'callback__consent',
                text: $consentText !== ''
                    ? $consentText
                    : 'Я принимаю <a href="' . $policy . '" target="_blank" rel="noopener">политику обработки персональных данных</a>',
                theme: $dark ? SwitchCheckboxTheme::Dark : SwitchCheckboxTheme::Light,
                attributes: ['name' => 'consent', 'value' => '1', 'required' => '', 'aria-required' => 'true']
                    + ($err('consent') !== '' ? ['aria-invalid' => 'true'] : []),
            );
        }

        $submit = Button::drawButtonMain(
            className: 'callback__submit',
            text: htmlspecialchars($submitText),
            style: ButtonMainStyle::Primary,
            size: ButtonMainSize::Medium,
            theme: $dark ? ButtonMainTheme::Dark : ButtonMainTheme::Light,
            load: $sending,
            disabled: $sending,
            attributes: ['type' => 'submit'],
        );

        $resultTheme = $dark ? FormResultTheme::Dark : FormResultTheme::Light;
        $resultType = $layout === FormCallbackLayout::Stack ? FormResultType::Vertical : FormResultType::Horizontal;
        $success = Result::drawFormResult(
            title: $texts['successTitle'],
            text: $texts['successText'],
            buttonText: $texts['successButton'],
            style: FormResultStyle::Success,
            type: $resultType,
            theme: $resultTheme,
            buttonAttributes: ['data-callback-action' => 'reset'],
        );
        $failure = Result::drawFormResult(
            title: $texts['errorTitle'],
            text: $texts['errorText'],
            buttonText: $texts['errorButton'],
            style: FormResultStyle::Error,
            type: $resultType,
            theme: $resultTheme,
            buttonAttributes: ['data-callback-action' => 'retry'],
        );

        // служебные поля: тип формы, страница, защита от ботов
        // адрес страницы: без запроса (вывод из консоли, витрина в тестах) поле пустое
        $page = Container::isSet('request') ? Container::getRequest()->getFullUrl() : '';
        $hiddenFields = ['form' => $form, 'page' => $page] + $hidden;
        $guardHtml = $guard ? [FormGuard::TOKEN_FIELD => (new FormGuard())->issueToken()] : [];

        return static::draw(
            compact(
                'id',
                'action',
                'fields',
                'consentHtml',
                'captcha',
                'guard',
                'submit',
                'success',
                'failure',
                'hiddenFields',
                'guardHtml',
                'className',
                'attributes',
                'sending'
            ) + [
                'errorsJson' => $hasErrors ? json_encode(array_map('strval', $errors), JSON_UNESCAPED_UNICODE | JSON_HEX_APOS | JSON_HEX_QUOT) : '',
                'layout' => $layout->value,
                'state' => $state->value,
                'theme' => $theme->value,
            ]
        );
    }
}

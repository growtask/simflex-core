<?php

namespace Simflex\Core\Layout\Components\Base\Form\FormMailing;

use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackLayout;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackState;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackTheme;
use Simflex\Core\Layout\Components\Base\Form\FormCallback\Layout as FormCallback;
use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\Layout\LayoutManager;

/**
 * Подписка на рассылку (Figma Form/mailing): поле почты с кнопкой, необязательные капча и согласие. Собрана из
 * FormCallback (те же проверка, отправка и результат на месте формы), поэтому адрес приёма и ответ сервера
 * такие же, как у формы «Связаться с нами»
 */
class Layout extends LayoutBase
{
    /**
     * @param string $action Адрес приёма подписки
     * @param string $captcha HTML виджета капчи
     * @param bool $consent Согласие на обработку данных
     * @param array<string,string> $texts Тексты результата (successTitle, successText, successButton, errorTitle, ...)
     * @param array<string,mixed> $values Значения полей (email)
     * @param array<string,string> $errors Ошибки полей
     * @param bool $guard Защита от ботов (ловушка и токен)
     */
    public static function drawFormMailing(
        string           $id = '',
        string           $action = '/form/mailing',
        string           $captcha = '',
        bool             $consent = true,
        string           $policyUrl = '/policy',
        string           $submitText = 'Подписаться',
        array            $texts = [],
        array            $values = [],
        array            $errors = [],
        bool             $guard = true,
        FormCallbackState $state = FormCallbackState::Default,
        FormMailingTheme $theme = FormMailingTheme::Light,
        string           $className = '',
    ): string {
        LayoutManager::useLayout(static::class);

        return FormCallback::drawFormCallback(
            id: $id,
            action: $action,
            form: 'mailing',
            name: false,
            phone: false,
            email: true,
            comment: false,
            emailRequired: true,
            consent: $consent,
            policyUrl: $policyUrl,
            captcha: $captcha,
            guard: $guard,
            submitText: $submitText,
            values: $values,
            errors: $errors,
            texts: $texts + [
                'successTitle' => 'Вы подписаны',
                'successText' => 'Первое письмо придёт на вашу почту',
            ],
            layout: FormCallbackLayout::Grid,
            state: $state,
            theme: FormCallbackTheme::from($theme->value),
            className: trim('mailing ' . $className),
        );
    }
}

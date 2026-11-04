<?php

namespace Simflex\Core\Layout\Components\UI\Core\TextInput;

use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Core\Calendar\CalendarMode;
use Simflex\Core\Layout\Components\UI\Core\Calendar\CalendarTheme;
use Simflex\Core\Layout\Components\UI\Core\Calendar\Layout as Calendar;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле ввода (набор Figma Inputs/main и заготовки phone, email).
 *
 * - kind: phone — type="tel", маска +7 (999) 123-45-67 и счётчик цифр 0/11 (скрипт компонента, в форму уходят цифры),
 *   email — type="email", проверка при потере фокуса;
 * - error: текст ошибки под полем (aria-invalid, aria-describedby), цвет текста и сообщения — error;
 * - value: введённое значение (состояние filled);
 * - counter и maxLength: счётчик «n/max» справа в поле, лимит — атрибутом maxlength;
 * - password — type="password" и кнопка-глаз «Показать пароль» справа (aria-pressed);
 * - date, datetime, time — маска ДД.ММ.ГГГГ, ДД.ММ.ГГГГ ЧЧ:ММ, ЧЧ:ММ и кнопка календаря (Calendar под полем,
 *   aria-haspopup="dialog"); значение в поле — в этом формате, min и max — даты 'Y-m-d' в attributes;
 * - success: принятый ввод (цвет текста success);
 * - slot: HTML справа в поле (кнопка календаря и т. п.), вместо кнопки очистки.
 * Подпись снаружи — labelPos Standard, без подписи — Hidden (подпись остаётся для скринридера).
 */
class Layout extends LayoutBase
{
    /** Число цифр телефона с кодом страны (+7 и 10 цифр) */
    public const PHONE_DIGITS = 11;

    /**
     * @param string $id Идентификатор поля; пусто — вычисляется из названия и подписи
     * @param array<string,string> $attributes Атрибуты input (name, required, disabled, autocomplete и т. д.)
     * @param bool|null $counter Показать счётчик; null — для phone включён, для остальных выключен
     * @param int $maxLength Максимальная длина (для phone — число цифр, по умолчанию 11)
     * @param string $errorInvalid Сообщение о неверном формате (phone, email) при потере фокуса
     * @param bool $success Состояние success: ввод принят
     * @param string $slot HTML справа в поле (кнопки ButtonIcon); с ним кнопки очистки нет
     */
    public static function drawInput(
        string            $className = '',
        string            $placeholder = '',
        string            $labelText = '',
        TextInputLabelPos $labelPos = TextInputLabelPos::Hidden,
        TextInputStyle    $style = TextInputStyle::Filled,
        TextInputSize     $size = TextInputSize::Medium,
        TextInputTheme    $theme = TextInputTheme::Light,
        string            $icon = '',
        bool              $reset = true,
        string            $id = '',
        array             $attributes = [],
        TextInputKind     $kind = TextInputKind::Text,
        string            $value = '',
        string            $error = '',
        ?bool             $counter = null,
        int               $maxLength = 0,
        string            $errorInvalid = '',
        bool              $success = false,
        string            $slot = '',
    ): string {
        $attributes += match ($kind) {
            TextInputKind::Phone => [
                'type' => 'tel',
                'inputmode' => 'tel',
                'autocomplete' => 'tel',
            ],
            TextInputKind::Email => [
                'type' => 'email',
                'inputmode' => 'email',
                'autocomplete' => 'email',
                'autocapitalize' => 'off',
                'spellcheck' => 'false',
            ],
            TextInputKind::Password => [
                'type' => 'password',
                'autocomplete' => 'current-password',
                'autocapitalize' => 'off',
                'spellcheck' => 'false',
            ],
            default => [],
        };
        $calendarMode = match ($kind) {
            TextInputKind::Date => CalendarMode::Date,
            TextInputKind::DateTime => CalendarMode::DateTime,
            TextInputKind::Time => CalendarMode::Time,
            default => null,
        };
        if ($calendarMode !== null) {
            [$mask, $hint] = match ($calendarMode) {
                CalendarMode::Date => ['##.##.####', 'ДД.ММ.ГГГГ'],
                CalendarMode::DateTime => ['##.##.#### ##:##', 'ДД.ММ.ГГГГ ЧЧ:ММ'],
                CalendarMode::Time => ['##:##', 'ЧЧ:ММ'],
            };
            $min = (string)($attributes['min'] ?? '');
            $max = (string)($attributes['max'] ?? '');
            unset($attributes['min'], $attributes['max']);
            $attributes += [
                'inputmode' => 'numeric',
                'autocomplete' => 'off',
                'data-sf-date' => $calendarMode->value,
                'data-date-mask' => $mask,
            ];
            $placeholder = $placeholder ?: $hint;
            $isTime = $calendarMode === CalendarMode::Time;
            $slot .= ButtonIcon::drawButtonIcon(
                icon: $isTime ? 'alarm' : 'calendar',
                label: $isTime ? 'Выбрать время' : 'Выбрать дату',
                className: 'text-input__date-toggle',
                theme: ButtonIconTheme::from($theme->value),
                attributes: ['aria-haspopup' => 'dialog', 'aria-expanded' => 'false', 'data-sf-date-toggle' => ''],
                disabled: isset($attributes['disabled']) || isset($attributes['readonly']),
            );
            $popup = '<div class="text-input__calendar" role="dialog" aria-label="'
                . ($isTime ? 'Выбор времени' : 'Выбор даты') . '" hidden>'
                . Calendar::drawCalendar(
                    mode: $calendarMode,
                    theme: CalendarTheme::from($theme->value),
                    min: $min,
                    max: $max,
                ) . '</div>';
        }
        if ($kind === TextInputKind::Password) {
            $slot .= ButtonIcon::drawButtonIcon(
                icon: 'eye',
                label: 'Показать пароль',
                className: 'text-input__password-toggle',
                theme: ButtonIconTheme::from($theme->value),
                attributes: ['aria-pressed' => 'false', 'data-sf-password-toggle' => '', 'title' => ''],
            );
        }
        if ($slot !== '') {
            $reset = false;
        }
        $popup ??= '';
        if ($kind === TextInputKind::Phone) {
            $attributes['data-mask'] = '+7 (###) ###-##-##';
            $maxLength = $maxLength ?: self::PHONE_DIGITS;
            $placeholder = $placeholder ?: '+7 (___) ___-__-__';
            $errorInvalid = $errorInvalid ?: 'Введите номер полностью';
        } elseif ($kind === TextInputKind::Email) {
            $errorInvalid = $errorInvalid ?: 'Введите корректный email';
        }
        $icon = $icon ?: match ($kind) {
            TextInputKind::Phone => 'phone',
            TextInputKind::Email => 'mail',
            default => '',
        };
        $counter ??= $kind === TextInputKind::Phone;
        if ($counter && $maxLength <= 0) {
            $counter = false;
        }
        // У телефона maxlength не задаём: маска длиннее числа цифр, лимит цифр держит скрипт
        if ($maxLength > 0 && $kind !== TextInputKind::Phone) {
            $attributes['maxlength'] = (string)$maxLength;
        }
        if ($id === '') {
            $id = 'text-input-' . substr(md5($kind->value . ($attributes['name'] ?? '') . $labelText . $placeholder), 0, 8);
        }
        $length = $kind === TextInputKind::Phone ? strlen(preg_replace('/\D/', '', $value)) : mb_strlen($value);

        return static::draw(
            compact(
                'className',
                'placeholder',
                'labelText',
                'icon',
                'reset',
                'id',
                'value',
                'error',
                'counter',
                'maxLength',
                'length',
                'errorInvalid',
                'attributes',
                'success',
                'slot',
                'popup'
            ) + [
                'style' => $style->value,
                'labelPos' => $labelPos->value,
                'size' => $size->value,
                'theme' => $theme->value,
                'kind' => $kind->value,
            ]
        );
    }
}

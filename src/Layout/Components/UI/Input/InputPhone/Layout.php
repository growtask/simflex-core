<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputPhone;

use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainLabelPos;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainStyle;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Поле телефона с выбором страны (Figma Inputs/phone): плитка с флагом и шевроном открывает список стран
 * (название и код), справа — поле номера по маске страны с кнопкой очистки. Список открывается вниз, а если
 * снизу нет места — вверх. В форму уходит скрытое поле name с номером вместе с кодом страны (79161234567),
 * видимое поле имени не имеет. Размеры, стили, темы и подпись — как у TextInput (его enum'ы)
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string $name Имя скрытого поля с полным номером (цифры, код страны первым)
     * @param string $value Номер с кодом страны (цифры или +код…); страна определяется по коду, пусто — страна $country
     * @param InputPhoneCountry $country Страна по умолчанию
     * @param list<InputPhoneCountry> $countries Страны в списке; по умолчанию все
     * @param string $placeholder Подсказка; пусто — маска страны (___)
     * @param string $error Текст ошибки под полем
     * @param array<string,string> $attributes Атрибуты поля номера (required, disabled и т. д.)
     */
    public static function drawInputPhone(
        string            $name = 'phone',
        string            $value = '',
        InputPhoneCountry      $country = InputPhoneCountry::Ru,
        array             $countries = [],
        string            $placeholder = '',
        string            $labelText = '',
        InputMainLabelPos $labelPos = InputMainLabelPos::Hidden,
        InputMainStyle    $style = InputMainStyle::Filled,
        InputMainSize     $size = InputMainSize::Medium,
        InputMainTheme    $theme = InputMainTheme::Light,
        string            $error = '',
        bool              $success = false,
        string            $id = '',
        string            $className = '',
        array             $attributes = [],
    ): string {
        $countries = $countries ?: InputPhoneCountry::cases();
        if (!in_array($country, $countries, true)) {
            $country = $countries[0];
        }
        $digits = preg_replace('/\D/', '', $value);
        if ($digits !== '') {
            // страна по коду в номере: самый длинный код, при равных — первая в списке
            $best = null;
            foreach ($countries as $candidate) {
                $dial = $candidate->dial();
                if (str_starts_with($digits, $dial) && ($best === null || strlen($dial) > strlen($best->dial()))) {
                    $best = $candidate;
                }
            }
            if ($best !== null) {
                $country = $best;
                $digits = substr($digits, strlen($best->dial()));
            }
        }
        $national = $country->format($digits);
        $digits = preg_replace('/\D/', '', $national);
        $fullValue = $digits === '' ? '' : $country->dial() . $digits;
        $id = $id !== '' ? $id : 'sf-phone-' . ++self::$counter;
        $disabled = isset($attributes['disabled']);
        $field = TextInput::drawInputMain(
            className: 'phone-input__input',
            placeholder: $placeholder !== '' ? $placeholder : str_replace('#', '_', $country->mask()),
            labelText: $labelText,
            labelPos: $labelPos,
            style: $style,
            size: $size,
            theme: $theme,
            id: $id,
            attributes: $attributes + [
                'type' => 'tel',
                'inputmode' => 'tel',
                'autocomplete' => 'tel-national',
                'data-sf-phone-field' => '',
            ],
            value: $national,
            error: $error,
            success: $success,
        );

        return static::draw(compact(
            'name',
            'country',
            'countries',
            'fullValue',
            'field',
            'disabled',
            'placeholder',
            'id',
            'className'
        ) + [
            'size' => $size->value,
            'theme' => $theme->value,
            'style' => $style->value,
            'hasError' => $error !== '',
        ]);
    }
}

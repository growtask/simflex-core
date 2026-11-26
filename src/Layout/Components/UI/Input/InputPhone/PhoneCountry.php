<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputPhone;

/**
 * Страна в поле телефона PhoneInput: название, телефонный код, маска национального номера (# — цифра).
 * Флаг рисует CSS (класс phone-flag_<значение>), картинок не нужно
 */
enum PhoneCountry: string
{
    case Ru = 'ru';
    case By = 'by';
    case Am = 'am';
    case Ge = 'ge';
    case Kz = 'kz';
    case Uz = 'uz';

    public function label(): string
    {
        return match ($this) {
            self::Ru => 'Россия',
            self::By => 'Беларусь',
            self::Am => 'Армения',
            self::Ge => 'Грузия',
            self::Kz => 'Казахстан',
            self::Uz => 'Узбекистан',
        };
    }

    /** Телефонный код страны без плюса */
    public function dial(): string
    {
        return match ($this) {
            self::Ru, self::Kz => '7',
            self::By => '375',
            self::Am => '374',
            self::Ge => '995',
            self::Uz => '998',
        };
    }

    /** Маска национального номера, # — цифра */
    public function mask(): string
    {
        return match ($this) {
            self::Ru, self::Kz => '(###) ###-##-##',
            self::By => '(##) ###-##-##',
            self::Am => '## ###-###',
            self::Ge => '(###) ##-##-##',
            self::Uz => '## ###-##-##',
        };
    }

    /** Сколько цифр в национальном номере */
    public function digits(): int
    {
        return substr_count($this->mask(), '#');
    }

    /** Национальный номер по маске: лишнее отбрасывается, недостающее не дописывается */
    public function format(string $digits): string
    {
        $digits = substr(preg_replace('/\D/', '', $digits), 0, $this->digits());
        $result = '';
        $index = 0;
        foreach (str_split($this->mask()) as $char) {
            if ($index >= strlen($digits)) {
                break;
            }
            $result .= $char === '#' ? $digits[$index++] : $char;
        }

        return $result;
    }
}

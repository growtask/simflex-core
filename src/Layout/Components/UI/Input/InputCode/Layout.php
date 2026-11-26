<?php

namespace Simflex\Core\Layout\Components\UI\Input\InputCode;

use Simflex\Core\Layout\LayoutBase;

/**
 * Поле одноразового кода (Figma Inputs/code): отдельные поля под цифры, 4–6 штук. Набор переводит фокус на следующую
 * цифру, Backspace — на предыдущую, вставка кода из буфера раскладывается по полям, значение целиком лежит в скрытом
 * поле name (события input и change на нём), на заполнении всех цифр на корне срабатывает событие sf-code-complete
 * (detail.value). Состояния Error и Success выводят сообщение под полем (script.js)
 */
class Layout extends LayoutBase
{
    public const MIN_LENGTH = 4;
    public const MAX_LENGTH = 6;

    /**
     * @param string $name Имя скрытого поля с кодом целиком
     * @param int $length Число цифр, от 4 до 6
     * @param string $value Уже введённый код (только цифры, лишние отбрасываются)
     * @param string $message Сообщение под полем для состояний Error и Success (экранируется)
     * @param string $label Доступное имя группы полей
     * @param string $id Идентификатор группы; пусто — вычисляется
     * @param array<string,string> $attributes Атрибуты корневого элемента
     */
    public static function drawInputCode(
        string         $name = 'code',
        int            $length = 6,
        string         $value = '',
        InputCodeState $state = InputCodeState::Default,
        string         $message = '',
        string         $label = 'Код из сообщения',
        InputCodeTheme $theme = InputCodeTheme::Light,
        string         $id = '',
        string         $className = '',
        array          $attributes = [],
    ): string {
        $length = max(self::MIN_LENGTH, min(self::MAX_LENGTH, $length));
        $code = substr((string)preg_replace('/\D/', '', $value), 0, $length);
        $digits = $code === '' ? [] : str_split($code);
        $id = $id !== '' ? $id : 'code-input-' . substr(md5($name . $label . $length), 0, 8);

        return static::draw(compact('name', 'length', 'message', 'label', 'id', 'className', 'attributes', 'digits') + [
            'value' => $code,
            'state' => $state->value,
            'theme' => $theme->value,
        ]);
    }
}

<?php

namespace Simflex\Core\Layout\Components\Parts\System\SystemConsent;

use Simflex\Core\Layout\LayoutBase;

/**
 * Согласие на обработку персональных данных (Figma, блок System: consent): чекбокс solid s и «Я принимаю
 * политику обработки персональных данных» со ссылкой. Ставится в форме перед кнопкой отправки;
 * ссылка - на настоящую политику. Собрано из Checkbox и Link.
 */
class Layout extends LayoutBase
{
    /**
     * @param bool $error Ошибка: согласие не поставлено
     * @param array<string,string> $attributes Атрибуты input (по умолчанию name="consent", required)
     */
    public static function drawConsent(
        string       $text = 'Я принимаю',
        string       $linkText = 'политику обработки персональных данных',
        string       $policyUrl = '/policy',
        ConsentTheme $theme = ConsentTheme::Light,
        bool         $error = false,
        string       $className = '',
        array        $attributes = []
    ): string {
        return static::draw([
            'text' => $text,
            'linkText' => $linkText,
            'policyUrl' => $policyUrl,
            'theme' => $theme->value,
            'error' => $error,
            'className' => $className,
            'attributes' => $attributes + ['name' => 'consent', 'required' => 'required'],
        ]);
    }
}

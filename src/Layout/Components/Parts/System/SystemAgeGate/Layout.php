<?php

namespace Simflex\Core\Layout\Components\Parts\System\SystemAgeGate;

use Simflex\Core\Layout\LayoutBase;

/**
 * Проверка возраста (Figma, блок System: age-gate): окно поверх затемнённой страницы - логотип, вопрос,
 * «Да, есть» и «Нет». Закрывает страницу до ответа. Выводите, пока посетитель не ответил (ответ хранит сайт).
 * Кнопки помечены data-sf-age-gate-action="confirm|decline"; script.js держит фокус в окне, по «Да» убирает окно
 * и шлёт на document событие sf:age-gate с detail { action }; что делать при отказе, решает сайт.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $logoHtml HTML логотипа (BrandLogo::drawBrandLogo); пусто - без логотипа
     * @param bool $inline Не закрывать страницу, а выводить в рамке в потоке (витрина)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawAgeGate(
        AgeGateTheme $theme = AgeGateTheme::Light,
        string       $title = 'Вам есть 18 лет?',
        string       $text = 'Часть контента только для взрослых.',
        string       $confirmText = 'Да, есть',
        string       $declineText = 'Нет',
        string       $logoHtml = '',
        bool         $inline = false,
        string       $className = '',
        array        $attributes = []
    ): string {
        return static::draw([
            'theme' => $theme->value,
            'title' => $title,
            'text' => $text,
            'confirmText' => $confirmText,
            'declineText' => $declineText,
            'logoHtml' => $logoHtml,
            'inline' => $inline,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}

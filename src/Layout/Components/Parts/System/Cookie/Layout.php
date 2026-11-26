<?php

namespace Simflex\Core\Layout\Components\Parts\System\Cookie;

use Simflex\Core\Layout\LayoutBase;

/**
 * Плашка cookie (Figma, блок System: cookie): текст, ссылка на политику, «Принять все», «Настройки», «Отклонить»;
 * в настройках - переключатели категорий и «Сохранить выбор». Не блокирует страницу.
 * Выбор запоминает сайт (например, cookie cookie_consent): выводите плашку, только пока выбора нет. Кнопки помечены
 * data-sf-cookie-action="accept|settings|decline|save", переключатели - name="cookie-<категория>"; script.js
 * переключает вид, убирает плашку и шлёт на document событие sf:cookie-choose { action, choice }; cookie он не пишет.
 */
class Layout extends LayoutBase
{
    /**
     * @param array<int,array{key:string,text:string,required?:bool}> $categories Категории cookie
     * @param string $policyUrl Ссылка на политику; пусто - без строки «Подробнее»
     * @param bool $inline Не закреплять у края окна, а выводить в потоке страницы (витрина, страница настроек)
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawCookie(
        CookieState    $state = CookieState::Default,
        CookieTheme    $theme = CookieTheme::Light,
        CookiePosition $position = CookiePosition::Bottom,
        string         $title = 'Сайт использует cookie',
        string         $text = 'Мы используем cookie и сторонние сервисы, чтобы анализировать трафик, подбирать контент и улучшать сайт.',
        string         $settingsTitle = 'Настройки cookie',
        string         $settingsText = 'Выберите, какие cookie может хранить сайт. Необходимые включены всегда.',
        string         $policyUrl = '/policy',
        array          $categories = [
            ['key' => 'necessary', 'text' => 'Необходимые', 'required' => true],
            ['key' => 'analytics', 'text' => 'Аналитика'],
            ['key' => 'marketing', 'text' => 'Маркетинг'],
        ],
        bool           $inline = false,
        string         $className = '',
        array          $attributes = []
    ): string {
        return static::draw([
            'state' => $state->value,
            'theme' => $theme->value,
            'position' => $position->value,
            'title' => $title,
            'text' => $text,
            'settingsTitle' => $settingsTitle,
            'settingsText' => $settingsText,
            'policyUrl' => $policyUrl,
            'categories' => $categories,
            'inline' => $inline,
            'className' => $className,
            'attributes' => $attributes,
        ]);
    }
}

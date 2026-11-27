<?php

namespace Simflex\Core\Layout\Components\Services\Step\StepMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Блок «Как мы работаем» (Figma Services/Steps/main): заголовок, до шести шагов и кнопка. Шаг — ItemBenefit (число
 * «01», заголовок, текст и бейдж времени), шаги соединяет линия; у последнего её нет. progress — пройденные шаги
 * (done) отмечены маркером с галочкой. Default: на FullHD и HD шаги в ряд, на планшете сеткой по три, на телефоне
 * столбиком с вертикальной линией; Scroll — карточки в слайдере SliderMain
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array{title:string,text?:string,badge?:string,done?:bool}> $steps Шаги (до 6): badge — срок
     *        («1 день»), done — пройден (при progress)
     * @param string $title Заголовок блока; пусто — без него (Figma head)
     * @param bool $progress Отмечать пройденные шаги (Figma progress)
     * @param string $actionText Текст кнопки; пусто — без неё (Figma action)
     * @param string $actionLink Адрес кнопки
     * @param array<string,mixed> $actionAttributes HTML-атрибуты кнопки
     * @param string $className Дополнительные CSS-классы (steps_view_tablet, steps_view_mobile — вид для витрины)
     */
    public static function drawStepMain(
        array         $steps,
        string        $title = 'Как мы работаем',
        StepMainStyle $style = StepMainStyle::Default,
        StepMainTheme $theme = StepMainTheme::Light,
        bool          $progress = false,
        string        $actionText = '',
        string        $actionLink = '',
        array         $actionAttributes = [],
        int           $headingLevel = 2,
        string        $className = '',
    ): string {
        $steps = array_slice(array_values(array_filter($steps, static fn($s) => is_array($s) && ($s['title'] ?? '') !== '')), 0, 6);

        return static::draw(compact('steps', 'title', 'progress', 'actionText', 'actionLink', 'actionAttributes', 'className') + [
            'style' => $style->value,
            'theme' => $theme->value,
            'headingLevel' => min(6, max(1, $headingLevel)),
        ]);
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Textarea;

use Simflex\Core\Layout\LayoutBase;

/**
 * Многострочное поле ввода со счётчиком символов (Figma: UI/textarea)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы корня
     * @param string $value Введённый текст
     * @param string $placeholder Подсказка в пустом поле
     * @param string $labelText Подпись поля (при TextareaLabelPos::Hidden уходит в aria-label)
     * @param string $message Сообщение под полем (для состояний Error и Success)
     * @param int $maxLength Предел символов (maxlength), 0 — без предела
     * @param bool $counter Показывать счётчик «введено/предел»
     * @param string $id Идентификатор поля; если пуст, создаётся автоматически
     * @param array<string,mixed> $attributes HTML-атрибуты самого textarea (name, required, disabled и т. д.)
     */
    public static function drawTextarea(
        string            $className = '',
        string            $value = '',
        string            $placeholder = '',
        string            $labelText = '',
        string            $message = '',
        int               $maxLength = 300,
        bool              $counter = true,
        string            $id = '',
        TextareaLabelPos  $labelPos = TextareaLabelPos::Outside,
        TextareaStyle     $style = TextareaStyle::Filled,
        TextareaSize      $size = TextareaSize::Medium,
        TextareaTheme     $theme = TextareaTheme::Light,
        TextareaState     $state = TextareaState::Default,
        array             $attributes = []
    ): string {
        if ($id === '') {
            $id = 'textarea-' . substr(md5(uniqid('', true)), 0, 8);
        }

        return static::draw(
            compact(
                'className',
                'value',
                'placeholder',
                'labelText',
                'message',
                'maxLength',
                'counter',
                'id',
                'attributes'
            ) + [
                'labelPos' => $labelPos->value,
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
                'state' => $state->value,
            ]
        );
    }
}

<?php

namespace Simflex\Core\Layout\Components\UI\Core\Toast;

use Simflex\Core\Layout\LayoutBase;

/**
 * Тост (набор Figma Feedback/toast) и стопка тостов (Feedback/stack): короткое временное сообщение поверх страницы,
 * исчезает само (не меньше 5 секунд, пауза при наведении и фокусе, Esc закрывает). Не больше трёх одновременно.
 * Тосты из JS: window.sfToast(message, {type, action: {text, href | onClick}, timeout, timer, icon}) — нужна стопка
 * drawStack() на странице, тост собирается из её шаблонов
 */
class Layout extends LayoutBase
{
    /** Минимальное время показа, мс */
    public const MIN_TIMEOUT = 5000;

    /**
     * @param string $text Текст (экранируется)
     * @param bool $icon Иконка по стилю (набор notify)
     * @param string $actionText Подпись действия справа (действие должно быть доступно и без тоста)
     * @param string $actionLink Адрес действия; без него действие — кнопка (обработчик вешает JS)
     * @param bool $timer Линия таймера у нижнего края
     * @param int $timeout Время показа, мс (не меньше MIN_TIMEOUT)
     */
    public static function drawToast(
        string     $text,
        ToastStyle $style = ToastStyle::Default,
        ToastWidth $width = ToastWidth::Hug,
        bool       $icon = false,
        string     $actionText = '',
        string     $actionLink = '',
        bool       $timer = false,
        int        $timeout = self::MIN_TIMEOUT,
        string     $className = '',
    ): string {
        $timeout = max($timeout, self::MIN_TIMEOUT);

        return static::draw(compact('text', 'icon', 'actionText', 'actionLink', 'timer', 'timeout', 'className') + [
            'style' => $style->value,
            'width' => $width->value,
            'iconId' => $style->getIcon(),
        ]);
    }

    /**
     * Стопка тостов: контейнер (живой регион) с тостами, которые есть при выводе страницы, и шаблонами тостов
     * для window.sfToast()
     * @param string $toasts HTML тостов (drawToast)
     * @param string $className Класс расположения стопки на странице
     */
    public static function drawStack(
        string     $toasts = '',
        ToastWidth $width = ToastWidth::Hug,
        string     $className = '',
    ): string {
        $templates = '';
        foreach (ToastStyle::cases() as $style) {
            $toast = static::drawToast('', $style, $width, icon: true, actionText: ' ', timer: true);
            $templates .= '<template data-sf-toast-template="' . $style->value . '">' . trim($toast) . '</template>';
        }

        return '<div class="toast-stack ' . htmlspecialchars($className) . '" data-sf-toast-stack aria-live="polite">'
            . $toasts . $templates . '</div>';
    }
}

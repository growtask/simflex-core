<?php

namespace Simflex\Core\Layout\Components\UI\Selector\SelectorMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Сегментный селектор (Figma Selector/main и Selector/item): ряд сегментов, выбран один. Переключает значение
 * на месте — вид списка, период, способ получения. Кнопки с aria-pressed; скрипт переносит выбор и шлёт событие
 * sf-selector-change (detail.value). С name в форму уходит скрытое поле с выбранным значением
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array{text?:string,value?:string,icon?:string,badge?:string,active?:bool,disabled?:bool}> $items
     *        Сегменты: text — подпись, value — значение (по умолчанию text), icon — иконка слева, badge — бейдж справа,
     *        active — выбран; если не отмечен ни один, выбирается первый
     * @param string $name Имя скрытого поля формы; пусто — поля нет
     * @param bool $fill Сегменты поровну на всю ширину (width=fill в Figma); иначе по содержимому (hug)
     * @param string $label Доступное имя группы
     */
    public static function drawSelectorMain(
        array         $items,
        SelectorMainStyle $style = SelectorMainStyle::Filled,
        SelectorMainSize  $size = SelectorMainSize::Medium,
        SelectorMainTheme $theme = SelectorMainTheme::Light,
        bool          $fill = false,
        string        $name = '',
        string        $label = '',
        string        $className = '',
    ): string {
        $items = array_values($items);
        $activeIndex = null;
        foreach ($items as $index => $item) {
            if (!empty($item['active']) && empty($item['disabled'])) {
                $activeIndex = $index;
                break;
            }
        }
        if ($activeIndex === null) {
            foreach ($items as $index => $item) {
                if (empty($item['disabled'])) {
                    $activeIndex = $index;
                    break;
                }
            }
        }
        foreach ($items as $index => &$item) {
            $item['text'] = (string)($item['text'] ?? '');
            $item['value'] = (string)($item['value'] ?? $item['text']);
            $item['active'] = $index === $activeIndex;
        }
        unset($item);

        return static::draw(compact('items', 'name', 'fill', 'label', 'className') + [
            'style' => $style->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

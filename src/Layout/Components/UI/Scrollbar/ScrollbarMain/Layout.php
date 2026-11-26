<?php

namespace Simflex\Core\Layout\Components\UI\Scrollbar\ScrollbarMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Полоса прокрутки (Figma Scrollbar/scrollbar и Scrollbar/arrow): прокручиваемый блок со своей полосой — ползунок
 * тянется, щелчок по дорожке листает на страницу, стрелки (arrows) двигают на шаг. Без скрипта и на сенсорных
 * устройствах работает системная полоса. Для обычных блоков, где нужна только окраска системной полосы,
 * есть SCSS-примесь scrollbar($style, $size, $theme) — ею стилизован список Dropdown
 */
class Layout extends LayoutBase
{
    /**
     * @param string $content HTML содержимого блока
     * @param string $height Высота блока (CSS: 240px, 50vh); у вертикальной полосы нужна, иначе нечего прокручивать
     * @param bool $arrows Стрелки на концах полосы
     * @param string $label Доступное имя прокручиваемой области
     */
    public static function drawScrollbarMain(
        string             $content,
        ScrollbarMainStyle     $style = ScrollbarMainStyle::Classic,
        ScrollbarMainDirection $direction = ScrollbarMainDirection::Vertical,
        ScrollbarMainSize      $size = ScrollbarMainSize::Medium,
        bool               $arrows = false,
        ScrollbarMainTheme     $theme = ScrollbarMainTheme::Light,
        string             $height = '',
        string             $label = '',
        string             $className = '',
    ): string {
        return static::draw(compact('content', 'arrows', 'height', 'label', 'className') + [
            'style' => $style->value,
            'direction' => $direction->value,
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }
}

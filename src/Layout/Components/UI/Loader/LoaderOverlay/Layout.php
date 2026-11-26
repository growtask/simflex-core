<?php

namespace Simflex\Core\Layout\Components\UI\Loader\LoaderOverlay;

use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Загрузка-подложка поверх блока (Figma Loaders/overlay): полупрозрачная вуаль со спиннером закрывает блок, пока
 * он обновляется, чтобы посетитель не действовал по старым данным. Ставится поверх блока, а не всей страницы.
 * Вуаль растягивается на обёртку (position: relative), блок внутри получает aria-busy и становится неактивным
 */
class Layout extends LayoutBase
{
    /**
     * @param string $content HTML блока, который обновляется
     * @param bool $active Показать вуаль; false — только обёртка (скрипт страницы включает её классом loader-overlay_active)
     * @param string $label Текст для скринридера
     */
    public static function drawLoaderOverlay(
        string      $content,
        bool        $active = true,
        LoaderMainTheme $theme = LoaderMainTheme::Light,
        string      $label = 'Загрузка',
        string      $className = '',
    ): string {
        $loader = LoaderIcon::drawLoaderMain(LoaderMainSize::Medium, LoaderMainStyle::Primary, $theme, $label);

        return static::draw(compact('content', 'active', 'loader', 'className') + ['theme' => $theme->value]);
    }
}

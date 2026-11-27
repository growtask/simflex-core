<?php

namespace Simflex\Core\Layout\Components\Base\Slider\SliderMain;

use Simflex\Core\Http\Assets;
use Simflex\Core\Http\PageAssets;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\Layout as SliderStep;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepSize;
use Simflex\Core\Layout\Components\Base\Slider\SliderStep\SliderStepTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\LayoutBase;

/**
 * Слайдер (Figma Base/slider/main): секция с заголовком, кнопкой «Показать все», стрелками и рядом карточек, который
 * листается вбок. Листание — swiper (assetsGlobal/swiper): стрелки, свайп, перетаскивание мышью, клавиатура в ряду
 * (стрелки, PageUp/PageDown, Home/End), индикатор шагов SliderStep показывает долю прокрутки.
 * fullhd/hd: заголовок h2, справа «Показать все» и стрелки, 4 карточки (step=s — 5) через 20. tablet/mobile:
 * карточки фиксированной ширины, «Показать все» под рядом, на mobile и с индикатором шагов стрелок нет.
 * Карточки — любой HTML, каждая в своём слайде; высота слайдов выравнивается по самой высокой.
 */
class Layout extends LayoutBase
{
    /** Версия swiper в assetsGlobal/swiper */
    public const SWIPER = '11.1.3';

    public static function initAssets(): void
    {
        static::useSwiper();
        parent::initAssets();
    }

    /**
     * Подключает swiper (css и js раньше скриптов компонентов): для своих слайдеров компонентов (TariffList и др.)
     */
    public static function useSwiper(): void
    {
        $dir = dirname(__DIR__, 4) . '/assetsGlobal/swiper/' . self::SWIPER;
        PageAssets::css(Assets::publish($dir . '/swiper-bundle.min.css'), 50);
        PageAssets::js(Assets::publish($dir . '/swiper-bundle.min.js'), 50);
    }

    /**
     * @param string[] $cards HTML карточек (каждая — отдельный слайд)
     * @param string $title Заголовок секции (экранируется)
     * @param bool $heading Заголовок и «Показать все» (Figma heading)
     * @param string $allLink Адрес «Показать все» (Figma show all); пусто — кнопки нет
     * @param string $allText Текст «Показать все»
     * @param string $label Доступное имя ряда; пусто — заголовок
     * @param int $headingLevel Уровень заголовка (h1–h6)
     * @param string $className Дополнительные CSS-классы корня (slider_view_tablet, slider_view_mobile — вид этой
     *        ширины экрана на любой, для витрины)
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawSliderMain(
        array           $cards,
        string          $title = '',
        SliderMainType  $type = SliderMainType::Arrows,
        SliderMainStep  $step = SliderMainStep::Medium,
        SliderMainTheme $theme = SliderMainTheme::Light,
        bool            $heading = true,
        string          $allLink = '',
        string          $allText = 'Показать все',
        string          $label = '',
        int             $headingLevel = 2,
        string          $className = '',
        array           $attributes = [],
    ): string {
        $buttonTheme = ButtonMainTheme::from($theme->value);
        $all = static fn(string $place): string => $heading && $allLink !== '' ? Button::drawButtonMain(
            className: 'slider__all slider__all_' . $place,
            text: htmlspecialchars($allText),
            link: $allLink,
            style: ButtonMainStyle::Gray,
            theme: $buttonTheme,
        ) : '';
        $arrow = static fn(string $dir, string $text): string => Button::drawButtonMain(
            className: 'slider__arrow slider__arrow_' . $dir,
            style: ButtonMainStyle::Secondary,
            theme: $buttonTheme,
            attributes: ['aria-label' => $text, 'data-sf-slider-' . $dir => ''],
            iconLeft: 'arrow-' . ($dir === 'prev' ? 'left' : 'right'),
            disabled: $dir === 'prev',
        );
        $steps = $type === SliderMainType::Steps ? SliderStep::drawSliderStep(
            className: 'slider__steps',
            count: max(1, min(10, count($cards))),
            label: 'Положение ряда',
            size: $step === SliderMainStep::Small ? SliderStepSize::Small : SliderStepSize::Medium,
            theme: SliderStepTheme::from($theme->value),
        ) : '';

        return static::draw([
            'cards' => array_values($cards),
            'title' => $title,
            'heading' => $heading,
            'headingLevel' => min(6, max(1, $headingLevel)),
            'label' => $label !== '' ? $label : ($title !== '' ? $title : 'Карточки'),
            'className' => $className,
            'attributes' => $attributes,
            'type' => $type->value,
            'step' => $step->value,
            'theme' => $theme->value,
            'allTop' => $all('top'),
            'allBottom' => $all('bottom'),
            'arrows' => $type !== SliderMainType::None ? $arrow('prev', 'Назад') . $arrow('next', 'Вперёд') : '',
            'steps' => $steps,
        ]);
    }
}

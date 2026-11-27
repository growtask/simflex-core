<?php

namespace Simflex\Core\Layout\Components\Services\Tariff\TariffList;

use Simflex\Core\Layout\Components\Base\Slider\SliderMain\Layout as SliderMain;
use Simflex\Core\Layout\Components\Services\Tariff\TariffMain\Layout as TariffMain;
use Simflex\Core\Layout\Components\Services\Tariff\TariffMain\TariffMainTheme;
use Simflex\Core\Layout\LayoutBase;

/**
 * Блок тарифов (Figma Services/Tariff/list): переключатель периода «Помесячно | В год» (SelectorMain) и ряд карточек
 * TariffMain через 24. Переключатель меняет цены сразу у всех тарифов (класс tariff-list_period_year). На FullHD и HD
 * тарифы в ряд, на планшете и телефоне — слайдер (swiper) с точками, листается свайпом
 */
class Layout extends LayoutBase
{
    public static function initAssets(): void
    {
        SliderMain::useSwiper();
        parent::initAssets();
    }

    /**
     * @param list<array<string,mixed>> $tariffs Тарифы: параметры TariffMain::drawTariffMain() (name, price, year…)
     * @param string $monthText Подпись периода «за месяц»
     * @param string $yearText Подпись периода «за год»
     * @param string $yearBadge Бейдж у периода «за год» («-20%»); пусто — без него
     * @param bool $periods Переключатель периода; false — без него (цены за месяц)
     * @param string $className Дополнительные CSS-классы (tariff-list_view_mobile — вид телефона для витрины)
     */
    public static function drawTariffList(
        array            $tariffs,
        TariffListPeriod $period = TariffListPeriod::Month,
        TariffListTheme  $theme = TariffListTheme::Light,
        string           $monthText = 'Помесячно',
        string           $yearText = 'В год',
        string           $yearBadge = '',
        bool             $periods = true,
        string           $className = '',
    ): string {
        $cards = [];
        foreach ($tariffs as $tariff) {
            if (is_array($tariff) && ($tariff['name'] ?? '') !== '') {
                $cards[] = TariffMain::drawTariffMain(...$tariff + ['theme' => TariffMainTheme::from($theme->value)]);
            }
        }

        return static::draw([
            'cards' => $cards,
            'period' => $period->value,
            'theme' => $theme->value,
            'monthText' => $monthText,
            'yearText' => $yearText,
            'yearBadge' => $yearBadge,
            'periods' => $periods,
            'className' => $className,
        ]);
    }
}

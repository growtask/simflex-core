<?php

namespace Simflex\Core\Layout\Components\Services\Tariff\TariffTable;

use Simflex\Core\Layout\LayoutBase;

/**
 * Таблица сравнения тарифов (Figma Services/Tariff/table): до трёх тарифов колонками и до восьми возможностей строками
 * (входит — check, не входит — close, подсказка TooltipInfo). Рекомендуемый тариф (featured) — колонка color1/lighter
 * и кнопка primary. На телефоне виден один тариф: селектор над таблицей переключает его (script.js)
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array{name:string,price?:string,buttonText?:string,buttonLink?:string,featured?:bool}> $plans Тарифы (до 3)
     * @param list<array{text:string,hint?:string,values:list<bool>}> $features Возможности (до 8): values — входит ли
     *        в каждый тариф, по порядку plans
     * @param string $title Заголовок колонки возможностей
     * @param bool $buttons Кнопки выбора под ценами (Figma buttons)
     * @param string $className Дополнительные CSS-классы (tariff-table_view_mobile — вид телефона для витрины)
     */
    public static function drawTariffTable(
        array            $plans,
        array            $features,
        string           $title = 'Функции',
        bool             $buttons = true,
        TariffTablePlan  $plan = TariffTablePlan::All,
        TariffTableTheme $theme = TariffTableTheme::Light,
        string           $className = '',
    ): string {
        $plans = array_slice(array_values(array_filter($plans, static fn($p) => is_array($p) && ($p['name'] ?? '') !== '')), 0, 3);
        $features = array_slice(array_values(array_filter($features, static fn($f) => is_array($f) && ($f['text'] ?? '') !== '')), 0, 8);
        $active = match ($plan) {
            TariffTablePlan::Standard => 1,
            TariffTablePlan::Premium => 2,
            default => 0,
        };

        return static::draw([
            'plans' => $plans,
            'features' => $features,
            'title' => $title,
            'buttons' => $buttons,
            'active' => min($active, max(0, count($plans) - 1)),
            'theme' => $theme->value,
            'className' => $className,
            'id' => 'tariff-table-' . substr(md5(serialize($plans) . serialize($features)), 0, 8),
        ]);
    }
}

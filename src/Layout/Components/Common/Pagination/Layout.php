<?php

namespace Simflex\Core\Layout\Components\Common\Pagination;

use Simflex\Core\Layout\LayoutBase;

/**
 * Пагинация (Figma nav/pagination, design-base-nav.md): стрелки, номера страниц (текущая — aria-current="page")
 * или «10 / 20», переход на страницу по номеру. Номера на телефоне короче: первая, текущая, последняя
 */
class Layout extends LayoutBase
{
    /** Пропуск номеров */
    public const GAP = null;

    /**
     * @param int $page Текущая страница, с 1
     * @param int $pageCount Число страниц
     * @param string $urlPattern Адрес страницы, {page} заменяется номером: /admin/user?page={page}
     * @param bool $search Переход на страницу: поле «Стр.» и кнопка «Перейти»
     * @param int $urlPageOffset Смещение номера в адресе: -1 — страницы в адресе с нуля (?p=0 — первая)
     */
    public static function drawPagination(
        int             $page,
        int             $pageCount,
        string          $urlPattern,
        PaginationType  $type = PaginationType::Pages,
        PaginationTheme $theme = PaginationTheme::Light,
        bool            $search = true,
        string          $label = 'Страницы',
        string          $className = '',
        int             $urlPageOffset = 0,
    ): string {
        $pageCount = max(1, $pageCount);
        $page = min(max(1, $page), $pageCount);

        $data = compact('page', 'pageCount', 'urlPattern', 'search', 'label', 'className', 'urlPageOffset');

        return static::draw($data + [
            'type' => $type->value,
            'theme' => $theme->value,
            'pages' => static::getPages($page, $pageCount),
            'mobilePages' => static::getMobilePages($page, $pageCount),
        ]);
    }

    /**
     * Номера на десктопе: 1 2 3 4 5 … 19 20 (текущая в начале), 1 … 9 10 11 … 20, 1 2 … 16 17 18 19 20 (в конце);
     * до 7 страниц — все
     * @return list<int|null> номера, null — пропуск
     */
    public static function getPages(int $page, int $pageCount): array
    {
        if ($pageCount <= 7) {
            return range(1, $pageCount);
        }
        if ($page <= 4) {
            return [...range(1, 5), self::GAP, $pageCount - 1, $pageCount];
        }
        if ($page >= $pageCount - 3) {
            return [1, 2, self::GAP, ...range($pageCount - 4, $pageCount)];
        }

        return [1, self::GAP, $page - 1, $page, $page + 1, self::GAP, $pageCount];
    }

    /**
     * Номера на телефоне: первая, текущая, последняя
     * @return list<int> номера без пропусков
     */
    public static function getMobilePages(int $page, int $pageCount): array
    {
        return array_values(array_unique([1, $page, $pageCount]));
    }

    public static function getUrl(string $urlPattern, int $page, int $urlPageOffset = 0): string
    {
        return str_replace('{page}', (string)($page + $urlPageOffset), $urlPattern);
    }
}

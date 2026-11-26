<?php

namespace Simflex\Core\Layout\Components\Base\Seo;

use Simflex\Core\Layout\LayoutBase;

/**
 * SEO-текст (Figma seo/main, design-base-seo.md): текстовый блок для поисковиков внизу страницы — от одной до трёх
 * колонок с заголовком и текстом, ссылка «Читать далее» / «Свернуть» и необязательное облако популярных запросов.
 * Свёрнутый текст остаётся в разметке полностью, обрезается визуально (три строки)
 */
class Layout extends LayoutBase
{
    /** Наибольшее число колонок */
    public const MAX_COLUMNS = 3;

    /**
     * @param list<array{title?: string, text?: string}> $columns Колонки (не больше трёх): заголовок (экранируется)
     *        и текст (HTML редактора, не экранируется)
     * @param list<array{name: string, link: string}> $tags Популярные запросы: ссылки-теги
     * @param bool $more Ссылка «Читать далее» / «Свернуть»; без неё текст всегда раскрыт
     * @param int $headingLevel Уровень заголовков колонок (2 или 3), по месту на странице
     * @return string HTML; пустая строка, если колонок нет
     */
    public static function drawSeo(
        array    $columns,
        array    $tags = [],
        SeoState $state = SeoState::Collapsed,
        bool     $more = true,
        SeoTheme $theme = SeoTheme::Light,
        string   $moreLabel = 'Читать далее',
        string   $lessLabel = 'Свернуть',
        string   $tagsTitle = 'Популярные запросы',
        int      $headingLevel = 2,
        string   $className = '',
    ): string {
        $columns = array_slice(array_values(array_filter(
            $columns,
            static fn(array $column): bool => trim(($column['title'] ?? '') . ($column['text'] ?? '')) !== '',
        )), 0, static::MAX_COLUMNS);
        if ($columns === []) {
            return '';
        }
        $headingLevel = min(max($headingLevel, 2), 3);
        $tags = array_values($tags);

        return static::draw(compact('columns', 'tags', 'more', 'moreLabel', 'lessLabel', 'tagsTitle', 'headingLevel', 'className') + [
            'state' => $more ? $state->value : SeoState::Expanded->value,
            'theme' => $theme->value,
        ]);
    }
}

<?php

namespace Simflex\Core\Layout;

use Simflex\Core\System\Container;

/**
 * Основы дизайн-системы для витрины: токены читаются из SCSS ядра (assetsGlobal/styles), поэтому страница
 * не расходится с кодом. Только для витрины (режим разработки).
 */
class LayoutFoundations
{
    /** Страницы «Основы»: ключ => название */
    public const PAGES = [
        'colors' => 'Цвета',
        'typography' => 'Типографика',
        'shadows' => 'Тени и эффекты',
        'radius' => 'Скругления',
        'motion' => 'Движение',
        'icons' => 'Иконки',
    ];

    /** Названия групп цветов: префикс переменной => название */
    protected const COLOR_GROUPS = [
        'main-gray' => 'Основные: серые',
        'main-color1' => 'Основные: цвет 1',
        'main-color2' => 'Основные: цвет 2',
        'main-gradient1' => 'Основные: градиент',
        'main-bg' => 'Фон',
        'text-icon' => 'Текст и иконки',
        'states-error' => 'Состояния: ошибка',
        'states-alert' => 'Состояния: предупреждение',
        'states-success' => 'Состояния: успех',
        'states-disabled' => 'Состояния: недоступно',
        'states-clear' => 'Состояния: прозрачные',
        'uniq' => 'Разовые акценты',
        'social' => 'Соцсети',
        'delivery' => 'Службы доставки',
    ];

    /**
     * @return array<string, array<string, string>> Группа (название) => переменная (--color-...) => значение
     */
    public static function getColors(): array
    {
        $groups = [];
        foreach (static::variables('abstract/_colors.scss', 'color') as $name => $value) {
            $rest = substr($name, strlen('--color-'));
            $title = null;
            foreach (static::COLOR_GROUPS as $prefix => $groupTitle) {
                if (str_starts_with($rest, $prefix . '-') || $rest === $prefix) {
                    $title = $groupTitle;
                    break;
                }
            }
            $groups[$title ?? 'Прочее'][$name] = $value;
        }

        return $groups;
    }

    /**
     * @return array<string, string> Переменная (--radius-...) => значение режима по умолчанию (m), px
     */
    public static function getRadius(): array
    {
        $default = [];
        foreach (static::getRadiusScale() as $group) {
            if (isset($group['modes']['m'])) {
                $default[$group['variable']] = $group['modes']['m'];
            }
        }

        return $default;
    }

    /**
     * Шкала скруглений как на странице Corner radius в Figma: переменные в группах и их значения во всех режимах.
     * Значения читаются из вызовов radius-mode() в abstract/_radius.scss (в самих переменных они в vw)
     *
     * @return list<array{title: string, variable: string, modes: array<string, string>}>
     *         Режимы идут как в Figma: none, s, m, l, full; значение — в px (0, 4px, 9999px)
     */
    public static function getRadiusScale(): array
    {
        $source = preg_replace('~/\*.*?\*/~s', '', static::read('abstract/_radius.scss')) ?? '';
        $modes = [];
        preg_match_all("/@include radius-mode\('([^']+)',\s*\((.*?)\)\);/s", $source, $calls, PREG_SET_ORDER);
        foreach ($calls as $call) {
            // «:root, [data-radius="m"]» - режим m по умолчанию
            if (!preg_match('/data-radius="(\w+)"/', $call[1], $mode)) {
                continue;
            }
            preg_match_all('/([\w-]+):\s*(0|\d+px)/', $call[2], $values, PREG_SET_ORDER);
            foreach ($values as $value) {
                $modes[$mode[1]]['--radius-' . $value[1]] = $value[2] === '0' ? '0' : $value[2];
            }
        }
        $titles = [
            '--radius-ui-xsmall' => 'extra small', '--radius-ui-small' => 'small', '--radius-ui-medium' => 'medium',
            '--radius-ui-large' => 'large', '--radius-ui-xlarge' => 'extra large', '--radius-blocks' => 'blocks',
        ];
        $scale = [];
        foreach ($titles as $variable => $title) {
            $row = [];
            foreach (['none', 's', 'm', 'l', 'full'] as $mode) {
                if (isset($modes[$mode][$variable])) {
                    $row[$mode] = $modes[$mode][$variable];
                }
            }
            $scale[] = ['title' => $title, 'variable' => $variable, 'modes' => $row];
        }

        return $scale;
    }

    /**
     * @return array<string, string> Переменная (--shadow-...) => значение
     */
    public static function getShadows(): array
    {
        return static::variables('abstract/_shadows.scss', 'shadow');
    }

    /**
     * @return list<string> Названия анимаций (@keyframes)
     */
    public static function getAnimations(): array
    {
        preg_match_all('/@keyframes\s+([\w-]+)/', static::read('abstract/_animations.scss'), $matches);

        return $matches[1];
    }

    /**
     * @return list<array{name: string, size: string, weight: string, lineHeight: string}> Стили текста для рабочего стола
     */
    public static function getTypography(): array
    {
        $source = static::read('tokens/_typography.scss');
        $styles = [];
        // миксины вида `@mixin name { ... }` с собственными размером и весом; ссылающиеся на другой через @include наследуют
        preg_match_all('/@mixin\s+([\w-]+)\s*\{(.*?)\n\}/s', $source, $matches, PREG_SET_ORDER);
        $parsed = [];
        foreach ($matches as $match) {
            $body = $match[2];
            $parsed[$match[1]] = [
                'include' => preg_match('/@include\s+([\w-]+);/', $body, $include) ? $include[1] : null,
                'size' => preg_match('/font-size:\s*vw\((\d+)px\)/', $body, $size) ? $size[1] . 'px' : null,
                'weight' => preg_match('/font-weight:\s*(\d+)/', $body, $weight) ? $weight[1] : null,
                'lineHeight' => preg_match('/line-height:\s*(\d+%)/', $body, $line) ? $line[1] : null,
            ];
        }
        // интерфейсный текст: `@mixin ui-m-light { @include ui-base(16px, 400); }`
        preg_match_all('/@mixin\s+(ui-[\w-]+)\s*\{\s*@include\s+ui-base\((\d+)px(?:,\s*(\d+))?\);/', $source, $uiMatches, PREG_SET_ORDER);
        foreach ($uiMatches as $match) {
            $styles[] = ['name' => $match[1], 'size' => $match[2] . 'px', 'weight' => $match[3] ?? '600', 'lineHeight' => '140%'];
        }
        foreach ($parsed as $name => $style) {
            $resolved = $style;
            if ($style['include'] !== null && isset($parsed[$style['include']])) {
                $base = $parsed[$style['include']];
                foreach (['size', 'weight', 'lineHeight'] as $field) {
                    $resolved[$field] ??= $base[$field];
                }
            }
            if ($resolved['size'] === null || $resolved['weight'] === null || str_ends_with($name, '-lh')) {
                continue;
            }
            $styles[] = [
                'name' => $name,
                'size' => $resolved['size'],
                'weight' => $resolved['weight'],
                'lineHeight' => $resolved['lineHeight'] ?? '140%',
            ];
        }

        return $styles;
    }

    /**
     * @return list<string> Названия иконок спрайта темы сайта (без префикса icon-)
     */
    public static function getIcons(): array
    {
        $file = Container::getPaths()->getRoot('public/assets/' . Container::getConfig()->theme . '/icons/icons.svg');
        if (!is_file($file)) {
            return [];
        }
        preg_match_all('/<symbol[^>]*\sid="icon-([^"]+)"/', (string)file_get_contents($file), $matches);
        $names = $matches[1];
        sort($names, SORT_NATURAL | SORT_FLAG_CASE);

        return $names;
    }

    /**
     * Иконки спрайта по группам страницы Icons в Figma: раздел (action, direction...) и подгруппы внутри него
     *
     * @return list<array{
     *     id: string, title: string, slim: bool, icons: list<string>,
     *     groups: list<array{id: string, title: string, icons: list<string>}>
     * }> Разделы в порядке спрайта; icons раздела — иконки без подгруппы, groups — подгруппы (rotate, save...).
     *    Имена иконок без префикса icon-. Спрайт без групп даёт один раздел «Прочее»
     */
    public static function getIconGroups(): array
    {
        $file = Container::getPaths()->getRoot('public/assets/' . Container::getConfig()->theme . '/icons/icons.svg');
        if (!is_file($file)) {
            return [];
        }
        $xml = simplexml_load_file($file);
        if ($xml === false) {
            return [];
        }
        $svg = 'http://www.w3.org/2000/svg';
        // атрибуты без префикса лежат вне пространства имён SVG: через attributes()
        $attr = static fn(\SimpleXMLElement $element, string $name): string => (string)($element->attributes()[$name] ?? '');
        $names = static function (\SimpleXMLElement $parent) use ($svg, $attr): array {
            $icons = [];
            foreach ($parent->children($svg)->symbol as $symbol) {
                $icons[] = preg_replace('/^icon-/', '', $attr($symbol, 'id'));
            }

            return $icons;
        };
        $sections = [];
        foreach ($xml->children($svg)->g as $group) {
            $id = preg_replace('/^group-/', '', $attr($group, 'id'));
            $title = $attr($group, 'data-title') !== '' ? $attr($group, 'data-title') : $id;
            $subgroups = [];
            foreach ($group->children($svg)->g as $sub) {
                $subgroups[] = [
                    'id' => preg_replace('/^group-/', '', $attr($sub, 'id')),
                    'title' => $attr($sub, 'data-title'),
                    'icons' => $names($sub),
                ];
            }
            $sections[] = [
                'id' => $id,
                'title' => $title,
                'slim' => str_ends_with($id, '-slim'),
                'icons' => $names($group),
                'groups' => $subgroups,
            ];
        }
        $loose = $names($xml);
        if ($loose !== []) {
            $sections[] = ['id' => 'other', 'title' => 'Прочее', 'slim' => false, 'icons' => $loose, 'groups' => []];
        }

        return $sections;
    }

    /**
     * Читает CSS-переменные заданного вида из первого блока :root файла
     *
     * @return array<string, string>
     */
    protected static function variables(string $file, string $kind): array
    {
        $source = preg_replace('~/\*.*?\*/~s', '', static::read($file)) ?? '';
        // только режим по умолчанию: первый блок со стилями :root
        if (preg_match('/:root[^{]*\{(.*?)\n\}/s', $source, $block)) {
            $source = $block[1];
        }
        preg_match_all('/(--' . $kind . '-[\w-]+):\s*([^;]+);/', $source, $matches, PREG_SET_ORDER);
        $variables = [];
        foreach ($matches as $match) {
            $variables[$match[1]] = trim($match[2]);
        }

        return $variables;
    }

    protected static function read(string $file): string
    {
        $path = __DIR__ . '/assetsGlobal/styles/' . $file;

        return is_file($path) ? (string)file_get_contents($path) : '';
    }
}

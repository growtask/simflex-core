<?php

namespace Simflex\Core\Layout\Components\UI\Switch\SwitchTree;

use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;
use Simflex\Core\Layout\LayoutBase;

/**
 * Дерево с чекбоксами (Figma Switches/tree и Switches/tree-item): вложенные категории, каждая с чекбоксом,
 * счётчиком и стрелкой раскрытия. Выбор узла отмечает всех потомков, а у родителя, где выбрана часть детей,
 * чекбокс в состоянии partial (indeterminate); состояние родителя всегда выводится из детей. Скрипт раскрывает ветки
 * и пересчитывает состояния, а на изменение шлёт sf-tree-change (detail.values — выбранные узлы без детей)
 */
class Layout extends LayoutBase
{
    /**
     * @param list<array<string,mixed>> $items Узлы: label — подпись, value — значение чекбокса, count — счётчик справа,
     *        checked, disabled, expanded (ветка раскрыта), children — вложенные узлы (до трёх уровней)
     * @param string $name Имя чекбоксов в форме (name[]); пусто — чекбоксы без имени
     * @param string $label Доступное имя дерева
     */
    public static function drawSwitchTree(
        array     $items,
        SwitchTreeSize  $size = SwitchTreeSize::Small,
        SwitchTreeTheme $theme = SwitchTreeTheme::Light,
        string    $name = '',
        string    $label = '',
        string    $className = '',
    ): string {
        $items = static::normalize($items);

        return static::draw(compact('items', 'name', 'label', 'className') + [
            'size' => $size->value,
            'theme' => $theme->value,
        ]);
    }

    /**
     * Строка узла: подпись и чекбокс (partial у родителя с частью выбранных детей)
     * @param array<string,mixed> $node Узел после normalize()
     */
    public static function drawSwitchTreeControl(array $node, string $name, SwitchTreeSize $size, SwitchTreeTheme $theme): string
    {
        $attributes = ['value' => (string)$node['value']];
        if ($name !== '') {
            $attributes['name'] = $name . '[]';
        }
        if ($node['state'] === 'on') {
            $attributes['checked'] = 'checked';
        } elseif ($node['state'] === 'partial') {
            $attributes['data-indeterminate'] = '1';
        }
        if (!empty($node['disabled'])) {
            $attributes['disabled'] = 'disabled';
        }

        return Checkbox::drawSwitchCheckbox(
            text: htmlspecialchars((string)$node['label']),
            size: $size === SwitchTreeSize::Small ? SwitchCheckboxSize::Small : SwitchCheckboxSize::Medium,
            theme: SwitchCheckboxTheme::from($theme->value),
            attributes: $attributes,
        );
    }

    /**
     * Приводит узлы к единому виду и выводит состояние родителей из детей
     * @param list<array<string,mixed>> $items
     * @return list<array<string,mixed>>
     */
    private static function normalize(array $items, int $level = 0): array
    {
        $result = [];
        foreach ($items as $item) {
            $node = [
                'label' => (string)($item['label'] ?? ''),
                'value' => (string)($item['value'] ?? ($item['label'] ?? '')),
                'count' => isset($item['count']) ? (string)$item['count'] : '',
                'disabled' => !empty($item['disabled']),
                'expanded' => !empty($item['expanded']),
                'level' => $level,
                'children' => [],
                'state' => !empty($item['checked']) ? 'on' : 'off',
            ];
            if (!empty($item['children']) && $level < 2) {
                $node['children'] = static::normalize($item['children'], $level + 1);
                $states = array_column($node['children'], 'state');
                $on = count(array_keys($states, 'on', true));
                $node['state'] = match (true) {
                    $on === count($states) => 'on',
                    $on > 0 || in_array('partial', $states, true) => 'partial',
                    default => 'off',
                };
            }
            $result[] = $node;
        }

        return $result;
    }
}

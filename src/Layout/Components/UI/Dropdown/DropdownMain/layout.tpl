<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$theme = $data['theme'];
$size = $data['size'];
$tabSize = TabMainSize::from($size);
$tabTheme = TabMainTheme::from($theme);
$classes = [
    'dropdown',
    "dropdown_view_{$data['view']}",
    "dropdown_size_$size",
    "dropdown-theme_$theme",
    ($data['scroll'] ?? true) ? '' : 'dropdown_scroll_off',
    $data['className'],
];
$class = htmlspecialchars(trim(implode(' ', array_filter($classes))));
$id = $data['id'];
?>
<?php if ($data['view'] === 'select'): ?>
    <?php
    $attributes = $data['attributes'];
    $isPlaceholder = $data['selectedLabel'] === null;
    ?>
    <div class="<?= $class ?>" data-sf-dropdown="select"<?php if ($data['searchUrl'] !== ''): ?>
         data-sf-dropdown-url="<?= htmlspecialchars($data['searchUrl']) ?>"<?php endif; ?>>
        <input type="hidden" name="<?= htmlspecialchars($data['name']) ?>"
               value="<?= htmlspecialchars((string)$data['value']) ?>"<?= $data['disabled'] ? ' disabled' : '' ?>
            <?= buildAttrs($data['inputAttributes']) ?>>
        <button type="button" class="dropdown__field" id="<?= $id ?>" aria-haspopup="listbox" aria-expanded="false"
                aria-controls="<?= $id ?>-panel" data-sf-dropdown-trigger<?= $data['disabled'] ? ' disabled' : '' ?>
                <?= buildAttrs($attributes) ?>>
            <span class="dropdown__value<?= $isPlaceholder ? ' dropdown__value_placeholder' : '' ?>"
                  data-placeholder="<?= htmlspecialchars($data['placeholder']) ?>"><?=
                htmlspecialchars($isPlaceholder ? $data['placeholder'] : $data['selectedLabel'])
            ?></span>
            <?= renderIcon('chevron-m-down', 'dropdown__chevron') ?>
        </button>
        <div class="dropdown__panel dropdown__panel_position_bottom" id="<?= $id ?>-panel" hidden>
            <?php if ($data['search']): ?>
                <?= TextInput::drawInputMain(
                    className: 'dropdown__search',
                    id: $id . '-search',
                    placeholder: 'Поиск',
                    size: InputMainSize::Small,
                    theme: InputMainTheme::from($theme),
                    icon: 'search',
                    attributes: ['data-sf-dropdown-search' => '', 'autocomplete' => 'off'],
                ) ?>
            <?php endif; ?>
            <div class="dropdown__list" role="listbox" aria-labelledby="<?= $id ?>">
                <?php foreach ($data['options'] as $optionValue => $optionLabel): ?>
                    <?php $isSelected = (string)$optionValue === $data['value']; ?>
                    <?= Tab::drawTabMain(
                        className: 'dropdown__option',
                        text: htmlspecialchars($optionLabel),
                        iconRight: 'check',
                        style: TabMainStyle::Soft,
                        size: $tabSize,
                        theme: $tabTheme,
                        attributes: [
                            'role' => 'option',
                            'aria-selected' => $isSelected ? 'true' : 'false',
                            'tabindex' => '-1',
                            'data-value' => (string)$optionValue,
                        ],
                        active: $isSelected,
                    ) ?>
                <?php endforeach; ?>
            </div>
            <div class="dropdown__empty" hidden>Ничего не найдено</div>
            <?php if ($data['searchUrl'] !== ''): ?>
                <template data-sf-dropdown-option><?= Tab::drawTabMain(
                    className: 'dropdown__option',
                    iconRight: 'check',
                    style: TabMainStyle::Soft,
                    size: $tabSize,
                    theme: $tabTheme,
                    attributes: ['role' => 'option', 'aria-selected' => 'false', 'tabindex' => '-1', 'data-value' => ''],
                ) ?></template>
            <?php endif; ?>
        </div>
    </div>
<?php else: ?>
    <div class="<?= $class ?>" data-sf-dropdown="menu">
        <?= $data['trigger'] ?>
        <div class="dropdown__panel dropdown__panel_position_<?= $data['position'] ?> dropdown__panel_side_<?= htmlspecialchars($data['side']) ?> dropdown__panel_align_<?= $data['align'] ?>"
             id="<?= $id ?>-panel" role="menu" aria-label="<?= htmlspecialchars($data['label']) ?>" hidden>
            <?php foreach ($data['items'] as $item): ?>
                <?= Tab::drawTabMain(
                    className: 'dropdown__option',
                    text: htmlspecialchars($item['text']),
                    link: $item['link'] ?? '',
                    iconLeft: $item['icon'] ?? '',
                    style: TabMainStyle::Soft,
                    size: $tabSize,
                    theme: $tabTheme,
                    attributes: ['role' => 'menuitem', 'tabindex' => '-1']
                        + (!empty($item['active']) ? ['aria-current' => 'true'] : [])
                        + ($item['attributes'] ?? []),
                    active: $item['active'] ?? false,
                    disabled: $item['disabled'] ?? false,
                ) ?>
            <?php endforeach; ?>
        </div>
    </div>
<?php endif; ?>

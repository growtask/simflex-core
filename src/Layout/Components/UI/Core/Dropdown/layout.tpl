<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$theme = $data['theme'];
$size = $data['size'];
$tabSize = TabSize::from($size);
$tabTheme = TabTheme::from($theme);
$classes = [
    'dropdown',
    "dropdown_view_{$data['view']}",
    "dropdown_size_$size",
    "dropdown-theme_$theme",
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
                <?= TextInput::drawInput(
                    className: 'dropdown__search',
                    placeholder: 'Поиск',
                    size: TextInputSize::Small,
                    theme: TextInputTheme::from($theme),
                    icon: 'search',
                    attributes: ['data-sf-dropdown-search' => '', 'autocomplete' => 'off'],
                ) ?>
            <?php endif; ?>
            <div class="dropdown__list" role="listbox" aria-labelledby="<?= $id ?>">
                <?php foreach ($data['options'] as $optionValue => $optionLabel): ?>
                    <?php $isSelected = (string)$optionValue === $data['value']; ?>
                    <?= Tab::drawTab(
                        className: 'dropdown__option',
                        text: htmlspecialchars($optionLabel),
                        iconRight: 'check',
                        style: TabStyle::Soft,
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
                <template data-sf-dropdown-option><?= Tab::drawTab(
                    className: 'dropdown__option',
                    iconRight: 'check',
                    style: TabStyle::Soft,
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
                <?= Tab::drawTab(
                    className: 'dropdown__option',
                    text: htmlspecialchars($item['text']),
                    link: $item['link'] ?? '',
                    iconLeft: $item['icon'] ?? '',
                    style: TabStyle::Soft,
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

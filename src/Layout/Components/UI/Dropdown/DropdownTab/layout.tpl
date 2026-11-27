<?php
/** @var array $data */

use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;

$dropdownTabClasses = [
    'dropdown-tab',
    "dropdown-tab-{$data['style']}",
    "dropdown-tab-size_{$data['size']}",
    "dropdown-tab-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$menuTheme = $data['menuTheme'] === 'light' ? '' : 'dropdown-tab__menu_dark';
$menuTabTheme = $data['menuTheme'] === 'light' ? TabMainTheme::Light : TabMainTheme::Dark;

$isLink = (bool)$data['link'];
// триггер — Tabs/main: оформление и состояния из стилей таба (Figma Dropdown/tab)
$triggerClasses = implode(' ', array_filter([
    'dropdown-tab__trigger',
    'tab',
    "tab-{$data['style']}",
    "tab-size_{$data['size']}",
    "tab-theme_{$data['theme']}",
    $data['active'] ? 'active' : '',
]));
$triggerAttrs = ['aria-expanded' => 'false', 'aria-controls' => $data['id'] . '-menu'];
if ($data['active'] && $isLink) {
    $triggerAttrs['aria-current'] = 'page';
}
if ($data['disabled']) {
    $triggerAttrs['aria-disabled'] = 'true';
    if ($isLink) {
        $triggerAttrs['tabindex'] = '-1';
    }
}
$tag = $isLink ? 'a' : 'button';
?>

<div class="<?= implode(' ', array_filter($dropdownTabClasses)) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <<?= $tag ?> class="<?= $triggerClasses ?>"
        <?php if ($isLink): ?>
            <?php if (!$data['disabled']): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
        <?php else: ?>
            type="button"<?= $data['disabled'] ? ' disabled' : '' ?>
        <?php endif; ?>
        <?= buildAttrs($triggerAttrs) ?>>
        <?php if ($data['icon']): ?>
            <?= renderIcon($data['icon'], 'tab__icon-left dropdown-tab__icon') ?>
        <?php endif; ?>

        <span class="tab__text dropdown-tab__text"><?= $data['text'] ?></span>

        <?php if ($data['badge']): ?>
            <span class="tab__badge"><?= $data['badge'] ?></span>
        <?php endif; ?>

        <?= renderIcon('chevron-s-down', 'tab__icon-right dropdown-tab__chevron') ?>
    </<?= $tag ?>>

    <ul class="<?= trim('dropdown-tab__menu ' . $menuTheme) ?>" id="<?= htmlspecialchars($data['id'], ENT_QUOTES, 'UTF-8') ?>-menu" data-pointer="center">
        <?php foreach ($data['options'] as $option): ?>
            <?php if (!empty($option['line'])): ?>
                <li class="dropdown-tab__line" role="separator"></li>
                <?php continue; ?>
            <?php endif; ?>
            <li class="dropdown-tab__option" data-value="<?= htmlspecialchars((string)($option['value'] ?? ''), ENT_QUOTES, 'UTF-8') ?>">
                <?= Tab::drawTabMain(
                    className: 'dropdown-tab__link',
                    text: $option['text'],
                    link: $option['link'] ?? '',
                    iconLeft: $option['icon'] ?? (!empty($option['active']) ? 'check' : ''),
                    badge: $option['badge'] ?? '',
                    style: TabMainStyle::Soft,
                    size: TabMainSize::Small,
                    theme: $menuTabTheme,
                    active: !empty($option['active']),
                ) ?>
            </li>
        <?php endforeach; ?>
    </ul>
</div>

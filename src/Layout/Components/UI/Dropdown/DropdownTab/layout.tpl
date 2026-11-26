<?php
/** @var array $data */

$dropdownTabClasses = [
    'dropdown-tab',
    "dropdown-tab-{$data['style']}",
    "dropdown-tab-size_{$data['size']}",
    "dropdown-tab-theme_{$data['theme']}",
    $data['className'] ?? ''
];

$menuTheme = $data['menuTheme'] === 'light' ? '' : 'dropdown-tab__menu_dark';
$menuTabTheme = $data['menuTheme'] === 'light' ? Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme::Light : Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme::Dark;

$isLink = (bool)$data['link'];
$triggerClasses = trim('dropdown-tab__trigger' . ($data['active'] ? ' active' : ''));
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

<div class="<?= implode(' ', $dropdownTabClasses) ?>" <?= buildAttrs($data['attributes'] ?? []) ?>>
    <<?= $tag ?> class="<?= $triggerClasses ?>"
        <?php if ($isLink): ?>
            <?php if (!$data['disabled']): ?>href="<?= htmlspecialchars($data['link'], ENT_QUOTES, 'UTF-8') ?>"<?php endif; ?>
        <?php else: ?>
            type="button"<?= $data['disabled'] ? ' disabled' : '' ?>
        <?php endif; ?>
        <?= buildAttrs($triggerAttrs) ?>>
        <?php if ($data['icon']): ?>
            <?= renderIcon($data['icon'], 'dropdown-tab__icon') ?>
        <?php endif; ?>

        <span class="dropdown-tab__text"><?= $data['text'] ?></span>

        <?php if ($data['badge']): ?>
            <span class="tab__badge"><?= $data['badge'] ?></span>
        <?php endif; ?>

        <?= renderIcon('chevron-down-sm', 'dropdown-tab__chevron') ?>
    </<?= $tag ?>>

    <ul class="dropdown-tab__menu <?= $menuTheme ?>" id="<?= htmlspecialchars($data['id'], ENT_QUOTES, 'UTF-8') ?>-menu" data-pointer="center">
        <?php foreach ($data['options'] as $option): ?>
            <li class="dropdown-tab__option" data-value="<?= htmlspecialchars((string)($option['value'] ?? ''), ENT_QUOTES, 'UTF-8') ?>">
                <?= Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout::drawTab(
                    className: 'dropdown-tab__link',
                    text: $option['text'],
                    link: $option['link'] ?? '',
                    iconLeft: $option['icon'] ?? '',
                    badge: $option['badge'] ?? '',
                    style: \Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle::Secondary,
                    size: \Simflex\Core\Layout\Components\UI\Tab\TabMain\TabSize::Small,
                    theme: $menuTabTheme,
                    active: !empty($option['active']),
                ) ?>
            </li>
        <?php endforeach; ?>
    </ul>
</div>

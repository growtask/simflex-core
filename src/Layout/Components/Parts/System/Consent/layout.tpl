<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;

$link = Link::drawLink(
    className: 'consent__link',
    text: htmlspecialchars($data['linkText']),
    href: $data['policyUrl'],
    size: LinkSize::Medium,
    theme: LinkTheme::from($data['theme']),
);
?>
<?= Checkbox::drawCheckbox(
    className: trim("consent consent-theme_{$data['theme']} {$data['className']}"),
    text: htmlspecialchars($data['text']) . ' ' . $link,
    style: CheckboxStyle::Solid,
    size: CheckboxSize::Small,
    theme: CheckboxTheme::from($data['theme']),
    attributes: $data['attributes'],
    error: $data['error'],
) ?>

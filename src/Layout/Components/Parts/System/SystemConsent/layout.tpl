<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxSize;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;

$link = Link::drawLinkMain(
    className: 'consent__link',
    text: htmlspecialchars($data['linkText']),
    href: $data['policyUrl'],
    size: LinkMainSize::Medium,
    theme: LinkMainTheme::from($data['theme']),
);
?>
<?= Checkbox::drawSwitchCheckbox(
    className: trim("consent consent-theme_{$data['theme']} {$data['className']}"),
    text: htmlspecialchars($data['text']) . ' ' . $link,
    style: SwitchCheckboxStyle::Solid,
    size: SwitchCheckboxSize::Small,
    theme: SwitchCheckboxTheme::from($data['theme']),
    attributes: $data['attributes'],
    error: $data['error'],
) ?>

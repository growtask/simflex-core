<?php

/**
 * Демо ButtonFeedback: стиль × тип × активность (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonFeedback\ButtonFeedbackStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonFeedback\ButtonFeedbackTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonFeedback\ButtonFeedbackType;
use Simflex\Core\Layout\Components\UI\Button\ButtonFeedback\Layout as ButtonFeedback;

$feedbackTheme = ButtonFeedbackTheme::from($theme);

?>
<?php foreach (ButtonFeedbackStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (ButtonFeedbackType::cases() as $type): ?>
            <?= ButtonFeedback::drawButtonFeedback($type, 0, style: $style, theme: $feedbackTheme) ?>
            <?= ButtonFeedback::drawButtonFeedback($type, 1, active: true, style: $style, theme: $feedbackTheme) ?>
        <?php endforeach; ?>
        <?= ButtonFeedback::drawButtonFeedback(style: $style, theme: $feedbackTheme) ?>
    </div>
<?php endforeach; ?>

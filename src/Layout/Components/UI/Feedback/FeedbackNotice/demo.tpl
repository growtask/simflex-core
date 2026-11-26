<?php

/**
 * Демо Notice: все стили; с иконкой и без, с закрытием, с кнопкой, только заголовок (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\FeedbackNoticeStyle;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\FeedbackNoticeTheme;

$noticeTheme = FeedbackNoticeTheme::from($theme);
$text = 'Строка под заголовком: что случилось и что делать';
$action = Button::drawButtonMain(
    text: 'Действие',
    style: ButtonMainStyle::Monochrome,
    size: ButtonMainSize::Small,
    theme: ButtonMainTheme::from($theme),
);

?>
<?php foreach (FeedbackNoticeStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__grid">
        <?= Notice::drawFeedbackNotice(
            title: 'С иконкой, закрытием и кнопкой',
            text: $text,
            style: $style,
            theme: $noticeTheme,
            close: true,
            buttons: $action,
        ) ?>
        <?= Notice::drawFeedbackNotice(title: 'С иконкой', text: $text, style: $style, theme: $noticeTheme) ?>
        <?= Notice::drawFeedbackNotice(title: 'Без иконки', text: $text, style: $style, theme: $noticeTheme, icon: false) ?>
        <?= Notice::drawFeedbackNotice(title: 'Только заголовок', style: $style, theme: $noticeTheme) ?>
        <?= Notice::drawFeedbackNotice(
            title: 'Без иконки, с закрытием',
            text: $text,
            style: $style,
            theme: $noticeTheme,
            icon: false,
            close: true,
        ) ?>
    </div>
<?php endforeach; ?>

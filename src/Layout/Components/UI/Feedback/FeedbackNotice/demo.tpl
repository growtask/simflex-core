<?php

/**
 * Демо Notice: все стили; с иконкой и без, с закрытием, с кнопкой, только заголовок (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\NoticeStyle;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\NoticeTheme;

$noticeTheme = NoticeTheme::from($theme);
$text = 'Строка под заголовком: что случилось и что делать';
$action = Button::drawButton(
    text: 'Действие',
    style: ButtonStyle::Monochrome,
    size: ButtonSize::Small,
    theme: ButtonTheme::from($theme),
);

?>
<?php foreach (NoticeStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?></h3>
    <div class="ui-showcase__grid">
        <?= Notice::drawNotice(
            title: 'С иконкой, закрытием и кнопкой',
            text: $text,
            style: $style,
            theme: $noticeTheme,
            close: true,
            buttons: $action,
        ) ?>
        <?= Notice::drawNotice(title: 'С иконкой', text: $text, style: $style, theme: $noticeTheme) ?>
        <?= Notice::drawNotice(title: 'Без иконки', text: $text, style: $style, theme: $noticeTheme, icon: false) ?>
        <?= Notice::drawNotice(title: 'Только заголовок', style: $style, theme: $noticeTheme) ?>
        <?= Notice::drawNotice(
            title: 'Без иконки, с закрытием',
            text: $text,
            style: $style,
            theme: $noticeTheme,
            icon: false,
            close: true,
        ) ?>
    </div>
<?php endforeach; ?>

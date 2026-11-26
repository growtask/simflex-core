<?php

/**
 * Демо Toast: стили × ширина, с иконкой, действием и таймером, вызов sfToast (витрина Layout\LayoutShowcase).
 * Тосты не зависят от темы, поэтому выводятся один раз, в светлой теме
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\Layout as Toast;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\FeedbackToastStyle;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\FeedbackToastWidth;

if ($theme !== 'light') {
    return;
}

?>
<?php foreach (FeedbackToastWidth::cases() as $width): ?>
    <h3 class="ui-showcase__subtitle ui-m">Ширина: <?= $width->name ?></h3>
    <div class="ui-showcase__row">
        <?php foreach (FeedbackToastStyle::cases() as $style): ?>
            <?= Toast::drawFeedbackToast('Только текст', $style, $width) ?>
            <?= Toast::drawFeedbackToast('С иконкой', $style, $width, icon: true) ?>
            <?= Toast::drawFeedbackToast(
                'Изменения сохранены',
                $style,
                $width,
                icon: true,
                actionText: 'Отменить',
                timer: true,
                timeout: 600000,
            ) ?>
        <?php endforeach; ?>
    </div>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Вызов sfToast</h3>
<div class="ui-showcase__row">
    <?php foreach (FeedbackToastStyle::cases() as $style): ?>
        <?= Button::drawButtonMain(
            text: 'sfToast ' . $style->value,
            style: ButtonMainStyle::Secondary,
            size: ButtonMainSize::Small,
            attributes: ['data-ui-toast' => $style->value],
        ) ?>
    <?php endforeach; ?>
</div>
<?= Toast::drawFeedbackToastStack() ?>
<script>
    document.querySelectorAll('[data-ui-toast]').forEach((button) => {
        button.addEventListener('click', () => window.sfToast('Тост ' + button.dataset.uiToast, {
            type: button.dataset.uiToast,
            action: {text: 'Повторить', onClick: () => {}},
        }));
    });
</script>

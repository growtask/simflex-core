<?php

/**
 * Демо StepMain: шесть шагов, с прогрессом и без, вид планшета и телефона, Scroll (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Services\Step\StepMain\Layout as Steps;
use Simflex\Core\Layout\Components\Services\Step\StepMain\StepMainStyle;
use Simflex\Core\Layout\Components\Services\Step\StepMain\StepMainTheme;

$steps = [
    ['title' => 'Заявка', 'text' => 'Опишите задачу: звонок или форма', 'badge' => '1 день', 'done' => true],
    ['title' => 'Оценка', 'text' => 'Согласуем объём, цену и сроки', 'badge' => '2 дня'],
    ['title' => 'Работа', 'text' => 'Вы видите прогресс на каждом этапе', 'badge' => '2 недели'],
    ['title' => 'Сдача', 'text' => 'Передаём результат и документы', 'badge' => '1 день'],
    ['title' => 'Запуск', 'text' => 'Запускаем результат и всё проверяем', 'badge' => '1 день'],
    ['title' => 'Поддержка', 'text' => 'На связи и помогаем после запуска', 'badge' => 'постоянно'],
];
$stepsTheme = StepMainTheme::from($theme);

?>
<?php foreach (StepMainStyle::cases() as $style): ?>
    <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>, прогресс: первый шаг пройден</h3>
    <div style="max-width:<?= $style === StepMainStyle::Scroll ? 414 : 1264 ?>px">
        <?= Steps::drawStepMain($steps, style: $style, theme: $stepsTheme, progress: true, actionText: 'Заказать') ?>
    </div>
<?php endforeach; ?>
<h3 class="ui-showcase__subtitle ui-m">Без прогресса, четыре шага, без кнопки</h3>
<?= Steps::drawStepMain(array_slice($steps, 0, 4), theme: $stepsTheme) ?>
<h3 class="ui-showcase__subtitle ui-m">Вид планшета и телефона</h3>
<div class="ui-showcase__row" style="align-items:flex-start">
    <div style="width:736px"><?= Steps::drawStepMain($steps, theme: $stepsTheme, progress: true, actionText: 'Заказать', className: 'steps_view_tablet') ?></div>
    <div style="width:382px"><?= Steps::drawStepMain($steps, theme: $stepsTheme, progress: true, actionText: 'Заказать', className: 'steps_view_mobile') ?></div>
</div>

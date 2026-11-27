<?php

/**
 * Демо FormMailing: подписка на рассылку с согласием и без, состояние отправки (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Form\FormCallback\FormCallbackState;
use Simflex\Core\Layout\Components\Base\Form\FormMailing\FormMailingTheme;
use Simflex\Core\Layout\Components\Base\Form\FormMailing\Layout as FormMailing;

$theme = FormMailingTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">С согласием</h3>
<div class="ui-showcase__row" style="display: block; max-width: 760px;">
    <?= FormMailing::drawFormMailing(theme: $theme, guard: false) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Без согласия</h3>
<div class="ui-showcase__row" style="display: block; max-width: 760px;">
    <?= FormMailing::drawFormMailing(consent: false, theme: $theme, guard: false) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Отправка</h3>
<div class="ui-showcase__row" style="display: block; max-width: 760px;">
    <?= FormMailing::drawFormMailing(
        consent: false,
        values: ['email' => 'ivan@example.com'],
        state: FormCallbackState::Sending,
        theme: $theme,
        guard: false,
    ) ?>
</div>

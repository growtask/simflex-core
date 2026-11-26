<?php

/**
 * Демо Consent: обычное состояние, с ошибкой и поставленным согласием (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Parts\System\SystemConsent\SystemConsentTheme;
use Simflex\Core\Layout\Components\Parts\System\SystemConsent\Layout as Consent;

$consentTheme = SystemConsentTheme::from($theme);

?>
<h3 class="ui-showcase__subtitle ui-m">Default</h3>
<div class="ui-showcase__row">
    <?= Consent::drawSystemConsent(theme: $consentTheme, attributes: ['name' => 'consent-default']) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Checked</h3>
<div class="ui-showcase__row">
    <?= Consent::drawSystemConsent(theme: $consentTheme, attributes: ['name' => 'consent-checked', 'checked' => 'checked']) ?>
</div>

<h3 class="ui-showcase__subtitle ui-m">Error</h3>
<div class="ui-showcase__row">
    <?= Consent::drawSystemConsent(theme: $consentTheme, error: true, attributes: ['name' => 'consent-error']) ?>
</div>

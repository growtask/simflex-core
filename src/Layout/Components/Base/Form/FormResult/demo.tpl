<?php

/**
 * Демо FormResult: успех и ошибка в двух раскладках, без маркера и кнопки (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultStyle;
use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultTheme;
use Simflex\Core\Layout\Components\Base\Form\FormResult\FormResultType;
use Simflex\Core\Layout\Components\Base\Form\FormResult\Layout as FormResult;

$theme = FormResultTheme::from($theme);

?>
<?php foreach (FormResultStyle::cases() as $style): ?>
    <?php foreach (FormResultType::cases() as $type): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?> · <?= $type->name ?></h3>
        <div class="ui-showcase__row" style="display: block; max-width: 760px;">
            <?= FormResult::drawFormResult(
                title: $style === FormResultStyle::Success ? 'Заявка отправлена' : 'Не удалось отправить',
                text: $style === FormResultStyle::Success
                    ? 'Мы свяжемся с вами в ближайшее время'
                    : 'Попробуйте ещё раз немного позже',
                buttonText: $style === FormResultStyle::Success ? 'OK' : 'Повторить',
                style: $style,
                type: $type,
                theme: $theme,
            ) ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

<h3 class="ui-showcase__subtitle ui-m">Без маркера и кнопки</h3>
<div class="ui-showcase__row" style="display: block; max-width: 760px;">
    <?= FormResult::drawFormResult(title: 'Готово', text: 'Данные сохранены', buttonText: '', marker: false, theme: $theme) ?>
</div>

<?php

/**
 * Порядок записи в ячейке списка: степпер, изменение сохраняется сразу (action=change_npp, theme/js/list.js)
 * @var string $name
 * @var string $tablePk
 * @var mixed $value
 * @var mixed $pkValue
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\Stepper\Layout as Stepper;
use Simflex\Core\Layout\Components\UI\Core\Stepper\StepperSize;
use Simflex\Core\Layout\Components\UI\Core\Stepper\StepperTheme;

?>
<?= Stepper::drawStepper(
    'npp_' . $pkValue,
    (int)$value,
    label: strip_tags($this->label),
    size: StepperSize::ExtraSmall,
    theme: StepperTheme::from(Page::get()->getTheme()),
    id: 'npp-' . $name . '-' . $pkValue,
    className: 'td-npp',
    attributes: [
        'data-sf-npp' => '?' . http_build_query(['action' => 'change_npp', 'field' => $name, $tablePk => $pkValue]),
    ],
) ?>

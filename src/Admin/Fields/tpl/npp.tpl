<?php

/**
 * Порядок записи в ячейке списка: степпер, изменение сохраняется сразу (action=change_npp, theme/js/list.js)
 * @var string $name
 * @var string $tablePk
 * @var mixed $value
 * @var mixed $pkValue
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as Stepper;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainTheme;

?>
<?= Stepper::drawStepperMain(
    'npp_' . $pkValue,
    (int)$value,
    label: strip_tags($this->label),
    size: StepperMainSize::ExtraSmall,
    theme: StepperMainTheme::from(Page::get()->getTheme()),
    id: 'npp-' . $name . '-' . $pkValue,
    className: 'td-npp',
    attributes: [
        'data-sf-npp' => '?' . http_build_query(['action' => 'change_npp', 'field' => $name, $tablePk => $pkValue]),
    ],
) ?>

<?php

namespace Simflex\Core\Admin\Fields;

use Simflex\Core\DB\AQ;
use Simflex\Core\System\Session;
use Simflex\Core\DB\DB;

class FieldNPP extends Field
{
    public function show($row): string
    {
        return $this->render('npp', [
            'name' => $this->name,
            'tablePk' => $this->tablePk,
            'value' => $row[$this->name],
            'pkValue' => $row[$this->tablePk],
        ]);
    }

    public function input($value): string
    {
        if ($this->getRequest()->request($this->tablePk) === null) {
            // TODO: сделать по-нормальному
            if ($this->table === 'catalog_product') {
                $value = 1;
            } else {
                // новая запись - в конец списка с выбранными фильтрами раздела
                $query = new AQ()->select('MAX(' . DB::wrapName($this->name) . ')')->from($this->table);
                foreach ((array)(Session::get($this->table)['filter'] ?? []) as $name => $filterValue) {
                    if ($filterValue) {
                        $query->andWhere([$name => $filterValue]);
                    }
                }
                $value = (int)$query->fetchScalar() + 1;
            }
        }

        // порядок в форме — степпер (Stepper/main, поле input)
        return \Simflex\Core\Layout\Components\UI\Core\Stepper\Layout::drawStepper(
            $this->inputName(),
            (int)$value,
            label: strip_tags((string)$this->label),
            size: \Simflex\Core\Layout\Components\UI\Core\Stepper\StepperSize::Small,
            style: \Simflex\Core\Layout\Components\UI\Core\Stepper\StepperStyle::Input,
            theme: \Simflex\Core\Layout\Components\UI\Core\Stepper\StepperTheme::from(
                \Simflex\Core\Admin\Page::get()->getTheme()
            ),
            disabled: $this->readonly,
            id: 'field-' . $this->name,
        );
    }

    public function getPOST(bool $simple = false, string|int|null $group = null): mixed
    {
        $value = $this->getPosted();
        return $this->e2n && $value === '' ? null : (int)$value;
    }
}

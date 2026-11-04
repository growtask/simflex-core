<?php

/**
 * Привилегии из кода (Handlers\Privilege): переключатель активности сохраняется сразу (?action=switch)
 * @var array<array{name: string, title: string, active: bool, switchable: bool}> $rows
 */

use Simflex\Core\Admin\Page;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\ToggleSize;
use Simflex\Core\Layout\Components\UI\Core\ToggleSwitch\ToggleTheme;

$theme = Page::get()->getTheme();
?>
<section class="table-card table-card-theme_<?= $theme ?>" aria-label="<?= htmlspecialchars($this->title ?: 'Привилегии') ?>">
    <div class="table-card__scroll">
        <table class="table-list privilege-table">
            <thead>
            <tr class="thr">
                <th class="th th_toggle" scope="col">Активно</th>
                <th class="th" scope="col">Название</th>
                <th class="th th_main" scope="col">Описание</th>
            </tr>
            </thead>
            <tbody class="table__body">
            <?php foreach ($rows as $row): ?>
                <?php
                $attributes = ['aria-label' => 'Привилегия ' . $row['name'], 'data-sf-privilege-switch' => ''];
                if ($row['active']) {
                    $attributes['checked'] = 'checked';
                }
                if (!$row['switchable']) {
                    $attributes['disabled'] = 'disabled';
                    $attributes['title'] = 'Без неё никто не сможет включить остальные привилегии обратно';
                }
                ?>
                <tr class="tr privilege-table__row" data-privilege="<?= htmlspecialchars($row['name']) ?>">
                    <td class="td" data-label="Активно">
                        <?= Toggle::drawToggle(
                            className: 'privilege-table__switch',
                            icon: false,
                            size: ToggleSize::Small,
                            theme: ToggleTheme::from($theme),
                            attributes: $attributes,
                        ) ?>
                    </td>
                    <td class="td td_main" data-label="Название"><?= htmlspecialchars($row['name']) ?></td>
                    <td class="td" data-label="Описание"><?= htmlspecialchars($row['title']) ?></td>
                </tr>
            <?php endforeach ?>
            </tbody>
        </table>
    </div>
</section>
<script type="module">
    import {request, toast} from '<?= Page::webVendorPath() ?>/theme/js/admin.js';

    document.querySelectorAll('[data-sf-privilege-switch]').forEach((input) => {
        input.addEventListener('change', async () => {
            const name = input.closest('[data-privilege]').dataset.privilege;
            try {
                const data = await request('?action=switch', {method: 'POST', data: {name, active: input.checked ? '1' : '0'}});
                input.checked = Boolean(data.active);
            } catch {
                input.checked = !input.checked;
                toast('Не удалось изменить привилегию', {type: 'error'});
            }
        });
    });
</script>

<?php

/**
 * Витрина компонентов (Handlers\Ui)
 * @var \Simflex\Core\Admin\Handlers\Ui $this
 * @var list<string> $iconIds
 */

use Simflex\Core\Admin\Handlers\Ui;
use Simflex\Core\Layout\Components\Common\Breadcrumbs\BreadcrumbsTheme;
use Simflex\Core\Layout\Components\Common\Breadcrumbs\Layout as Breadcrumbs;
use Simflex\Core\Layout\Components\Common\Pagination\Layout as Pagination;
use Simflex\Core\Layout\Components\Common\Pagination\PaginationTheme;
use Simflex\Core\Layout\Components\Common\Pagination\PaginationType;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\Layout as LoaderIcon;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderTheme;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\AvatarSize;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\AvatarStyle;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\Layout as Placeholder;
use Simflex\Core\Layout\Components\UI\Other\Placeholder\PlaceholderTheme;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonStates\ButtonStatesState;
use Simflex\Core\Layout\Components\UI\Button\ButtonStates\Layout as ButtonStates;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as Dropdown;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SortButtonTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\SortDirection;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as Stepper;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperStyle;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperTheme;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\NoticeStyle;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\NoticeTheme;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\Layout as Toast;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\ToastStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\CheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\RadioTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabTheme;
use Simflex\Core\Layout\Components\UI\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Tag\TagTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\TextInputTheme;
use Simflex\Core\Layout\Components\UI\Textarea\Layout as Textarea;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\ToggleTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo\Layout as TooltipInfo;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\Layout as Sort;

?>
<div class="ui-showcase">
    <div class="ui-showcase__widths" role="group" aria-label="Открыть витрину в окне ширины макета">
        <?php foreach (Ui::WIDTHS as $width): ?>
            <?= Button::drawButton(
                text: (string)$width,
                style: ButtonStyle::Secondary,
                size: ButtonSize::Small,
                attributes: ['data-ui-width' => (string)$width],
            ) ?>
        <?php endforeach; ?>
    </div>

    <?php foreach (Ui::THEMES as $theme => $themeName): ?>
        <section class="ui-showcase__theme ui-showcase__theme_<?= $theme ?>" aria-label="<?= $themeName ?> тема">
            <h2 class="ui-showcase__title heading-h4"><?= $themeName ?> тема</h2>

            <h3 class="ui-showcase__subtitle ui-m">Buttons/main</h3>
            <?php foreach (ButtonSize::cases() as $size): ?>
                <div class="ui-showcase__row">
                    <?php foreach (ButtonStyle::cases() as $style): ?>
                        <?= Button::drawButton(
                            text: $style->name,
                            icon: 'plus',
                            style: $style,
                            size: $size,
                            theme: ButtonTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                    <?= Button::drawButton(
                        text: 'disabled',
                        size: $size,
                        theme: ButtonTheme::from($theme),
                        disabled: true,
                    ) ?>
                </div>
            <?php endforeach; ?>

            <h3 class="ui-showcase__subtitle ui-m">Buttons/icon-small</h3>
            <div class="ui-showcase__row">
                <?php foreach (ButtonIconStyle::cases() as $style): ?>
                    <?php foreach (['close', 'copy', 'trash', 'pencil-line'] as $icon): ?>
                        <?= ButtonIcon::drawButtonIcon(
                            icon: $icon,
                            label: $icon,
                            style: $style,
                            theme: ButtonIconTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                    <?= ButtonIcon::drawButtonIcon(
                        icon: 'close',
                        label: 'disabled',
                        style: $style,
                        theme: ButtonIconTheme::from($theme),
                        disabled: true,
                    ) ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Tooltip/main, Tooltip/info</h3>
            <div class="ui-showcase__row ui-showcase__row_tooltips">
                <?php foreach (TooltipPosition::cases() as $position): ?>
                    <?= Tooltip::drawTooltip(
                        Button::drawButton(
                            text: $position->name,
                            style: ButtonStyle::Secondary,
                            size: ButtonSize::Small,
                            theme: ButtonTheme::from($theme),
                        ),
                        'Подсказка: тултип стоит с противоположной стороны от стрелки',
                        position: $position,
                        theme: TooltipTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <?= Tooltip::drawTooltip(
                    Button::drawButton(text: 'error', size: ButtonSize::Small, theme: ButtonTheme::from($theme)),
                    'Неверный email',
                    style: TooltipStyle::Error,
                    theme: TooltipTheme::from($theme),
                ) ?>
                <?= TooltipInfo::drawInfo('Короткое пояснение термина', TooltipTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Feedback/notice</h3>
            <div class="ui-showcase__grid">
                <?php foreach (NoticeStyle::cases() as $style): ?>
                    <?= Notice::drawNotice(
                        title: 'Заголовок ' . $style->value,
                        text: 'Строка под заголовком: что случилось и что делать',
                        style: $style,
                        theme: NoticeTheme::from($theme),
                        close: true,
                        buttons: Button::drawButton(
                            text: 'Действие',
                            style: ButtonStyle::Monochrome,
                            size: ButtonSize::Small,
                            theme: ButtonTheme::from($theme),
                        ),
                    ) ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">nav/breadcrumbs</h3>
            <?= Breadcrumbs::drawBreadcrumbs(
                [
                    ['name' => 'Каталог', 'link' => '#catalog'],
                    ['name' => 'Товары', 'link' => '#products'],
                    ['name' => 'Категория', 'link' => '#category'],
                    ['name' => 'Ноутбук Apple MacBook Air'],
                ],
                homeLink: '#home',
                theme: BreadcrumbsTheme::from($theme),
            ) ?>

            <h3 class="ui-showcase__subtitle ui-m">nav/pagination</h3>
            <?php foreach ([1, 10, 20] as $page): ?>
                <?= Pagination::drawPagination($page, 20, '#page-{page}', theme: PaginationTheme::from($theme)) ?>
            <?php endforeach; ?>
            <?= Pagination::drawPagination(
                10,
                20,
                '#page-{page}',
                type: PaginationType::Compact,
                theme: PaginationTheme::from($theme),
                search: false,
            ) ?>

            <h3 class="ui-showcase__subtitle ui-m">placeholders/avatar, no-image</h3>
            <div class="ui-showcase__row">
                <?php foreach (AvatarSize::cases() as $size): ?>
                    <?= Placeholder::drawAvatar('Иван Петров', size: $size, theme: PlaceholderTheme::from($theme)) ?>
                    <?= Placeholder::drawAvatar(
                        'Иван Петров',
                        size: $size,
                        style: AvatarStyle::Silhouette,
                        theme: PlaceholderTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <span class="ui-showcase__image"><?= Placeholder::drawNoImage(theme: PlaceholderTheme::from($theme)) ?></span>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Tabs/main</h3>
            <div class="ui-showcase__row">
                <?php foreach (TabStyle::cases() as $style): ?>
                    <?= Tab::drawTab(text: $style->name, style: $style, theme: TabTheme::from($theme)) ?>
                    <?= Tab::drawTab(text: 'active', style: $style, theme: TabTheme::from($theme), active: true) ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Inputs/main, textarea</h3>
            <div class="ui-showcase__row">
                <?= TextInput::drawInput(
                    placeholder: 'Название',
                    labelText: 'Название',
                    theme: TextInputTheme::from($theme),
                ) ?>
                <?= TextInput::drawInput(
                    placeholder: 'Email',
                    theme: TextInputTheme::from($theme),
                    value: 'admin@',
                    error: 'Неверный email',
                ) ?>
                <?= TextInput::drawInput(
                    placeholder: 'Пароль',
                    theme: TextInputTheme::from($theme),
                    id: 'ui-password-' . $theme,
                    kind: TextInputKind::Password,
                    value: 'secret',
                ) ?>
                <?= TextInput::drawInput(
                    placeholder: 'Логин',
                    theme: TextInputTheme::from($theme),
                    value: 'admin',
                    success: true,
                ) ?>
                <?= Textarea::drawTextarea(placeholder: 'Описание', theme: TextareaTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Dropdown/input, Dropdown/main</h3>
            <div class="ui-showcase__row ui-showcase__row_dropdowns">
                <span class="ui-showcase__field">
                    <?= Dropdown::drawSelect(
                        'ui_status_' . $theme,
                        ['new' => 'Новый', 'work' => 'В работе', 'done' => 'Выполнен', 'cancel' => 'Отменён'],
                        'work',
                        theme: DropdownTheme::from($theme),
                        attributes: ['aria-label' => 'Статус'],
                    ) ?>
                </span>
                <span class="ui-showcase__field">
                    <?= Dropdown::drawSelect(
                        'ui_city_' . $theme,
                        array_combine(
                            range(1, 12),
                            ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань', 'Нижний Новгород',
                                'Челябинск', 'Самара', 'Омск', 'Ростов-на-Дону', 'Уфа', 'Красноярск']
                        ),
                        placeholder: 'Город',
                        size: DropdownSize::Small,
                        theme: DropdownTheme::from($theme),
                        search: true,
                        attributes: ['aria-label' => 'Город'],
                    ) ?>
                </span>
                <?= Dropdown::drawMenu(
                    ButtonIcon::drawButtonIcon(
                        icon: 'dots-vertical',
                        label: 'Ещё',
                        style: ButtonIconStyle::Secondary,
                        theme: ButtonIconTheme::from($theme),
                    ),
                    [
                        ['text' => 'Редактировать', 'icon' => 'pencil-line', 'link' => '#edit'],
                        ['text' => 'Копировать', 'icon' => 'copy'],
                        ['text' => 'Удалить', 'icon' => 'trash'],
                    ],
                    theme: DropdownTheme::from($theme),
                    side: 'left',
                ) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Switches/sort, sort-button</h3>
            <div class="ui-showcase__row">
                <?php foreach (SortDirection::cases() as $direction): ?>
                    <?php foreach (SortButtonStyle::cases() as $style): ?>
                        <?= Sort::drawSort(
                            'Название',
                            '#asc',
                            '#desc',
                            $direction,
                            $style,
                            SortButtonTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Stepper/main</h3>
            <div class="ui-showcase__row">
                <?php foreach (StepperSize::cases() as $size): ?>
                    <?= Stepper::drawStepper(
                        'ui_npp_' . $theme,
                        1,
                        min: 1,
                        max: 5,
                        size: $size,
                        theme: StepperTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <?= Stepper::drawStepper(
                    'ui_npp2_' . $theme,
                    5,
                    max: 5,
                    style: StepperStyle::Input,
                    fill: StepperFill::Outline,
                    theme: StepperTheme::from($theme),
                    error: 'Осталось только 5',
                ) ?>
                <?= Stepper::drawStepper('ui_npp3_' . $theme, 3, theme: StepperTheme::from($theme), loading: true) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Switches</h3>
            <div class="ui-showcase__row">
                <?= Checkbox::drawCheckbox(text: 'Чекбокс', theme: CheckboxTheme::from($theme)) ?>
                <?= Radio::drawRadio(text: 'Радио', id: 'ui-radio-' . $theme, theme: RadioTheme::from($theme)) ?>
                <?= Toggle::drawToggle(text: 'Переключатель', theme: ToggleTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Badges, Tags</h3>
            <div class="ui-showcase__row">
                <?php foreach (BadgeStyle::cases() as $style): ?>
                    <?= Badge::drawBadge(text: $style->name, style: $style) ?>
                <?php endforeach; ?>
                <?= Tag::drawTag(text: 'Тег', theme: TagTheme::from($theme)) ?>
                <?= Tag::drawTag(text: 'Статус: новый', theme: TagTheme::from($theme), icon: 'filter', close: true) ?>
                <?= Toggle::drawToggle(
                    text: 'disabled',
                    theme: ToggleTheme::from($theme),
                    attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
                ) ?>
                <?= Radio::drawRadio(
                    text: 'disabled',
                    id: 'ui-radio-disabled-' . $theme,
                    theme: RadioTheme::from($theme),
                    attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
                ) ?>
                <?= ButtonStates::drawButtonStates(text: 'success', state: ButtonStatesState::Success, size: ButtonSize::Small) ?>
                <?= ButtonStates::drawButtonStates(text: 'error', state: ButtonStatesState::Error, size: ButtonSize::Small) ?>
                <?= LoaderIcon::drawLoader(theme: LoaderTheme::from($theme)) ?>
                <?= LoaderIcon::drawLoader(LoaderSize::Small, LoaderStyle::Monochrome, LoaderTheme::from($theme)) ?>
            </div>
        </section>
    <?php endforeach; ?>

    <section class="ui-showcase__theme" aria-label="Тосты">
        <h2 class="ui-showcase__title heading-h4">Feedback/toast</h2>
        <div class="ui-showcase__row">
            <?php foreach (ToastStyle::cases() as $style): ?>
                <?= Toast::drawToast(
                    'Изменения сохранены',
                    $style,
                    icon: true,
                    actionText: 'Отменить',
                    timer: true,
                    timeout: 600000,
                ) ?>
            <?php endforeach; ?>
        </div>
        <div class="ui-showcase__row">
            <?php foreach (ToastStyle::cases() as $style): ?>
                <?= Button::drawButton(
                    text: 'sfToast ' . $style->value,
                    style: ButtonStyle::Secondary,
                    size: ButtonSize::Small,
                    attributes: ['data-ui-toast' => $style->value],
                ) ?>
            <?php endforeach; ?>
        </div>
    </section>

    <section class="ui-showcase__theme" aria-label="Иконки">
        <h2 class="ui-showcase__title heading-h4">Иконки (<?= count($iconIds) ?>)</h2>
        <ul class="ui-showcase__icons">
            <?php foreach ($iconIds as $iconId): ?>
                <li class="ui-showcase__icon" title="<?= $iconId ?>">
                    <?= renderIcon($iconId, 'ui-showcase__icon-svg') ?>
                    <span class="text-t4"><?= $iconId ?></span>
                </li>
            <?php endforeach; ?>
        </ul>
    </section>
</div>
<?= Toast::drawStack() ?>
<script>
    document.querySelectorAll('[data-ui-toast]').forEach((button) => {
        button.addEventListener('click', () => window.sfToast('Тост ' + button.dataset.uiToast, {
            type: button.dataset.uiToast,
            action: {text: 'Повторить', onClick: () => {}},
        }));
    });

    // ширина макета: витрина открывается в окне этой ширины
    document.querySelectorAll('[data-ui-width]').forEach((button) => {
        button.addEventListener('click', () => {
            window.open(location.href, 'ui-' + button.dataset.uiWidth, 'width=' + button.dataset.uiWidth + ',height=900');
        });
    });
</script>

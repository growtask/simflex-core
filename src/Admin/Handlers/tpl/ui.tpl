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
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainSize;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainStyle;
use Simflex\Core\Layout\Components\UI\Loader\LoaderMain\LoaderMainTheme;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarSize;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarStyle;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\Layout as Placeholder;
use Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderAvatar\PlaceholderAvatarTheme;
use Simflex\Core\Layout\Components\UI\Badge\BadgeStyle;
use Simflex\Core\Layout\Components\UI\Badge\Layout as Badge;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainState;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\ButtonIconSmallTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonIconSmall\Layout as ButtonIcon;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainSize;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\DropdownMainTheme;
use Simflex\Core\Layout\Components\UI\Dropdown\DropdownMain\Layout as Dropdown;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\Layout as Notice;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\Layout as SortButton;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonStyle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSortButton\SwitchSortButtonTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\SwitchSortDirection;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\Layout as Stepper;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainFill;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainSize;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainStyle;
use Simflex\Core\Layout\Components\UI\Stepper\StepperMain\StepperMainTheme;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\FeedbackNoticeStyle;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackNotice\FeedbackNoticeTheme;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\Layout as Toast;
use Simflex\Core\Layout\Components\UI\Feedback\FeedbackToast\FeedbackToastStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\Layout as Tooltip;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainPosition;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainStyle;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipMain\TooltipMainTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\SwitchCheckboxTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchCheckbox\Layout as Checkbox;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\Layout as Radio;
use Simflex\Core\Layout\Components\UI\Switch\SwitchRadio\SwitchRadioTheme;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Tag\Layout as Tag;
use Simflex\Core\Layout\Components\UI\Tag\TagTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainKind;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;
use Simflex\Core\Layout\Components\UI\Textarea\Layout as Textarea;
use Simflex\Core\Layout\Components\UI\Textarea\TextareaTheme;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\Layout as Toggle;
use Simflex\Core\Layout\Components\UI\Switch\SwitchToggle\SwitchToggleTheme;
use Simflex\Core\Layout\Components\UI\Tooltip\TooltipInfo\Layout as TooltipInfo;
use Simflex\Core\Layout\Components\UI\Switch\SwitchSort\Layout as Sort;

?>
<div class="ui-showcase">
    <div class="ui-showcase__widths" role="group" aria-label="Открыть витрину в окне ширины макета">
        <?php foreach (Ui::WIDTHS as $width): ?>
            <?= Button::drawButtonMain(
                text: (string)$width,
                style: ButtonMainStyle::Secondary,
                size: ButtonMainSize::Small,
                attributes: ['data-ui-width' => (string)$width],
            ) ?>
        <?php endforeach; ?>
    </div>

    <?php foreach (Ui::THEMES as $theme => $themeName): ?>
        <section class="ui-showcase__theme ui-showcase__theme_<?= $theme ?>" aria-label="<?= $themeName ?> тема">
            <h2 class="ui-showcase__title heading-h4"><?= $themeName ?> тема</h2>

            <h3 class="ui-showcase__subtitle ui-m">Buttons/main</h3>
            <?php foreach (ButtonMainSize::cases() as $size): ?>
                <div class="ui-showcase__row">
                    <?php foreach (ButtonMainStyle::cases() as $style): ?>
                        <?= Button::drawButtonMain(
                            text: $style->name,
                            icon: 'plus',
                            style: $style,
                            size: $size,
                            theme: ButtonMainTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                    <?= Button::drawButtonMain(
                        text: 'disabled',
                        size: $size,
                        theme: ButtonMainTheme::from($theme),
                        disabled: true,
                    ) ?>
                </div>
            <?php endforeach; ?>

            <h3 class="ui-showcase__subtitle ui-m">Buttons/icon-small</h3>
            <div class="ui-showcase__row">
                <?php foreach (ButtonIconSmallStyle::cases() as $style): ?>
                    <?php foreach (['close', 'copy', 'trash', 'pencil-line'] as $icon): ?>
                        <?= ButtonIcon::drawButtonIconSmall(
                            icon: $icon,
                            label: $icon,
                            style: $style,
                            theme: ButtonIconSmallTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                    <?= ButtonIcon::drawButtonIconSmall(
                        icon: 'close',
                        label: 'disabled',
                        style: $style,
                        theme: ButtonIconSmallTheme::from($theme),
                        disabled: true,
                    ) ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Tooltip/main, Tooltip/info</h3>
            <div class="ui-showcase__row ui-showcase__row_tooltips">
                <?php foreach (TooltipMainPosition::cases() as $position): ?>
                    <?= Tooltip::drawTooltipMain(
                        Button::drawButtonMain(
                            text: $position->name,
                            style: ButtonMainStyle::Secondary,
                            size: ButtonMainSize::Small,
                            theme: ButtonMainTheme::from($theme),
                        ),
                        'Подсказка: тултип стоит с противоположной стороны от стрелки',
                        position: $position,
                        theme: TooltipMainTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <?= Tooltip::drawTooltipMain(
                    Button::drawButtonMain(text: 'error', size: ButtonMainSize::Small, theme: ButtonMainTheme::from($theme)),
                    'Неверный email',
                    style: TooltipMainStyle::Error,
                    theme: TooltipMainTheme::from($theme),
                ) ?>
                <?= TooltipInfo::drawTooltipInfo('Короткое пояснение термина', TooltipMainTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Feedback/notice</h3>
            <div class="ui-showcase__grid">
                <?php foreach (FeedbackNoticeStyle::cases() as $style): ?>
                    <?= Notice::drawFeedbackNotice(
                        title: 'Заголовок ' . $style->value,
                        text: 'Строка под заголовком: что случилось и что делать',
                        style: $style,
                        theme: FeedbackNoticeTheme::from($theme),
                        close: true,
                        buttons: Button::drawButtonMain(
                            text: 'Действие',
                            style: ButtonMainStyle::Monochrome,
                            size: ButtonMainSize::Small,
                            theme: ButtonMainTheme::from($theme),
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
                <?php foreach (PlaceholderAvatarSize::cases() as $size): ?>
                    <?= Placeholder::drawPlaceholderAvatar('Иван Петров', size: $size, theme: PlaceholderAvatarTheme::from($theme)) ?>
                    <?= Placeholder::drawPlaceholderAvatar(
                        'Иван Петров',
                        size: $size,
                        style: PlaceholderAvatarStyle::Silhouette,
                        theme: PlaceholderAvatarTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <span class="ui-showcase__image"><?= Placeholder::drawPlaceholderAvatarNoImage(theme: PlaceholderAvatarTheme::from($theme)) ?></span>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Tabs/main</h3>
            <div class="ui-showcase__row">
                <?php foreach (TabMainStyle::cases() as $style): ?>
                    <?= Tab::drawTabMain(text: $style->name, style: $style, theme: TabMainTheme::from($theme)) ?>
                    <?= Tab::drawTabMain(text: 'active', style: $style, theme: TabMainTheme::from($theme), active: true) ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Inputs/main, textarea</h3>
            <div class="ui-showcase__row">
                <?= TextInput::drawInputMain(
                    placeholder: 'Название',
                    labelText: 'Название',
                    theme: InputMainTheme::from($theme),
                ) ?>
                <?= TextInput::drawInputMain(
                    placeholder: 'Email',
                    theme: InputMainTheme::from($theme),
                    value: 'admin@',
                    error: 'Неверный email',
                ) ?>
                <?= TextInput::drawInputMain(
                    placeholder: 'Пароль',
                    theme: InputMainTheme::from($theme),
                    id: 'ui-password-' . $theme,
                    kind: InputMainKind::Password,
                    value: 'secret',
                ) ?>
                <?= TextInput::drawInputMain(
                    placeholder: 'Логин',
                    theme: InputMainTheme::from($theme),
                    value: 'admin',
                    success: true,
                ) ?>
                <?= Textarea::drawTextarea(placeholder: 'Описание', theme: TextareaTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Dropdown/input, Dropdown/main</h3>
            <div class="ui-showcase__row ui-showcase__row_dropdowns">
                <span class="ui-showcase__field">
                    <?= Dropdown::drawDropdownMainSelect(
                        'ui_status_' . $theme,
                        ['new' => 'Новый', 'work' => 'В работе', 'done' => 'Выполнен', 'cancel' => 'Отменён'],
                        'work',
                        theme: DropdownMainTheme::from($theme),
                        attributes: ['aria-label' => 'Статус'],
                    ) ?>
                </span>
                <span class="ui-showcase__field">
                    <?= Dropdown::drawDropdownMainSelect(
                        'ui_city_' . $theme,
                        array_combine(
                            range(1, 12),
                            ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань', 'Нижний Новгород',
                                'Челябинск', 'Самара', 'Омск', 'Ростов-на-Дону', 'Уфа', 'Красноярск']
                        ),
                        placeholder: 'Город',
                        size: DropdownMainSize::Small,
                        theme: DropdownMainTheme::from($theme),
                        search: true,
                        attributes: ['aria-label' => 'Город'],
                    ) ?>
                </span>
                <?= Dropdown::drawDropdownMainMenu(
                    ButtonIcon::drawButtonIconSmall(
                        icon: 'dots-vertical',
                        label: 'Ещё',
                        style: ButtonIconSmallStyle::Secondary,
                        theme: ButtonIconSmallTheme::from($theme),
                    ),
                    [
                        ['text' => 'Редактировать', 'icon' => 'pencil-line', 'link' => '#edit'],
                        ['text' => 'Копировать', 'icon' => 'copy'],
                        ['text' => 'Удалить', 'icon' => 'trash'],
                    ],
                    theme: DropdownMainTheme::from($theme),
                    side: 'left',
                ) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Switches/sort, sort-button</h3>
            <div class="ui-showcase__row">
                <?php foreach (SwitchSortDirection::cases() as $direction): ?>
                    <?php foreach (SwitchSortButtonStyle::cases() as $style): ?>
                        <?= Sort::drawSwitchSort(
                            'Название',
                            '#asc',
                            '#desc',
                            $direction,
                            $style,
                            SwitchSortButtonTheme::from($theme),
                        ) ?>
                    <?php endforeach; ?>
                <?php endforeach; ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Stepper/main</h3>
            <div class="ui-showcase__row">
                <?php foreach (StepperMainSize::cases() as $size): ?>
                    <?= Stepper::drawStepperMain(
                        'ui_npp_' . $theme,
                        1,
                        min: 1,
                        max: 5,
                        size: $size,
                        theme: StepperMainTheme::from($theme),
                    ) ?>
                <?php endforeach; ?>
                <?= Stepper::drawStepperMain(
                    'ui_npp2_' . $theme,
                    5,
                    max: 5,
                    style: StepperMainStyle::Input,
                    fill: StepperMainFill::Outline,
                    theme: StepperMainTheme::from($theme),
                    error: 'Осталось только 5',
                ) ?>
                <?= Stepper::drawStepperMain('ui_npp3_' . $theme, 3, theme: StepperMainTheme::from($theme), loading: true) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Switches</h3>
            <div class="ui-showcase__row">
                <?= Checkbox::drawSwitchCheckbox(text: 'Чекбокс', theme: SwitchCheckboxTheme::from($theme)) ?>
                <?= Radio::drawSwitchRadio(text: 'Радио', id: 'ui-radio-' . $theme, theme: SwitchRadioTheme::from($theme)) ?>
                <?= Toggle::drawSwitchToggle(text: 'Переключатель', theme: SwitchToggleTheme::from($theme)) ?>
            </div>

            <h3 class="ui-showcase__subtitle ui-m">Badges, Tags</h3>
            <div class="ui-showcase__row">
                <?php foreach (BadgeStyle::cases() as $style): ?>
                    <?= Badge::drawBadge(text: $style->name, style: $style) ?>
                <?php endforeach; ?>
                <?= Tag::drawTag(text: 'Тег', theme: TagTheme::from($theme)) ?>
                <?= Tag::drawTag(text: 'Статус: новый', theme: TagTheme::from($theme), icon: 'filter', close: true) ?>
                <?= Toggle::drawSwitchToggle(
                    text: 'disabled',
                    theme: SwitchToggleTheme::from($theme),
                    attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
                ) ?>
                <?= Radio::drawSwitchRadio(
                    text: 'disabled',
                    id: 'ui-radio-disabled-' . $theme,
                    theme: SwitchRadioTheme::from($theme),
                    attributes: ['disabled' => 'disabled', 'checked' => 'checked'],
                ) ?>
                <?= Button::drawButtonMain(text: 'success', state: ButtonMainState::Success, size: ButtonMainSize::Small) ?>
                <?= Button::drawButtonMain(text: 'error', state: ButtonMainState::Error, size: ButtonMainSize::Small) ?>
                <?= LoaderIcon::drawLoaderMain(theme: LoaderMainTheme::from($theme)) ?>
                <?= LoaderIcon::drawLoaderMain(LoaderMainSize::Small, LoaderMainStyle::Monochrome, LoaderMainTheme::from($theme)) ?>
            </div>
        </section>
    <?php endforeach; ?>

    <section class="ui-showcase__theme" aria-label="Тосты">
        <h2 class="ui-showcase__title heading-h4">Feedback/toast</h2>
        <div class="ui-showcase__row">
            <?php foreach (FeedbackToastStyle::cases() as $style): ?>
                <?= Toast::drawFeedbackToast(
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
            <?php foreach (FeedbackToastStyle::cases() as $style): ?>
                <?= Button::drawButtonMain(
                    text: 'sfToast ' . $style->value,
                    style: ButtonMainStyle::Secondary,
                    size: ButtonMainSize::Small,
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
<?= Toast::drawFeedbackToastStack() ?>
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

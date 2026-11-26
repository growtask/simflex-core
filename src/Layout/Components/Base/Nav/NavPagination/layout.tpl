<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Base\Nav\NavPagination\Layout as Pagination;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainSize;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainStyle;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainSize;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainStyle;
use Simflex\Core\Layout\Components\UI\Tab\TabMain\TabMainTheme;
use Simflex\Core\Layout\Components\UI\Input\InputMain\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainSize;
use Simflex\Core\Layout\Components\UI\Input\InputMain\InputMainTheme;

$theme = $data['theme'];
$page = $data['page'];
$pageCount = $data['pageCount'];
$arrow = fn(int $to, string $icon, string $label, bool $disabled) => Button::drawButtonMain(
    link: $disabled ? '' : Pagination::getUrl($data['urlPattern'], $to, $data['urlPageOffset']),
    icon: $icon,
    style: ButtonMainStyle::Flat,
    size: ButtonMainSize::Small,
    theme: ButtonMainTheme::from($theme),
    attributes: ['aria-label' => $label],
    disabled: $disabled,
);
?>
<nav class="pagination pagination_type_<?= $data['type'] ?> pagination-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>"
     aria-label="<?= htmlspecialchars($data['label']) ?>">
    <?php if ($data['type'] === 'more'): ?>
        <div class="pagination__more">
            <?= Button::drawButtonMain(
                text: $data['moreText'],
                link: $page >= $pageCount ? '' : Pagination::getUrl($data['urlPattern'], $page + 1, $data['urlPageOffset']),
                style: ButtonMainStyle::Secondary,
                size: ButtonMainSize::Small,
                theme: ButtonMainTheme::from($theme),
                attributes: ['data-sf-pagination-more' => ''],
                disabled: $page >= $pageCount,
            ) ?>
            <?php if ($data['caption'] !== ''): ?>
                <span class="pagination__caption" aria-live="polite"><?= htmlspecialchars($data['caption']) ?></span>
            <?php endif; ?>
        </div>
    <?php else: ?>
    <div class="pagination__pages">
        <?= $arrow($page - 1, 'chevron-s-left', 'Предыдущая страница', $page <= 1) ?>
        <?php if ($data['type'] === 'compact'): ?>
            <span class="pagination__compact"><?= $page ?> / <?= $pageCount ?></span>
        <?php else: ?>
            <ol class="pagination__list">
                <?php foreach ($data['pages'] as $number): ?>
                    <?php if ($number === Pagination::GAP): ?>
                        <li class="pagination__gap pagination__item_desktop" aria-hidden="true">…</li>
                    <?php else: ?>
                        <li class="pagination__item<?= in_array($number, $data['mobilePages'], true) ? '' : ' pagination__item_desktop' ?>">
                            <?= Tab::drawTabMain(
                                text: (string)$number,
                                link: Pagination::getUrl($data['urlPattern'], $number, $data['urlPageOffset']),
                                style: TabMainStyle::Soft,
                                size: TabMainSize::Small,
                                theme: TabMainTheme::from($theme),
                                attributes: ['aria-label' => 'Страница ' . $number],
                                active: $number === $page,
                            ) ?>
                        </li>
                    <?php endif; ?>
                <?php endforeach; ?>
            </ol>
        <?php endif; ?>
        <?= $arrow($page + 1, 'chevron-s-right', 'Следующая страница', $page >= $pageCount) ?>
    </div>
    <?php if ($data['search'] && $pageCount > 1): ?>
        <form class="pagination__search" data-sf-pagination-search
              data-url-pattern="<?= htmlspecialchars($data['urlPattern']) ?>" data-page-count="<?= $pageCount ?>"
              data-page-offset="<?= (int)$data['urlPageOffset'] ?>">
            <?= TextInput::drawInputMain(
                className: 'pagination__input',
                placeholder: 'Стр.',
                size: InputMainSize::Small,
                theme: InputMainTheme::from($theme),
                reset: false,
                attributes: [
                    'inputmode' => 'numeric',
                    'aria-label' => 'Номер страницы, от 1 до ' . $pageCount,
                    'name' => 'page',
                ],
            ) ?>
            <?= Button::drawButtonMain(
                text: 'Перейти',
                style: ButtonMainStyle::Gray,
                size: ButtonMainSize::Small,
                theme: ButtonMainTheme::from($theme),
                attributes: ['type' => 'submit'],
            ) ?>
        </form>
    <?php endif; ?>
    <?php endif; ?>
</nav>

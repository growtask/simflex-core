<?php

/** @var array $data */

use Simflex\Core\Layout\Components\Common\Pagination\Layout as Pagination;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Tab\Layout as Tab;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabSize;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabStyle;
use Simflex\Core\Layout\Components\UI\Core\Tab\TabTheme;
use Simflex\Core\Layout\Components\UI\Core\TextInput\Layout as TextInput;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputSize;
use Simflex\Core\Layout\Components\UI\Core\TextInput\TextInputTheme;

$theme = $data['theme'];
$page = $data['page'];
$pageCount = $data['pageCount'];
$arrow = fn(int $to, string $icon, string $label, bool $disabled) => Button::drawButton(
    link: $disabled ? '' : Pagination::getUrl($data['urlPattern'], $to, $data['urlPageOffset']),
    icon: $icon,
    style: ButtonStyle::Flat,
    size: ButtonSize::Small,
    theme: ButtonTheme::from($theme),
    attributes: ['aria-label' => $label],
    disabled: $disabled,
);
?>
<nav class="pagination pagination_type_<?= $data['type'] ?> pagination-theme_<?= $theme ?> <?= htmlspecialchars($data['className']) ?>"
     aria-label="<?= htmlspecialchars($data['label']) ?>">
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
                            <?= Tab::drawTab(
                                text: (string)$number,
                                link: Pagination::getUrl($data['urlPattern'], $number, $data['urlPageOffset']),
                                style: TabStyle::Soft,
                                size: TabSize::Small,
                                theme: TabTheme::from($theme),
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
            <?= TextInput::drawInput(
                className: 'pagination__input',
                placeholder: 'Стр.',
                size: TextInputSize::Small,
                theme: TextInputTheme::from($theme),
                reset: false,
                attributes: [
                    'inputmode' => 'numeric',
                    'aria-label' => 'Номер страницы, от 1 до ' . $pageCount,
                    'name' => 'page',
                ],
            ) ?>
            <?= Button::drawButton(
                text: 'Перейти',
                style: ButtonStyle::Gray,
                size: ButtonSize::Small,
                theme: ButtonTheme::from($theme),
                attributes: ['type' => 'submit'],
            ) ?>
        </form>
    <?php endif; ?>
</nav>

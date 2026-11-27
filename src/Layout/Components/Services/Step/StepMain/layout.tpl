<?php
/** @var array $data */

use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitTheme;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\ItemBenefitType;
use Simflex\Core\Layout\Components\Base\Item\ItemBenefit\Layout as Benefit;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\Layout as Slider;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\SliderMainTheme;
use Simflex\Core\Layout\Components\Base\Slider\SliderMain\SliderMainType;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\ButtonMainTheme;
use Simflex\Core\Layout\Components\UI\Button\ButtonMain\Layout as Button;

$esc = static fn($value): string => htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
$scroll = $data['style'] === 'scroll';
$h = 'h' . $data['headingLevel'];
$last = count($data['steps']) - 1;
$items = [];
foreach ($data['steps'] as $i => $step) {
    $done = $data['progress'] && !empty($step['done']);
    $items[] = Benefit::drawItemBenefit(
        title: (string)$step['title'],
        text: (string)($step['text'] ?? ''),
        icon: $done ? 'check' : '',
        number: str_pad((string)($i + 1), 2, '0', STR_PAD_LEFT),
        badge: (string)($step['badge'] ?? ''),
        line: !$scroll && $i !== $last,
        type: $done ? ItemBenefitType::Icon : ItemBenefitType::Number,
        card: $scroll,
        theme: ItemBenefitTheme::from($data['theme']),
        headingLevel: min(6, $data['headingLevel'] + 1),
        className: 'steps__step' . ($done ? ' steps__step_done' : ''),
        attributes: $done ? ['aria-label' => 'Пройдено: ' . $step['title']] : [],
    );
}
$classes = ['steps', "steps_style_{$data['style']}", "steps-theme_{$data['theme']}",
    $data['progress'] ? 'steps_progress' : '', $data['className']];
?>
<section class="<?= $esc(implode(' ', array_filter($classes))) ?>">
    <?php if ($data['title'] !== ''): ?>
        <<?= $h ?> class="steps__title"><?= $esc($data['title']) ?></<?= $h ?>>
    <?php endif; ?>
    <?php if ($scroll): ?>
        <?= Slider::drawSliderMain(
            cards: array_map(static fn(string $li) => '<ul class="steps__card">' . $li . '</ul>', $items),
            type: SliderMainType::None,
            theme: SliderMainTheme::from($data['theme']),
            heading: false,
            label: $data['title'] !== '' ? $data['title'] : 'Шаги',
            className: 'steps__slider slider_view_tablet',
        ) ?>
    <?php else: ?>
        <ol class="steps__list"><?= implode('', $items) ?></ol>
    <?php endif; ?>
    <?php if ($data['actionText'] !== ''): ?>
        <div class="steps__footer">
            <?= Button::drawButtonMain(
                className: 'steps__action',
                text: $esc($data['actionText']),
                link: $data['actionLink'],
                theme: ButtonMainTheme::from($data['theme']),
                attributes: $data['actionAttributes'],
            ) ?>
        </div>
    <?php endif; ?>
</section>

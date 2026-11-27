<?php

/**
 * Демо PlayerWave: стили primary и accent, размеры, проиграно 0, 40 и 100 % (витрина Layout\LayoutShowcase)
 * @var string $theme Тема витрины: light или dark
 */

use Simflex\Core\Layout\Components\Base\Player\PlayerWave\Layout as PlayerWave;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveSize;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveStyle;
use Simflex\Core\Layout\Components\Base\Player\PlayerWave\PlayerWaveTheme;

?>
<?php foreach (PlayerWaveStyle::cases() as $style): ?>
    <?php foreach (PlayerWaveSize::cases() as $size): ?>
        <h3 class="ui-showcase__subtitle ui-m"><?= $style->name ?>, <?= $size->name ?></h3>
        <div class="ui-showcase__row">
            <?php foreach ([0, 0.4, 1] as $progress): ?>
                <div style="width:320px"><?= PlayerWave::drawPlayerWave(progress: $progress, style: $style, size: $size, theme: PlayerWaveTheme::from($theme)) ?></div>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
<?php endforeach; ?>

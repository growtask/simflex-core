<?php

/** @var array $data */

use Simflex\Core\Layout\Components\UI\Link\LinkMain\Layout as Link;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainSize;
use Simflex\Core\Layout\Components\UI\Link\LinkMain\LinkMainTheme;

$theme = $data['theme'];
$columns = $data['columns'];
$expanded = $data['state'] === 'expanded';
$id = 'seo-' . substr(md5(serialize($columns)), 0, 8);
$headingTag = 'h' . $data['headingLevel'];
?>
<section class="seo seo-theme_<?= $theme ?> seo_columns_<?= count($columns) ?><?= $expanded ? ' seo_expanded' : '' ?> <?= htmlspecialchars($data['className']) ?>"
         data-sf-seo>
    <div class="seo__content" id="<?= $id ?>">
        <?php foreach ($columns as $column): ?>
            <div class="seo__column">
                <?php if (($column['title'] ?? '') !== ''): ?>
                    <<?= $headingTag ?> class="seo__title"><?= htmlspecialchars($column['title']) ?></<?= $headingTag ?>>
                <?php endif; ?>
                <?php if (($column['text'] ?? '') !== ''): ?>
                    <div class="seo__text"><?= $column['text'] ?></div>
                <?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>
    <?php if ($data['more']): ?>
        <div class="seo__more">
            <?= Link::drawLinkMain(
                text: $expanded ? $data['lessLabel'] : $data['moreLabel'],
                href: '#' . $id,
                size: LinkMainSize::Medium,
                theme: LinkMainTheme::from($theme),
                attributes: [
                    'role' => 'button',
                    'aria-expanded' => $expanded ? 'true' : 'false',
                    'aria-controls' => $id,
                    'data-sf-seo-toggle' => '',
                    'data-more' => $data['moreLabel'],
                    'data-less' => $data['lessLabel'],
                ],
            ) ?>
        </div>
    <?php endif; ?>
    <?php if ($data['tags'] !== []): ?>
        <div class="seo__tags">
            <p class="seo__tags-title"><?= htmlspecialchars($data['tagsTitle']) ?></p>
            <ul class="seo__tags-list">
                <?php foreach ($data['tags'] as $tag): ?>
                    <li>
                        <a class="tag tag-gray tag-size_s tag-theme_<?= $theme ?>" href="<?= htmlspecialchars($tag['link']) ?>">
                            <span class="tag__text"><?= htmlspecialchars($tag['name']) ?></span>
                        </a>
                    </li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>
</section>

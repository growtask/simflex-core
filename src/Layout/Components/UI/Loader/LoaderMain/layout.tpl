<?php
/** @var array $data */
?>

<svg class="loader-icon <?= $data['className'] ?? '' ?>"
     viewBox="0 0 40 40"
>
    <circle class="loader-icon__track"
            cx="20"
            cy="20"
            r="18"
            pathlength="100"
            stroke-width="4"
            fill="none"
            stroke="currentColor"
    />
    <circle class="loader-icon__car"
            cx="20"
            cy="20"
            r="18"
            pathlength="100"
            fill="none"
            stroke="currentColor"
    />
</svg>
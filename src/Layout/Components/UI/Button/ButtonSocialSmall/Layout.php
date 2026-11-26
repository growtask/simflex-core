<?php

namespace Simflex\Core\Layout\Components\UI\Button\ButtonSocialSmall;

use Simflex\Core\Layout\LayoutBase;

/**
 * Маленькая квадратная ссылка на соцсеть (Figma: UI/buttons/social-small)
 */
class Layout extends LayoutBase
{
    /**
     * @param string $className Дополнительные CSS-классы
     * @param string $href Адрес страницы в соцсети
     * @param string $label Доступное имя ссылки; если пусто, берётся название сети
     * @param array<string,mixed> $attributes Дополнительные HTML-атрибуты ссылки
     */
    public static function drawButtonSocialSmall(
        ButtonSocialSmallNetwork $network,
        string        $href = '',
        string        $className = '',
        string        $label = '',
        ButtonSocialSmallStyle   $style = ButtonSocialSmallStyle::Default,
        ButtonSocialSmallSize    $size = ButtonSocialSmallSize::Medium,
        ButtonSocialSmallTheme   $theme = ButtonSocialSmallTheme::Light,
        bool          $external = true,
        array         $attributes = []
    ): string {
        return static::draw(
            compact(
                'className',
                'href',
                'external',
                'attributes'
            ) + [
                'label' => $label !== '' ? $label : static::getNetworkTitle($network),
                'network' => $network->value,
                'style' => $style->value,
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }

    /**
     * Название сети для доступного имени ссылки
     */
    public static function getNetworkTitle(ButtonSocialSmallNetwork $network): string
    {
        return match ($network) {
            ButtonSocialSmallNetwork::Figma => 'Figma',
            ButtonSocialSmallNetwork::Google => 'Google',
            ButtonSocialSmallNetwork::Instagram => 'Instagram',
            ButtonSocialSmallNetwork::Max => 'Max',
            ButtonSocialSmallNetwork::Rutube => 'Rutube',
            ButtonSocialSmallNetwork::Telegram => 'Telegram',
            ButtonSocialSmallNetwork::Vkontakte => 'VK',
            ButtonSocialSmallNetwork::Whatsapp => 'WhatsApp',
            ButtonSocialSmallNetwork::Yandex => 'Яндекс',
            ButtonSocialSmallNetwork::YandexZen => 'Дзен',
            ButtonSocialSmallNetwork::Youtube => 'YouTube',
        };
    }
}

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
    public static function drawSocial(
        SocialNetwork $network,
        string        $href = '',
        string        $className = '',
        string        $label = '',
        SocialStyle   $style = SocialStyle::Default,
        SocialSize    $size = SocialSize::Medium,
        SocialTheme   $theme = SocialTheme::Light,
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
    public static function getNetworkTitle(SocialNetwork $network): string
    {
        return match ($network) {
            SocialNetwork::Figma => 'Figma',
            SocialNetwork::Google => 'Google',
            SocialNetwork::Instagram => 'Instagram',
            SocialNetwork::Max => 'Max',
            SocialNetwork::Rutube => 'Rutube',
            SocialNetwork::Telegram => 'Telegram',
            SocialNetwork::Vkontakte => 'VK',
            SocialNetwork::Whatsapp => 'WhatsApp',
            SocialNetwork::Yandex => 'Яндекс',
            SocialNetwork::YandexZen => 'Дзен',
            SocialNetwork::Youtube => 'YouTube',
        };
    }
}

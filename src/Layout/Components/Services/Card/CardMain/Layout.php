<?php

namespace Simflex\Core\Layout\Components\Services\Card\CardMain;

use Simflex\Core\Layout\LayoutBase;

/**
 * Карточка услуги (Figma Services/Cards/main) для списков услуг и главной: картинка, ярлык, заголовок со стрелкой,
 * описание, цена «от» со старой ценой, время и кнопка «Заказать». Вся карточка — ссылка на страницу услуги
 * (ссылка заголовка растянута на карточку), кнопка «Заказать» — отдельно поверх неё. Наведение: заголовок цвета
 * бренда, стрелка поворачивается вправо; нажатие — фон color1/lighter; фокус с клавиатуры — кольцо вокруг карточки
 */
class Layout extends LayoutBase
{
    /**
     * @param string $title Название услуги (Figma title text)
     * @param string $link Адрес страницы услуги
     * @param string $description Описание; пусто — без него
     * @param string $image Картинка (путь от корня сайта); пусто — без неё (Figma image)
     * @param string $label Ярлык над заголовком («Хит»); пусто — без него
     * @param string $price Цена; пусто — без цены
     * @param string $from Приставка цены «от»; пусто — без неё
     * @param string $oldPrice Старая цена; пусто — без неё
     * @param string $time Время работы; пусто — без него
     * @param string $orderText Текст кнопки; пусто — без кнопки (Figma action)
     * @param array<string,mixed> $orderAttributes HTML-атрибуты кнопки (data-modal и т. п.)
     * @param bool $arrow Стрелка у заголовка
     * @param bool $disabled Услуга недоступна: карточка бледная и не ссылка
     * @param int $headingLevel Уровень заголовка
     * @param string $className Дополнительные CSS-классы (service-card_view_mobile — вид телефона для витрины)
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     */
    public static function drawCardMain(
        string         $title,
        string         $link = '',
        string         $description = '',
        string         $image = '',
        string         $label = '',
        string         $price = '',
        string         $from = 'от',
        string         $oldPrice = '',
        string         $time = '',
        string         $orderText = 'Заказать',
        array          $orderAttributes = [],
        bool           $arrow = true,
        bool           $disabled = false,
        CardMainLayout $layout = CardMainLayout::Card,
        CardMainTheme  $theme = CardMainTheme::Light,
        int            $headingLevel = 3,
        string         $className = '',
        array          $attributes = [],
    ): string {
        return static::draw(compact(
            'title', 'link', 'description', 'image', 'label', 'price', 'from', 'oldPrice', 'time', 'orderText',
            'orderAttributes', 'arrow', 'disabled', 'className', 'attributes'
        ) + [
            'layout' => $layout->value,
            'theme' => $theme->value,
            'headingLevel' => min(6, max(1, $headingLevel)),
        ]);
    }
}

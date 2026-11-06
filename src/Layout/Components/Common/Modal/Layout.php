<?php

namespace Simflex\Core\Layout\Components\Common\Modal;

use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\LayoutBase;

/**
 * Модальное окно (Figma: Base/Modal/main, docs: design-base-modal.md).
 *
 * Окно скрыто, пока его не откроют: кнопка с атрибутом data-modal="<id>" или window.SimflexModal.open('<id>').
 * Скрипт компонента обеспечивает role="dialog", ловушку фокуса, Esc, закрытие по подложке, блокировку прокрутки
 * страницы, inert для фона и возврат фокуса. Окно выводится на странице один раз (обычно в теме).
 * На tablet и mobile окно - шторка снизу.
 *
 * События на корне окна: modal:open, modal:close. Содержимое окна можно закрыть элементом с data-modal-close.
 */
class Layout extends LayoutBase
{
    /**
     * @param string $id Идентификатор окна, по нему окно открывается (data-modal)
     * @param string $title Заголовок
     * @param string $text Текст под заголовком (необязательно)
     * @param string $content HTML содержимого окна (форма, результат и т. п.)
     * @param string $footer HTML подвала окна (кнопки), пусто - подвала нет
     * @param string $closeLabel Подпись кнопки закрытия для скринридера
     * @param bool $closeOnOverlay Закрывать ли окно кликом по подложке
     * @param string $className Дополнительные CSS-классы корня
     * @param array<string,mixed> $attributes HTML-атрибуты корня
     * @param bool $alert Окно требует ответа (подтверждение удаления и т. п.): role="alertdialog"
     * @param string $headAction HTML действия в шапке справа от заголовка (ссылка «Сбросить» и т. п.)
     */
    public static function drawModal(
        string $id,
        string $title = '',
        string $text = '',
        string $content = '',
        string $footer = '',
        string $closeLabel = 'Закрыть',
        bool $closeOnOverlay = true,
        ModalSize $size = ModalSize::ExtraSmall,
        ModalTheme $theme = ModalTheme::Light,
        string $className = '',
        array $attributes = [],
        bool $alert = false,
        string $headAction = '',
    ): string {
        $closeButton = Button::drawButton(
            className: 'modal__close',
            style: ButtonStyle::Gray,
            size: ButtonSize::Medium,
            theme: $theme === ModalTheme::Dark ? ButtonTheme::Dark : ButtonTheme::Light,
            iconLeft: 'close',
            attributes: ['type' => 'button', 'aria-label' => $closeLabel, 'data-modal-close' => ''],
        );

        return static::draw(
            compact(
                'id',
                'title',
                'text',
                'content',
                'footer',
                'closeOnOverlay',
                'className',
                'attributes',
                'closeButton',
                'alert',
                'headAction'
            ) + [
                'size' => $size->value,
                'theme' => $theme->value,
            ]
        );
    }
}

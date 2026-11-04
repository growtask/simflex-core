<?php

namespace Simflex\Core\Layout\Components\Common\Uploader;

use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonSize;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\ButtonTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\Button\Layout as Button;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconStyle;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\ButtonIconTheme;
use Simflex\Core\Layout\Components\UI\Core\Buttons\ButtonIcon\Layout as ButtonIcon;
use Simflex\Core\Layout\LayoutBase;

/**
 * Загрузка одного файла (Figma Base/Uploader: Uploader/drop, Uploader/button, Uploader/action «Из библиотеки»,
 * Uploader/file, Uploader/image; design-base-uploader.md). Пустой — зона перетаскивания с кнопкой «Выбрать файл»
 * и «Из библиотеки» (window.fileManager); с файлом — строка с превью или иконкой, именем, «Заменить» и «Удалить».
 * Загрузка — POST <uploadUrl> с файлом в поле uploadField и полями uploadData, прогресс в строке; ответ — имя
 * файла (пусто — не принят). Из библиотеки — тот же запрос с полем source (адрес файла). Значение — в скрытом
 * поле name: valuePrefix + имя (событие change) (script.js)
 *
 * Ссылка, сжатие, конвертация, alt и несколько файлов набора Figma не сделаны.
 */
class Layout extends LayoutBase
{
    private static int $counter = 0;

    /**
     * @param string $value Значение скрытого поля (имя или адрес файла); пусто — файла нет
     * @param string $previewUrl Адрес превью картинки или ссылка на файл
     * @param string $fileName Подпись файла (по умолчанию — имя из value)
     * @param string $accept Типы файлов для выбора (accept input file), например image/*
     * @param string $uploadUrl Адрес загрузки
     * @param string $uploadField Поле файла в запросе загрузки
     * @param array<string,string> $uploadData Дополнительные поля запроса загрузки
     * @param string $valuePrefix Приставка к имени из ответа: значение скрытого поля и адрес превью
     * @param string $hint Ограничения под заголовком зоны (форматы, размер)
     * @param bool $library Кнопка «Из библиотеки» (файловый менеджер админки)
     * @param string $deleteUrl «Удалить» у сохранённого файла: POST на этот адрес (удаление файла и значения
     *        в записи); пусто — только очищается поле
     * @param array<string,string> $attributes Атрибуты корня
     */
    public static function drawUploader(
        string        $name,
        string        $value = '',
        UploaderKind  $kind = UploaderKind::File,
        string        $previewUrl = '',
        string        $fileName = '',
        string        $accept = '',
        string        $uploadUrl = '',
        string        $uploadField = 'file',
        array         $uploadData = [],
        string        $valuePrefix = '',
        string        $hint = '',
        bool          $library = false,
        string        $deleteUrl = '',
        UploaderTheme $theme = UploaderTheme::Light,
        bool          $disabled = false,
        string        $label = '',
        string        $id = '',
        string        $className = '',
        array         $attributes = [],
    ): string {
        $id = $id !== '' ? $id : 'sf-uploader-' . ++self::$counter;
        $buttonTheme = ButtonTheme::from($theme->value);
        $iconTheme = ButtonIconTheme::from($theme->value);
        $pick = Button::drawButton(
            text: 'Выбрать файл',
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-sf-uploader-pick' => ''],
            iconLeft: 'upload',
            disabled: $disabled,
        );
        $fromLibrary = $library ? Button::drawButton(
            text: 'Из библиотеки',
            style: ButtonStyle::Secondary,
            size: ButtonSize::Small,
            theme: $buttonTheme,
            attributes: ['data-sf-uploader-library' => ''],
            iconLeft: 'folder',
            disabled: $disabled,
        ) : '';
        $replace = ButtonIcon::drawButtonIcon(
            icon: 'refresh-1',
            label: 'Заменить',
            style: ButtonIconStyle::Secondary,
            theme: $iconTheme,
            attributes: ['data-sf-uploader-pick' => ''],
            disabled: $disabled,
        );
        $remove = ButtonIcon::drawButtonIcon(
            icon: 'trash',
            label: 'Удалить',
            style: ButtonIconStyle::Secondary,
            theme: $iconTheme,
            attributes: ['data-sf-uploader-remove' => ''],
            disabled: $disabled,
        );
        $fileName = $fileName !== '' ? $fileName : basename($value);

        return static::draw(compact(
            'name',
            'value',
            'previewUrl',
            'fileName',
            'accept',
            'uploadUrl',
            'uploadField',
            'uploadData',
            'valuePrefix',
            'hint',
            'library',
            'deleteUrl',
            'disabled',
            'label',
            'id',
            'className',
            'attributes',
            'pick',
            'fromLibrary',
            'replace',
            'remove'
        ) + [
            'kind' => $kind->value,
            'theme' => $theme->value,
        ]);
    }
}

<?php

namespace Simflex\Core\Admin\Fields;

class FieldTable extends Field
{
    public function isWide(): bool
    {
        return true;
    }

    /**
     * Строковое поле
     */
    public const TYPE_TEXT = 'text';

    /**
     * Поле-список (select)
     */
    public const TYPE_COMBO = 'combo';

    /**
     * Поле с WYSIWYG-редактором
     */
    public const TYPE_EDITOR = 'editor';

    /**
     * Поле загрузки изображения
     */
    public const TYPE_IMAGE = 'image';

    /**
     * Поле загрузки файла
     */
    public const TYPE_FILE = 'file';

    public const STRUCT_VALUE = [
        [
            'n' => 'n',
            't' => 'text',
            'l' => 'Имя',
            'v' => '',
            'e' => '',
        ],
        [
            'n' => 't',
            't' => 'combo',
            'l' => 'Тип',
            'v' => 'text',
            'e' => 'text=Текст,,int=Число,,combo=Список,,editor=Редактор,,image=Изображение,,file=Файл',
        ],
        [
            'n' => 'l',
            't' => 'text',
            'l' => 'Заголовок',
            'v' => '',
            'e' => '',
        ],
        [
            'n' => 'v',
            't' => 'text',
            'l' => 'Значение',
            'v' => '',
            'e' => '',
        ],
        [
            'n' => 'e',
            't' => 'text',
            'l' => 'Дополнительно',
            'v' => '',
            'e' => '',
        ],
    ];

    public static function makeStruct(
        string $name,
        string $type,
        string $label,
        string $value = '',
        string $extra = ''
    ): array {
        return [
            'n' => $name,
            't' => $type,
            'l' => $label,
            'v' => $value,
            'e' => $extra,
        ];
    }

    public static function makeValue(array $struct, array $values): string
    {
        return json_encode(['s' => $struct, 'v' => $values], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    }

    public function input($value): string
    {
        $value = (string)$value;
        $struct = (string)($this->params['struct'] ?? '');

        // значение по умолчанию = []
        $value = !json_decode($value, true) ? '[]' : $value;
        if ($value === '[]' && $struct) {
            $s = json_decode($struct, true);
            $v = json_decode($value, true);

            $v['s'] = $s['v'];
            $v['v'] = [];
            $value = json_encode($v);
        }

        $tmpVal = json_decode($value, true);
        if ($struct && $tmpVal['s'] != $struct) {
            $s = json_decode($struct, true);
            $v = json_decode($value, true);

            $v['s'] = $s['v'];
            foreach ($v['s'] as $s) {
                for ($i = 0; $i < count($v['v']); ++$i) {
                    if (!isset($v['v'][$i][$s['n']])) {
                        $v['v'][$i][$s['n']] = '';
                    }
                }
            }

            $value = json_encode($v);
        }

        return $this->render('table', ['value' => $value, 'isVirtual' => false, 'total' => 0, 'attributes' => []]);
    }
}

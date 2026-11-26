<?php

namespace Simflex\Core\Layout\Components\Parts\States;

use Simflex\Core\Layout\Components\UI\Marker\MarkerStyle;

/**
 * Состояние страницы или блока (наборы Figma states/empty, load, alert, success, error)
 */
enum StatesStyle: string
{
    case Empty = 'empty';
    case Load = 'load';
    case Alert = 'alert';
    case Success = 'success';
    case Error = 'error';

    /**
     * Стиль маркера состояния
     */
    public function getMarkerStyle(): MarkerStyle
    {
        return match ($this) {
            self::Empty => MarkerStyle::Main,
            self::Load => MarkerStyle::Load,
            self::Alert => MarkerStyle::Alert,
            self::Success => MarkerStyle::Success,
            self::Error => MarkerStyle::Error,
        };
    }

    /**
     * Заголовок по умолчанию (тексты Figma)
     */
    public function getTitle(): string
    {
        return match ($this) {
            self::Empty => 'Заголовок',
            self::Load => 'Загрузка',
            self::Alert => 'Внимание',
            self::Success => 'Готово',
            self::Error => 'Что-то пошло не так',
        };
    }

    /**
     * Текст по умолчанию (тексты Figma)
     */
    public function getText(): string
    {
        return match ($this) {
            self::Empty => 'Описание',
            self::Load => 'Подождите немного',
            self::Alert => 'Проверьте данные, прежде чем продолжить',
            self::Success => 'Всё прошло успешно',
            self::Error => 'Попробуйте позже',
        };
    }

    /**
     * Подпись основной кнопки по умолчанию
     */
    public function getPrimaryText(): string
    {
        return match ($this) {
            self::Empty, self::Success, self::Load => 'Каталог',
            self::Alert => 'Продолжить',
            self::Error => 'Повторить',
        };
    }

    /**
     * Подпись второй кнопки по умолчанию
     */
    public function getSecondaryText(): string
    {
        return $this === self::Alert ? 'Отмена' : 'Главная';
    }

    /**
     * Кнопки по умолчанию: в Figma их нет только у состояния загрузки
     */
    public function hasButtons(): bool
    {
        return $this !== self::Load;
    }

    /**
     * Роль для скринридеров: ошибку и предупреждение озвучивают сразу, остальное - как статус; пустое состояние - обычный блок
     */
    public function getRole(): string
    {
        return match ($this) {
            self::Empty => '',
            self::Alert, self::Error => 'alert',
            self::Load, self::Success => 'status',
        };
    }
}

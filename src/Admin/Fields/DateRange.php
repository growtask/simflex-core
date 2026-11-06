<?php

namespace Simflex\Core\Admin\Fields;

/**
 * Значение фильтра «период» у полей даты (FieldDate, FieldDateTime): `ГГГГ-ММ-ДД|ГГГГ-ММ-ДД` — от и до
 * включительно, любая граница может быть пустой
 */
class DateRange
{
    public const SEPARATOR = '|';

    /**
     * Границы периода 'Y-m-d', null — граница не задана или не дата
     * @return array{0: ?string, 1: ?string}
     */
    public static function parse(string $value): array
    {
        [$from, $to] = explode(self::SEPARATOR, $value, 2) + [1 => ''];

        return [self::getDate($from), self::getDate($to)];
    }

    /**
     * Подпись периода для тега над списком: «01.11.2026 — 30.11.2026», «с 01.11.2026», «по 30.11.2026»
     */
    public static function getLabel(string $value): string
    {
        [$from, $to] = self::parse($value);

        return match (true) {
            $from !== null && $to !== null => self::toLocal($from) . ' — ' . self::toLocal($to),
            $from !== null => 'с ' . self::toLocal($from),
            $to !== null => 'по ' . self::toLocal($to),
            default => '',
        };
    }

    /**
     * Дата 'Y-m-d' → 'd.m.Y' (формат полей с календарём)
     */
    public static function toLocal(?string $date): string
    {
        return $date !== null ? date('d.m.Y', (int)strtotime($date)) : '';
    }

    private static function getDate(string $date): ?string
    {
        $date = trim($date);
        $isDate = preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)
            && checkdate((int)substr($date, 5, 2), (int)substr($date, 8, 2), (int)substr($date, 0, 4));

        return $isDate ? $date : null;
    }
}

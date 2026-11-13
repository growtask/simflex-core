<?php

namespace Simflex\Core\Logger;

use Psr\Log\AbstractLogger;
use Psr\Log\LogLevel;
use Simflex\Core\System\Container;

class StdLogger extends AbstractLogger
{
    protected const ANSI = [
        'fg' => [
            'black' => 30,
            'blue' => 34,
            'green' => 32,
            'cyan' => 36,
            'red' => 31,
            'purple' => 35,
            'yellow' => 33,
            'white' => 37,
        ],
        'bg' => [
            'black' => 40,
            'red' => 41,
            'green' => 42,
            'yellow' => 43,
            'blue' => 44,
            'magenta' => 45,
            'cyan' => 46,
            'light_gray' => 47,
        ],
    ];

    protected function toString(mixed $object): string
    {
        if (is_array($object) || is_object($object)) {
            $object = var_export($object, true);
        }

        return str_replace("\n", ' ', (string)$object);
    }

    protected function interpolate(string|\Stringable $message, array $context = []): string
    {
        $replace = [];
        foreach ($context as $key => $val) {
            $replace['{' . $key . '}'] = $this->toString($val);
        }

        return strtr($message, $replace);
    }

    protected function colorLevel($level): string
    {
        $colors = [];
        switch ($level) {
            case LogLevel::NOTICE:
                $colors[] = static::ANSI['fg']['green'];
                break;
            case LogLevel::WARNING:
                $colors[] = static::ANSI['fg']['yellow'];
                break;
            case LogLevel::ERROR:
            case LogLevel::CRITICAL:
                $colors[] = static::ANSI['fg']['red'];
                break;
            case LogLevel::ALERT:
            case LogLevel::EMERGENCY:
                $colors[] = static::ANSI['fg']['white'];
                $colors[] = static::ANSI['bg']['red'];
                break;
        }

        $out = '';
        foreach ($colors as $col) {
            $out .= "\033[" . $col . 'm';
        }

        $out .= $level;
        $out .= "\033[0m";
        return $out;
    }

    public function log($level, \Stringable|string $message, array $context = []): void
    {
        if ($level === LogLevel::DEBUG && !Container::getConfig()->devMode) {
            return;
        }
        $stream = fopen('php://stdout', 'w');
        if ($stream === false) {
            return;
        }
        $levelText = $this->isColored($stream) ? $this->colorLevel($level) : (string)$level;
        fwrite($stream, date('H:i:s') . ' [' . $levelText . '] ' . $this->interpolate($message, $context) . "\n");
        fclose($stream);
    }

    /**
     * Цвет уровня — только в терминале: в журнале контейнера и файлах коды ANSI остаются мусором (#033[31m)
     *
     * @param resource $stream
     */
    protected function isColored($stream): bool
    {
        return stream_isatty($stream);
    }
}

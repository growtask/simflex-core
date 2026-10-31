<?php

namespace Simflex\Core\Console;

use Exception;
use ReflectionClass;
use ReflectionException;
use ReflectionMethod;
use ReflectionParameter;
use Psr\Log\LogLevel;
use Throwable;
use Simflex\Core\System\Container;
use Simflex\Core\System\DI\Injector;
use Simflex\Core\Logger\Log;

/**
 * Запуск консольных команд: ./sf provider/method [аргументы], ./sf help provider/method - справка.
 * Провайдеры - классы-наследники ConsoleBase, объявленные ядром, расширениями и provider/commands.php сайта
 * (ConfigBase::getCommands()), команды - их методы с атрибутом Command.
 * run() возвращает код завершения процесса: FAILURE при неверной команде, без обязательного аргумента или при
 * исключении в команде (сообщение - в лог и в stderr)
 */
class Cli
{
    /** Код завершения: команда выполнена или выведена справка */
    public const SUCCESS = 0;
    /** Код завершения: неверная команда, нет аргумента или исключение в команде */
    public const FAILURE = 1;

    /**
     * @var array|mixed Список всех доступных провайдеров
     */
    protected array $providers;

    /**
     * @var string|mixed Провайдер, введенный пользователем
     */
    public string $provider;

    /**
     * @var string|mixed Команда (метод), введенная пользователем
     */
    public string $command;

    /**
     * @var ReflectionClass Загруженный класс
     */
    protected ReflectionClass $class;

    /**
     * @var ReflectionMethod Загруженный метод
     */
    protected ReflectionMethod $method;

    /**
     * @var Help Атрибут метода
     */
    protected Help $methodHelp;

    /**
     * Разбирает аргументы командной строки и выполняет команду или выводит справку
     * @return int Код завершения процесса: SUCCESS или FAILURE
     */
    public static function run(CliRequest $request): int
    {
        $isHelp = strtolower((string)$request->arg(0)) === 'help';

        // без команды - список провайдеров
        if (!$request->arg() || ($isHelp && $request->arg(1) === null)) {
            Log::notice('Usage: ./sf provider/method [args], ./sf help provider/method. Providers:');
            (new static(['', '']))->printProviders();
            return self::SUCCESS;
        }

        $cmd = array_map(strtolower(...), explode('/', (string)$request->arg($isHelp ? 1 : 0)));

        // только провайдер - список его команд
        if (count($cmd) === 1) {
            $cli = new static([$cmd[0], '']);
            if ($cli->hasProvider() && $cli->tryLoadClass()) {
                Log::notice('Commands of {provider}:', ['provider' => $cli->provider]);
                $cli->printMethods();
                return self::SUCCESS;
            }
        }

        if (count($cmd) !== 2) {
            static::reportError('Usage: ./sf provider/method [args]');
            return self::FAILURE;
        }

        $cli = new static($cmd);

        if (!$cli->hasProvider()) {
            static::reportError('Command provider {provider} not found. Available providers:', [
                'provider' => $cli->provider,
            ]);
            $cli->printProviders();
            return self::FAILURE;
        }

        if (!$cli->tryLoadClass()) {
            static::reportError('Provider {provider}\'s class does not exist', ['provider' => $cli->provider]);
            return self::FAILURE;
        }

        if (!$cli->tryLoadMethod()) {
            static::reportError(
                'Method {method} not found in {provider}. Available methods:',
                ['method' => $cli->command, 'provider' => $cli->provider]
            );
            $cli->printMethods();
            return self::FAILURE;
        }

        if ($isHelp) {
            $cli->printHelp();
            return self::SUCCESS;
        }

        return $cli->execute(array_slice($request->arg(), 1));
    }

    /**
     * @param array{0: string, 1: string} $cmd Команда
     */
    public function __construct(array $cmd)
    {
        $this->providers = Container::getConfig()->getCommands();

        $this->provider = $cmd[0];
        $this->command = $cmd[1];
    }

    /**
     * @return bool true, если провайдер найден
     */
    public function hasProvider(): bool
    {
        return in_array($this->provider, array_keys($this->providers));
    }

    /**
     * Пытается загрузить класс
     * @return bool true, если загружен
     */
    public function tryLoadClass(): bool
    {
        try {
            $this->class = new ReflectionClass($this->providers[$this->provider] ?? '');
            return $this->class->isSubclassOf(ConsoleBase::class);
        } catch (ReflectionException) {
            return false;
        }
    }

    /**
     * Пытается загрузить метод
     * @return bool true, если загружен
     */
    public function tryLoadMethod(): bool
    {
        try {
            $this->method = $this->class->getMethod($this->command);
            if (!($attrib = $this->getAttribute($this->method, Command::class))) {
                return false;
            }

            $this->methodHelp = $attrib;
            return true;
        } catch (ReflectionException) {
            return false;
        }
    }

    /**
     * Выполняет команду. Исключение команды не выходит наружу: оно пишется в лог и в stderr, а процесс
     * завершается с кодом FAILURE
     * @param array $args Список аргументов
     * @return int Код завершения процесса: SUCCESS или FAILURE
     */
    public function execute(array $args): int
    {
        try {
            // готовим класс
            $ctor = $this->class->getConstructor();
            $instance = $this->class->newInstance(...($ctor ? Injector::resolve($ctor) : []));

            // находим метод
            $argList = [];
            $lastIdx = 0;
            foreach ($this->method->getParameters() as $param) {
                $lowerName = strtolower($param->getName());

                try {
                    $default = $param->getDefaultValue();
                } catch (Exception) {
                }

                if (isset($args[$lowerName])) {
                    $argList[] = $args[$lowerName];
                } elseif (isset($args[$lastIdx])) {
                    $argList[] = $args[$lastIdx++];
                } elseif (isset($default)) {
                    $argList[] = $default;
                } else {
                    static::reportError('No argument provided for parameter "{param}"', ['param' => $param->getName()]);
                    return self::FAILURE;
                }
            }

            // вызываем метод
            $this->method->invoke($instance, ...$argList);
        } catch (Throwable $ex) {
            static::reportError(
                'Unable to execute. Error: {error}',
                ['error' => $ex->getMessage()],
                LogLevel::EMERGENCY
            );
            return self::FAILURE;
        }

        return self::SUCCESS;
    }

    /**
     * Сообщает об ошибке: в лог, как раньше, и в stderr - сообщение видно и без логирования (оно включается
     * только devMode или enableLogging), а вызывающий процесс (cron, CI) получает его отдельно от вывода команды
     * @param string $message Сообщение с подстановками {ключ}
     * @param array<string, mixed> $context Значения подстановок
     * @param string $level Уровень лога, LogLevel::*
     */
    protected static function reportError(string $message, array $context = [], string $level = LogLevel::ERROR): void
    {
        Log::log($level, $message, $context);
        $replace = [];
        foreach ($context as $key => $value) {
            $replace['{' . $key . '}'] = (string)$value;
        }
        static::writeStderr(strtr($message, $replace));
    }

    /**
     * Пишет строку в stderr процесса
     */
    protected static function writeStderr(string $line): void
    {
        fwrite(STDERR, $line . PHP_EOL);
    }

    /**
     * Возвращает атрибут команды элемента, если он есть
     * @param ReflectionMethod|ReflectionParameter $item элемент
     * @param string $class класс атрибута
     * @return Help|null объект или null
     */
    protected function getAttribute(ReflectionMethod|ReflectionParameter $item, string $class): ?Help
    {
        $attribs = $item->getAttributes($class);
        if (!$attribs) {
            return null;
        }

        return $attribs[0]->newInstance();
    }

    /**
     * Выводит в лог все доступные провайдеры
     */
    public function printProviders(): void
    {
        foreach (array_keys($this->providers) as $key) {
            Log::notice("\t- {key}", ['key' => $key]);
        }
    }

    /**
     * Выводит в лог все доступные методы
     */
    public function printMethods(): void
    {
        foreach ($this->class->getMethods() as $method) {
            if (!($attrib = $this->getAttribute($method, Command::class))) {
                continue;
            }

            Log::notice("\t- {name} - {help}", ['name' => $method->getName(), 'help' => $attrib->help]);
        }
    }

    /**
     * Выводит в лог справку по текущему методу
     */
    public function printHelp(): void
    {
        $params = $this->method->getParameters();
        $cmdLine = implode(
            ' ',
            array_map(fn(ReflectionParameter $param) => $this->formatParameterName($param), $params)
        );

        Log::notice(
            '{provider}/{method} {cmdLine}',
            ['provider' => $this->provider, 'method' => $this->command, 'cmdLine' => $cmdLine]
        );

        Log::notice('- {help}', ['help' => $this->methodHelp->help]);
        if (!$params) {
            return;
        }

        $idx = 0;
        Log::notice('- Arguments:');
        foreach ($params as $param) {
            $help = $this->getAttribute($param, Help::class);
            Log::notice(
                "\t- {name} - {help}",
                [
                    'name' => $this->formatParameterName($param, $idx++),
                    'help' => $help ? $help->help : 'No help provided.',
                ]
            );
        }
    }

    /**
     * Форматирует имя параметра
     * @param ReflectionParameter $param Параметр
     * @return string Отформатированное имя
     */
    protected function formatParameterName(ReflectionParameter $param, ?int $idx = null): string
    {
        $out = '';

        try {
            $default = $param->getDefaultValue();
        } catch (ReflectionException) {
        }

        if (isset($default)) {
            $out .= '[';
        }

        if (!is_null($idx)) {
            $out .= $idx . '/';
        }

        $out .= $param->getName();
        if (isset($default)) {
            $out .= '=' . $default . ']';
        }

        return $out;
    }
}

<?php

namespace Simflex\Core\System\DI;

use ReflectionException;
use ReflectionFunctionAbstract;
use Simflex\Core\System\Container;

class Injector
{
    /**
     * Подбирает зависимости для конструктора класса
     *
     * @param object|string $target Имя класса
     * @param mixed ...$params Дополнительные параметры
     * @return array Найденные зависимости
     * @throws DIException Если у параметра нет типа, тип встроенный или обнаружена циклическая зависимость
     * @throws ReflectionException
     */
    public static function resolveClass(object|string $target, ...$params): array
    {
        $ref = new \ReflectionClass($target);

        // получаем конструктор
        $ct = $ref->getConstructor();
        if (!$ct) {
            return [];
        }

        return static::resolve($ct, ...$params);
    }

    /**
     * Подбирает зависимости для метода класса
     *
     * @param object|string $target Имя класса
     * @param string $method Имя метода
     * @param mixed ...$params Дополнительные параметры
     * @return array Найденные зависимости
     * @throws DIException Если у параметра нет типа, тип встроенный или обнаружена циклическая зависимость
     * @throws ReflectionException
     */
    public static function resolveMethod(object|string $target, string $method, ...$params): array
    {
        $ref = new \ReflectionClass($target);
        $md = $ref->getMethod($method);

        return static::resolve($md, ...$params);
    }

    /**
     * Подбирает зависимости для функции
     *
     * Аргументы возвращаются по именам параметров (для `...$args` при вызове). Параметр со значением
     * по умолчанию, который нельзя подставить (без типа, встроенный тип, класс не сервис или сервиса
     * нет в контейнере), пропускается — при вызове действует его значение по умолчанию.
     *
     * @param ReflectionFunctionAbstract $fn Функция
     * @param mixed ...$params Дополнительные параметры
     * @return array<string, mixed> Найденные зависимости по именам параметров
     * @throws DIException Если параметр без значения по умолчанию нельзя подставить
     *                     или обнаружена циклическая зависимость
     * @throws ReflectionException
     */
    public static function resolve(ReflectionFunctionAbstract $fn, ...$params): array
    {
        $target = $fn->getName();

        $added = [];
        $args = [];

        foreach ($fn->getParameters() as $parameter) {
            $name = $parameter->getName();
            $isOptional = $parameter->isDefaultValueAvailable();
            $type = $parameter->getType();

            // для параметров без типа или со встроенным/составным типом подбирать нечего
            if (!$type instanceof \ReflectionNamedType || $type->isBuiltin()) {
                if ($isOptional) {
                    continue;
                }
                throw new DIException(!$type
                    ? "Parameter {$name} in {$target} has no type"
                    : "Parameter {$name} in {$target} is a built-in type");
            }

            $className = $type->getName();

            // защита от циклических зависимостей
            if (in_array($className, $added)) {
                throw new DIException("Circular dependency detected in {$target}");
            }

            // проверяем, есть ли нужный класс среди параметров
            foreach ($params as $p) {
                if ($p instanceof $className) {
                    $args[$name] = $p;
                    $added[] = $className;
                    continue 2;
                }
            }

            // ищем класс в контейнере
            $classRef = new \ReflectionClass($className);
            if (!$classRef->implementsInterface(\Simflex\Core\System\DI\Service::class)) {
                if ($isOptional) {
                    continue;
                }
                throw new DIException("Class {$className} does not implement Service interface");
            }

            /** @noinspection PhpUndefinedMethodInspection */
            $serviceName = $className::getServiceName();
            if (!Container::get($serviceName)) {
                if ($isOptional) {
                    continue;
                }
                throw new DIException("Service {$serviceName} not found in container");
            }

            $added[] = $className;
            $args[$name] = Container::get($serviceName);
        }

        return $args;
    }
}

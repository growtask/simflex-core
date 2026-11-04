<?php

namespace Simflex\Core\Layout;

use Simflex\Core\System\Location;
use ScssPhp\ScssPhp\Compiler;
use ScssPhp\ScssPhp\Exception\SassException;
use Simflex\Core\Http\Assets;
use Simflex\Core\System\Container;
use Simflex\Core\Http\PageAssets;
use Simflex\Core\Debug\Profiler;
use tubalmartin\CssMin\Minifier;

/**
 * Менеджер макетов: собирает стили и скрипты компонентов Layout, отрисованных на странице.
 *
 * Глобальные стили - assetsGlobal ядра; сайт переопределяет их в Layout/assetsGlobal: одноимённый файл сайта
 * (например, styles/tokens/_variables.scss) импортируется вместо файла ядра, style.scss сайта заменяет корневой
 * style.scss ядра, script.js сайта подключается после script.js ядра. components.scss глобальной директории
 * подключается после стилей компонентов (переопределяет их).
 *
 * В админке (Location::Admin) корневой стиль - Admin/theme/styles/style.scss ядра (свои функции размеров: px на
 * десктопе), переопределения сайта не подключаются, стили собираются в отдельный кеш cache/css/admin*.css.
 */
class LayoutManager
{
    /**
     * @var LayoutBase[] Все используемые макеты
     */
    protected static array $usedLayouts = [];

    /**
     * @var array Все используемые стили
     */
    protected static array $usedStyles = [];

    /**
     * @var array Все используемые скрипты
     */
    public static array $usedScripts = [];

    /**
     * @var bool Если true, отрисованные макеты собирают поля своих схем, см. ./sf layout/generate
     */
    public static bool $shouldGenerateFields = false;

    /**
     * @var array<string, list<array{name: string, label: string, class: string, default: string, params: array}>>
     *      Поля, собранные из схем макетов: название блока => поля
     */
    public static array $generatedFields = [];

    /**
     * Подключает макет
     * @param string $class Класс макета
     */
    public static function useLayout(string $class): void
    {
        static::$usedLayouts[$class] = $class;
    }

    /**
     * Подключает стиль
     * @param string $path Путь к css/scss
     */
    public static function useStyle(string $path): void
    {
        static::$usedStyles[] = $path;
    }

    /**
     * Подключает JS-скрипт
     * @param string $path Путь к js
     */
    public static function useScript(string $path): void
    {
        static::$usedScripts[] = $path;
    }

    /**
     * Инициализирует систему макетов
     * @return string Путь к сгенерированному CSS-файлу
     * @throws SassException
     */
    public static function init(): string
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        foreach (static::globalDirs() as $dir) {
            if (is_file($dir . '/script.js')) {
                PageAssets::js(Assets::publish($dir . '/script.js'));
            }
        }
        foreach (static::$usedLayouts as $class) {
            $class::initAssets();
        }

        static::$usedStyles = array_unique(static::$usedStyles);
        $config = Container::getConfig();

        // путь к кэшу: у админки свой, стили сайта и админки не смешиваются
        $cachePrefix = Container::getLocation() === Location::Admin ? 'admin-' : '';
        if (!$config->devMode) {
            $cachePath = '';
            foreach (static::$usedStyles as $style) {
                $cachePath .= md5($style);
            }

            $cachePath = '/cache/css/' . $cachePrefix . md5($cachePath) . '.css';
        } else {
            $cachePath = '/cache/css/' . ($cachePrefix ? 'admin' : 'style') . '.css';
        }

        // файлы сайта находятся раньше файлов ядра
        $imports = array_reverse(static::globalDirs());

        // проверяем, есть ли файл кэша.
        $compiler = new Compiler();
        if ($config->devMode || !is_file(Container::getPaths()->getPublic() . $cachePath)) {
            // неявно добавляем корневой стиль.
            $implicit = '';
            foreach ($imports as $dir) {
                if (is_file($dir . '/style.scss')) {
                    $implicit = file_get_contents($dir . '/style.scss');
                    break;
                }
            }

            // кэшируем стили.
            $styleString = '';

            $compileString = '';
            if ($implicit) {
                $compileString .= $implicit;
            }

            foreach (static::$usedStyles as $style) {
                if (!is_file($style)) {
                    continue;
                }

                $cssData = file_get_contents($style);
                if (str_ends_with($style, '.scss')) {
                    $imports[] = dirname($style);
                    $compileString .= $cssData;
                } else {
                    $styleString .= $cssData;
                }
            }

            // components.scss глобальной директории — после стилей компонентов: локальные компоненты (например,
            // каркас админки) переопределяют компоненты Layout, которые в них выведены
            foreach (static::globalDirs() as $dir) {
                if (is_file($dir . '/components.scss')) {
                    $imports[] = $dir;
                    $compileString .= file_get_contents($dir . '/components.scss');
                }
            }

            // компилируем то, что нужно
            $compiler->setImportPaths($imports);
            $compileString = $compiler->compileString($compileString)->getCss();
            $styleString = $compileString . $styleString;

            // минифицируем итоговый css.
            if (!$config->devMode) {
                $min = new Minifier();
                $styleString = $min->run($styleString);
            }

            // записываем новый стиль.
            if (!is_dir(dirname(Container::getPaths()->getPublic() . $cachePath))) {
                mkdir(dirname(Container::getPaths()->getPublic() . $cachePath), 0777, true);
            }
            file_put_contents(Container::getPaths()->getPublic() . $cachePath, $styleString);
        }

        // используем стиль из кэша.
        PageAssets::css($cachePath . ($config->devMode ? ('?v=' . md5(microtime())) : ''));
        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $cachePath;
    }

    /**
     * @return list<string> Директории глобальных стилей и скриптов: ядра и, если есть, сайта; в админке - ядра
     *                      и стилей админки ядра
     */
    protected static function globalDirs(): array
    {
        $dirs = [__DIR__ . '/assetsGlobal'];
        if (Container::getLocation() === Location::Admin) {
            $dirs[] = dirname(__DIR__) . '/Admin/theme/styles';
            return $dirs;
        }
        if (is_dir(Container::getPaths()->getRoot('Layout/assetsGlobal'))) {
            $dirs[] = Container::getPaths()->getRoot('Layout/assetsGlobal');
        }

        return $dirs;
    }
}

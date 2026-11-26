<?php

namespace Simflex\Core\Layout\Components\Parts\Placeholder\PlaceholderImg;

use Simflex\Core\Layout\LayoutBase;
use Simflex\Core\System\Container;

/**
 * Картинка сайта: через этот компонент выводятся все изображения компонентов и страниц. Проверяет, что файл есть
 * (локальный путь - в public/), и если его нет, выводит заглушку темы или ничего (`missing`). Для телефона можно
 * задать свою картинку (`srcMobile`), ленивая загрузка включена по умолчанию, размеры `width` и `height` убирают
 * сдвиг вёрстки
 */
class Layout extends LayoutBase
{
    /** Расширения файлов, которые считаются картинками */
    public const EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'avif', 'svg', 'ico', 'bmp'];

    /** Прозрачный пиксель вместо заглушки, пока отложенная картинка не показана */
    private const BLANK = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

    /**
     * @param string $className Классы корня `picture` (у корня `display: contents`, оформлять лучше `imgClass`)
     * @param string $src Картинка для широких экранов: путь от корня сайта (`/uf/a.jpg`), адрес `http(s)://` или `data:`
     * @param array<string,mixed> $srcAttrs Атрибуты `source` для широких экранов
     * @param string $srcMobile Картинка для экранов не шире `size`; пусто - та же, что `src`
     * @param array<string,mixed> $srcMobileAttrs Атрибуты `source` для телефона
     * @param string $alt Описание картинки; у декоративной пусто
     * @param int $size Ширина экрана в px, до которой (включительно) показывается `srcMobile`
     * @param array<string,mixed> $attributes Атрибуты `img` (по умолчанию `loading="lazy"` и `decoding="async"`; первой
     *        картинке экрана передают `loading` = `eager` и `fetchpriority` = `high`)
     * @param bool $deferred Картинка в скрытом блоке: файл подставляет `sfPlaceholderImg.reveal()` при показе,
     *        до этого браузер ничего не качает
     * @param ImgMissing $missing Если нужного файла нет: заглушка или ничего
     * @param int $width Ширина картинки в px (атрибут `width`)
     * @param int $height Высота картинки в px (атрибут `height`)
     * @param string $imgClass Классы самого `img`
     * @param string $placeholder Своя заглушка вместо `images/placeholders/fallback-img.webp`: путь от корня сайта
     */
    public static function drawPlaceholderImg(
        string $className = '',
        string $src = '',
        array $srcAttrs = [],
        string $srcMobile = '',
        array $srcMobileAttrs = [],
        string $alt = '',
        int $size = 811,
        array $attributes = [],
        bool $deferred = false,
        ImgMissing $missing = ImgMissing::Placeholder,
        int $width = 0,
        int $height = 0,
        string $imgClass = '',
        string $placeholder = ''
    ): string {
        $desktop = static::exists($src) ? $src : '';
        $mobile = static::exists($srcMobile) ? $srcMobile : '';
        // Одной картинки хватает на оба размера экрана
        $desktop = $desktop !== '' ? $desktop : $mobile;
        $mobile = $mobile !== '' ? $mobile : $desktop;

        $isMissing = $desktop === '';
        if ($isMissing) {
            if ($missing === ImgMissing::Hide) {
                return '';
            }
            if ($placeholder !== '') {
                $desktop = $mobile = $placeholder;
            } elseif (assetExists('images/placeholders/fallback-img.webp')) {
                $desktop = $mobile = asset('images/placeholders/fallback-img.webp');
            } else {
                return '';
            }
        }

        return static::draw([
            'className' => $className,
            'imgClass' => $imgClass,
            'desktop' => $desktop,
            'mobile' => $mobile,
            'srcAttrs' => $srcAttrs,
            'srcMobileAttrs' => $srcMobileAttrs,
            'alt' => $alt,
            'size' => $size,
            'attributes' => $attributes,
            'deferred' => $deferred && !$isMissing,
            'missing' => $isMissing,
            'width' => $width,
            'height' => $height,
            'blank' => self::BLANK,
        ]);
    }

    /**
     * Есть ли картинка: внешний адрес и `data:` считаются существующими, локальный путь проверяется в public/
     * по файлу и расширению (строка запроса `?v=` отбрасывается)
     */
    public static function exists(string $url): bool
    {
        $url = trim($url);
        if ($url === '') {
            return false;
        }
        if (preg_match('~^(https?:)?//~i', $url) === 1 || str_starts_with($url, 'data:image/')) {
            return true;
        }

        $path = rawurldecode((string)parse_url($url, PHP_URL_PATH));
        if ($path === '' || str_contains($path, '..')) {
            return false;
        }
        if (!in_array(strtolower(pathinfo($path, PATHINFO_EXTENSION)), self::EXTENSIONS, true)) {
            return false;
        }

        return is_file(Container::getPaths()->getPublic(ltrim($path, '/')));
    }
}

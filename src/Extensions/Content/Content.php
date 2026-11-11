<?php

namespace Simflex\Core\Extensions\Content;

use Simflex\Core\Http\ComponentBase;
use Simflex\Core\System\Container;
use Simflex\Core\Logger\Log;
use Simflex\Core\System\DI\Factory;
use Simflex\Core\Debug\Profiler;
use Simflex\Core\Extensions\Breadcrumbs\Breadcrumbs;
use Simflex\Core\DB\AQ;
use Simflex\Core\Extensions\Content\Models\Content as ModelContent;
use Simflex\Core\Http\PageSeo;

/**
 * Класс ComContent
 *
 * Вывод контента на странице сайта
 *
 */
class Content extends ComponentBase
{
    public function __construct(protected Factory $factory)
    {
    }

    public function get(string $path = ''): ?ModelContent
    {
        $path = $path ?: Container::getRequest()->getPath();
        if ($content = $this->factory->getStatic(ModelContent::class)::findOne(['path' => $path, 'active' => 1])) {
            $content['params'] = unserialize($content['params']);
        }

        // /404 — служебная страница, на которую перенаправляются несуществующие пути
        if (!$content && $path !== '/404') {
            Log::warning('active content with path {path} not found', ['path' => $path]);
        }

        return $content;
    }

    public static function getStatic(string $path = ''): ?ModelContent
    {
        $path = $path ?: Container::getRequest()->getPath();
        if ($content = Container::getFactory()->getStatic(ModelContent::class)::findOne(['active' => 1, 'path' => $path])) {
            $content['params'] = unserialize($content['params']);
        }

        return $content;
    }

    protected static function getTableFrom(string $param, $from): array
    {
        return json_decode($from['params'][$param] ?? '{"v":[]}', true)['v'] ?: [];
    }

    protected static function getChildrenById(int $id, int $except = 0, string $sort = 'title ASC'): array
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        $query = ModelContent::findAdv()->where([
            'pid' => $id,
            'active' => 1,
        ]);

        if ($except) {
            $query = $query->andWhere('content_id != ' . $except);
        }

        $children = $query->orderBy($sort)->all();
        foreach ($children as $child) {
            $child['params'] = unserialize($child['params']);
        }

        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $children;
    }

    protected static function getChildrenSorted(int $id, string $sort, int $except = 0): array
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        $children = ModelContent::findAdv()->where([
            'pid' => $id,
            'active' => 1,
        ]);

        if ($except) {
            $children = $children->andWhere('content_id != ' . $except);
        }

        $children = $children->all();

        foreach ($children as $child) {
            $child['params'] = unserialize($child['params']);
        }

        // сортировка по возрастанию, по параметру
        usort($children, function ($a, $b) use ($sort) {
            return $a['params'][$sort] > $b['params'][$sort] ? 1 : -1;
        });

        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $children;
    }

    protected static function getChildrenByPath(string $path): array
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        $children = ModelContent::findAdv()->where([
            'path' => $path,
            'active' => 1,
        ])->orderBy('title ASC')->all();

        foreach ($children as $child) {
            $child['params'] = unserialize($child['params']);
        }

        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $children;
    }

    protected static function getChildrenConditional(string $path, array $cond): array
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        $parent = ModelContent::findOne(['path' => $path, 'active' => 1])['content_id'];
        $res = ModelContent::findAdv()->where([
            'active' => 1,
            'pid' => $parent,
        ])->orderBy('date DESC')->all();

        $children = [];
        foreach ($res as $c) {
            $c['params'] = unserialize($c['params']);
            foreach ($cond as $k) {
                if (!($c['params'][$k] ?? false)) {
                    continue 2;
                }
            }

            $children[] = $c;
        }

        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $children;
    }

    /**
     * Активные дочерние страницы раздела, новые первыми
     * @param array $s Слова поиска по параметрам страницы: все должны встречаться
     * @param int $ignore Страница, которую не показывать при поиске
     */
    protected function getChildren(string $path, int $max = 10, array $s = [], int $ignore = 0): array
    {
        Profiler::traceStart(__CLASS__, __FUNCTION__);
        $children = [];
        if ($parent = ModelContent::findOne(['path' => $path, 'active' => 1])) {
            $query = ModelContent::findAdv()
                ->where(['active' => 1, 'pid' => $parent['content_id']])
                ->orderBy('date DESC')
                ->limit($max);
            $search = array_filter($s, fn($word) => trim((string)$word) !== '');
            foreach (array_values($search) as $i => $word) {
                $query->andWhere("params LIKE :search_$i")->bind(["search_$i" => '%' . $word . '%']);
            }
            if ($search && $ignore) {
                $query->andWhere('content_id <> :ignore')->bind(['ignore' => $ignore]);
            }

            foreach ($query->all() as $c) {
                $c['params'] = unserialize((string)$c['params']);
                $children[] = $c;
            }
        }

        Profiler::traceEnd(__CLASS__, __FUNCTION__);
        return $children;
    }

    protected function content(): string
    {
        Profiler::traceStart($this, __FUNCTION__);

        $content = $this->get();

        $link = Container::getRequest()->getPath();
        if ($content) {
            if (!Container::getRequest()->isAjax()) {
                $this->breadcrumbs($content);
            }

            $meta = $content['params'] ?? [];
            PageSeo::seo(
                ($meta['meta_title'] ?? '') ?: $content['title'],
                $meta['meta_de'] ?? '',
                $meta['meta_kw'] ?? '',
                exactTitle: ($meta['meta_title'] ?? '') !== '',
            );

            $children = [];
            $page = 0;
            $pages = 0;
            $hasPrev = false;
            $hasNext = false;
            if (empty($content['params']['hide_children'])) {
                $request = Container::getRequest();
                $query = new AQ()
                    ->asArray()
                    ->from('content')
                    ->select(['content_id', 'title', 'short', 'text', 'path', 'photo', 'date', 'params'])
                    ->where(['active' => 1, 'pid' => (int)$content['content_id']]);
                // поиск по параметрам: ?search[]=слово, все слова
                foreach ((array)$request->get('search', []) as $i => $word) {
                    if (trim((string)$word) !== '') {
                        $query->andWhere("params LIKE :search_$i")->bind(["search_$i" => '%' . $word . '%']);
                    }
                }

                $cnt = (int)(clone $query)->select('COUNT(*)')->fetchScalar();

                // костыль: исправить.
                $pageCount = 15;
                $pages = $cnt / $pageCount;
                $page = (int)$request->get('page');

                $hasPrev = $page > 0;
                $hasNext = $page < $pages - 1;

                // мобильная версия (?mob) - все страницы до текущей
                $query->orderBy('date DESC')->limit($request->get('mob') !== null
                    ? (string)(($page + 1) * $pageCount)
                    : ($page * $pageCount) . ', ' . $pageCount);
                $children = [];
                foreach ($query->all() as $child) {
                    $child['params'] = unserialize((string)$child['params']);
                    $children[] = $child;
                }
            }

            $html = $this->render(static::findTemplateFile(ContentTemplates::file($content->template)), get_defined_vars());
        } else {
            if ($link === '/404') {
                Container::getResponse()->setStatusCode(404);
            } else {
                Profiler::traceEnd($this, __FUNCTION__);
                header('Location: /404');
                exit;
            }

            // загружаем главную здесь, чтобы избежать проблем с шаблонизатором
            $content = $this->get('/');
            $html = $this->render(self::findTemplateFile('base/404.tpl'), get_defined_vars());
        }

        Profiler::traceEnd($this, __FUNCTION__);
        return $html;
    }

    protected function breadcrumbs($content): void
    {
        Breadcrumbs::add($content['title'], $content['path']);
        $id = (int)$content['pid'];
        while ($id) {
            $content = new AQ()->asArray()->from('content')->select(['pid', 'title', 'path'])->where(['content_id' => $id])->fetchOne();
            $id = 0;
            if ($content) {
                Breadcrumbs::add($content['title'], $content['path']);
                $id = (int)$content['pid'];
            }
        }
    }

    protected static function findTemplateFile(string $name): string
    {
        if (is_file($path = Container::getPaths()->getRoot('Extensions/Content/tpl/' . $name))) {
            return $path;
        }
        if (is_file($path = __DIR__ . '/tpl/' . $name)) {
            return $path;
        }

        Log::warning('Content: target template {name} was not found, is this intentional?', ['name' => $name]);
        return __DIR__ . '/tpl/default.tpl';
    }
}

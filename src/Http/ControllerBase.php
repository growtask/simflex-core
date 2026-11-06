<?php

namespace Simflex\Core\Http;

use ReflectionClass;
use Simflex\Core\Http\Controller\Action;
use Simflex\Core\Http\Controller\ActionMatcher;

/**
 * Автоматический контроллер
 *
 * Действия объявляются в дочернем классе атрибутом Action.
 * Методы действий возвращают HTML строкой, а не выводят его
 * @see Action
 */
class ControllerBase extends ComponentBase
{
    /**
     * @var array|ActionMatcher[] Действия
     */
    protected array $actions = [];

    public function __construct(protected Request $request, protected Response $response)
    {
        $this->collectActions();
    }

    /**
     * Запасной метод, возвращает HTML, когда ни одно действие не подошло
     */
    protected function fallback(): string
    {
        // отдаем 404
        $this->response->redirectNow('/404');
    }

    /**
     * Собирает действия
     */
    protected function collectActions(): void
    {
        $class = new ReflectionClass($this);
        foreach ($class->getMethods() as $method) {
            $attribs = $method->getAttributes(Action::class);
            if (!$attribs) {
                continue;
            }

            /** @var Action $action */
            $action = $attribs[0]->newInstance();
            $this->actions[] = new ActionMatcher($action, $method->getName());
        }
    }

    /**
     * Пытается подобрать действие контроллера
     */
    protected function resolve(): ?ActionMatcher
    {
        foreach ($this->actions as $action) {
            if ($action->match()) {
                return $action;
            }
        }

        return null;
    }

    /**
     * Аргументы метода действия: переменные пути, затем параметры запроса (по имени параметра метода)
     *
     * @param array<string, string> $vars Переменные пути
     * @return array<int, mixed>
     */
    protected function resolveArguments(\ReflectionMethod $method, array $vars): array
    {
        $request = $this->request->request();

        $arguments = [];
        foreach ($method->getParameters() as $param) {
            if (isset($vars[$param->name])) {
                $arguments[] = $vars[$param->name];
                continue;
            }

            if (isset($request[$param->name])) {
                $arguments[] = $request[$param->name];
            }
        }

        return $arguments;
    }

    /**
     * Вызывает метод подобранного действия
     */
    protected function invokeAction(ActionMatcher $matcher): mixed
    {
        $method = new ReflectionClass($this)->getMethod($matcher->methodName);

        return $method->invoke($this, ...$this->resolveArguments($method, $matcher->getVars()));
    }

    protected function content(): string
    {
        $matcher = $this->resolve();
        if (!$matcher) {
            return $this->fallback();
        }

        // действия возвращают HTML
        return (string)$this->invokeAction($matcher);
    }
}

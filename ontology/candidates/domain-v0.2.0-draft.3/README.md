# Оператор добавляет Repository в Project

В пакете GitView `0.2.0-draft.3` термин `User` обозначает конкретного оператора приложения. Он объявлен в `classes` с базой `ont:DomainEntity`. В [предыдущем кандидате](../domain-v0.2.0-draft.2/README.md) то же имя использовалось как protocol. Основание для смысла термина — `conversation:gitview/excerpt-53-reply`. Просьба исправить именно проектный пакет сохранена в SpecDraft как `conversation:gitview/actor-pilot-package-correction`. Выбор представления и сценарий остаются черновыми.

```yaml
addsRepositoryTo:
  subject: User
  action: AddRepository
  object: Project
```

При составлении исполняемого отношения SDK требует от этого экземпляра `User` метод `run` для `AddRepository` над `Project`. Действие несёт обязательный `repositoryId`. В примере обработчик находит существующий Repository по этому ID. Решение об идентификаторах, авторизации, повторном добавлении и хранении принадлежит дальнейшей спецификации продукта. GitHub-авторы, reviewers и assignees сохраняют собственные роли.

| | До вызова | После одного `trigger` |
| --- | --- | --- |
| Project `p` | `r1` | `r1, r2` |
| Project `q` | `r2` | `r2` |

Оба проекта ссылаются на один объект `r2`. Чтение записи сохраняет исходное состояние. При неизвестном ID обработчик отклоняет изменение. Источник и закреплённый IR доступны для [основного](foundation-context.yaml) и [составного](composition-context.yaml) вариантов. Составной вариант сохраняет импорт motivation-core и ссылку `issueMotiveLink`. У обоих сохранены прежние правила идентичности Repository.

## Проверка

Стабильный компилятор GitView обновлён до релиза 0.6.0. Для действий используется отдельная сборка Ontology PR #97 на `b02810e9`, с foundation 0.2.0. При установке для macOS arm64 сверены SHA-256 артефактов и ревизии из BUILD.txt. [Сборка CI](https://github.com/0al-spec/Ontology/actions/runs/41686278784) · [Пины и результаты](verification.json).

В текущей рабочей копии пути к компиляторам заданы через локальные настройки Git `gitview.ontologyc` и `gitview.actorOntologyc`. В другой копии передайте `--stable-ontologyc /path/to/release/ontologyc` и `--ontologyc /path/to/candidate/ontologyc`. Нужны Python с PyYAML, Node.js и npm. Проверка устанавливает закреплённые зависимости и генерирует SDK во временном каталоге. На этом Mac задайте `TMPDIR` на проверенном TB5 по правилам рабочего пространства. Для заполненного npm cache доступен флаг `--offline`.

```sh
python3 ontology/candidates/domain-v0.2.0-draft.3/operator/verify.py
```

Проверка сопоставляет source/IR SHA-256, сравнивает заново сгенерированный IR с сохранёнными байтами, компилирует строгий TypeScript и исполняет пример для обоих пакетов. В отрицательном контроле возврат прежнего `protocols.User` даёт `relation.subject.unresolved`. Аналогичная проверка с релизом 0.6.0 на прежней форме связи даёт `relation.domain.unresolved`, а конкретный класс проходит.

Установленный SpecGraph `b1583e58` подтверждает действующий `ontology/context.yaml` с релизом 0.6.0. Для нового основного кандидата он возвращает `unavailable` из-за версии foundation, а для составного — `invalid` при чтении ожидаемого поля `domain`. Кандидат проверяется напрямую через `ontologyc` и SDK. Выбор его контекстом проекта требует поддержки новых объявлений в SpecGraph.

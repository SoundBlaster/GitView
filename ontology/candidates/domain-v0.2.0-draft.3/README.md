# Оператор добавляет Repository в Project

Составной вариант `0.2.0-draft-composition.3` выбран в
[`specgraph.project.yaml`](../../../specgraph.project.yaml) как рабочий контекст
для подготовки графа спецификаций (`conversation:gitview/excerpt-57-reply`).
Пакет сохраняет статус `draft`.

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

GitView использует релизный ontologyc 0.7.0 для выбранного контекста и для исполняемых отношений draft.3. Компилятор включает foundation 0.2.0. Для скачанного macOS arm64 архива проверены SHA-256 и commit из BUILD.txt. [Релиз](https://github.com/0al-spec/Ontology/releases/tag/0.7.0) · [Пин и результаты](verification.json).

В текущей рабочей копии обе настройки Git, `gitview.ontologyc` и `gitview.actorOntologyc`, указывают на один релизный бинарник. В свежем клоне передайте `--ontologyc /path/to/ontologyc --stable-ontologyc /path/to/ontologyc`. Нужны Python с PyYAML, Node.js и npm. На этом Mac задайте `TMPDIR` на проверенном TB5. При заполненном npm cache доступен флаг `--offline`.

```sh
python3 ontology/candidates/domain-v0.2.0-draft.3/operator/verify.py
```

Проверка сопоставляет source/IR SHA-256, сравнивает заново сгенерированный IR с сохранёнными байтами, компилирует строгий TypeScript и исполняет пример для обоих пакетов. В отрицательном контроле возврат прежнего `protocols.User` даёт `relation.subject.unresolved`. Аналогичная проверка с релизом 0.7.0 на прежней форме связи даёт `relation.domain.unresolved`, а конкретный класс проходит.

В историческом прогоне SpecGraph `b1583e58` подтвердил прежний `ontology/context.yaml` с релизом 0.7.0. Для варианта draft.3 на foundation он вернул `unavailable` из-за версии foundation, а для составного — `invalid` при чтении ожидаемого поля `domain`. Установленный `002eb069` с Ontology 0.7.0 и отдельный прогон `88126b61` с Ontology 0.9.1 подтвердили оба варианта (`verified`), а root draft — `checked`.

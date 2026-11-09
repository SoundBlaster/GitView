# GitHub регистрирует Repository

Кандидат `draft.4` выражает решение `conversation:gitview/excerpt-58-reply`.

```yaml
managesRepository:
  subject: GitHub
  action: RegisterRepository
  object: Repository
```

`RegisterRepository` наследует `ont:Action`. При регистрации GitHub начинает
управлять тем же Repository, который в этом контексте выступает в роли
`GitHubRepository`. При transfer внутри GitHub управление сохраняется, если
источник подтверждает тот же объект. Событие регистрации и его наблюдение
через API различаются. Источник события и условия прекращения управления
предстоит определить в спецификациях.

[Foundation](foundation-context.yaml) и [составной вариант](composition-context.yaml)
закрепляют исходники и сгенерированный IR. Оба прошли `ontologyc check` и
`compile` на Ontology 0.7.0, а SpecGraph `002eb069` вернул `verified` для
контекстов и `checked` для `GITVIEW-SPEC-0001`. Для составного варианта также
проверены импорты на Ontology 0.9.1 и проекция в инспекторе SpecSpace.
[Результаты проверки](verification.json) описывают структуру и отображение.
Составной вариант выбран рабочим контекстом в
[`specgraph.project.yaml`](../../../specgraph.project.yaml)
(`conversation:gitview/excerpt-59-reply`). Пакет сохраняет статус `draft`.

# Повторная сверка 0001 с рабочей онтологией

Авторская сверка, не semantic approval и не runtime evidence приложения.
Исходный [0001](../../docs/drafts/GITVIEW-SPEC-0001.yaml) имеет SHA-256
`5184876bb38ffff8901a02ac7fc0b54be7bad6c55234de7a484b9ac85c6b9b39`.
Выбрана [композиция draft.10](../candidates/domain-v0.2.0-draft.10/composition-context.yaml),
контекст `sha256:802242a9ca08f9aca0a49768a7de0c8ac9d618878c93bdde3ed79c0f333304d1`.
Её project package и импортированные motivation/events имеют draft-статус.

`ontology-doctor` с явно указанным compiler SHA-256
`30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`
проверил выбранный структурный context; compiler version и provenance не
установлены. Затем в изолированной копии на TB5 SpecGraph выполнил
`--build-project-ontology-context-check` с scope `domain_vocabulary` для
0001. Итог `checked` содержит **один gap и одно warning**, при
`passed_check_count: 0`. Отчёт и рабочая копия находятся в каталоге
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/gitview-root-ontology-review-sgy_v7tw`.
Это проверка символов и структурных привязок, а не проверка смысла,
кардинальностей на экземплярах, действий или поведения GitView.

## Содержание предупреждения

`ontology-gap-gitview-spec-0001-gitview` относится к термину `GitView` в
`specification.terminology`, классификация `legacy_unknown_term`; finding
`GITVIEW-SPEC-0001.gap.GitView` повторяет этот gap как `unknown_legacy_term`.
Здесь GitView — имя продукта и корень авторского представления. В исходном
0001 это уже оговорено; новое domain entity для названия продукта не следует
из пользовательского решения. Предупреждение оставлено видимым для review,
не объявлено исправленным и не перенесено на `motivcore:Motive`.

## Предметная сверка ограниченной области

| Понятие / связь | Что подтверждает source package | Граница |
| --- | --- | --- |
| User, Project, Repository, Code, VersionControlSystem, GitHub | Именованные draft classes; исходные определения отделяют Project membership от Project и формулируют Repository по предложению владельца. | `versionControlsCode` — domain/range candidate; исходное действие и возникающее свойство не установлены. |
| GitHubRepository | Protocol для того же Repository при управлении GitHub; `managesRepository` связывает GitHub, `RegisterRepository` и Repository. | Протокол или структурная декларация не доказывает конкретный акт регистрации или существование связи на объекте. |
| AddRepository / RemoveRepository | User действует над Project с типизированной ссылкой на Repository; отдельный membership link допускает участие Repository в разных Projects. | Структура не доказывает существование referenced instance или конкретного актора исторического изменения. |
| Issue, PullRequest, ReviewThread, CIStatus, Metric | Именованные draft concepts и выбранные partial fields; source relationships не приписывают мотив автоматически. | Поведение и семантика выбранных счётчиков требуют соответствующих specs и source evidence; `participantCount` не отождествляется автоматически с авторским proxy из 0077. |
| `motivcore:Motive` | Квалифицированный импорт разрешается в составе выбранного context. | Текст Motivation и ссылка Issue → PR не доказывают мотив или причинность конкретного актора. |

Найдена неоднозначность внутри draft.10: protocol `GitHubRepository` говорит,
что concrete source identity key остаётся на review, а manual policy
`RepositoryIdentityContinuity` уже фиксирует числовой REST ID в пределах одного
GitHub instance. В [0002](../../docs/drafts/GITVIEW-SPEC-0002.yaml) и
истории [identity-решения](repository-identity.md) это более позднее решение
уже отражено. Не следует редактировать сохранённый pinned package без новой
версии и повторного создания IR: следующим ограниченным шагом нужен отдельный
candidate, устраняющий устаревшую формулировку и сохраняющий открытыми именно
encoding, cross-instance и source evidence. Он не должен изменять саму identity
или делать протокол глобальной реализацией Repository.

Предыдущая более широкая [сверка](specification-alignment-20261114.md) по 96
входам остаётся историческим срезом. Данный повтор охватывает актуальный 0001,
а не заново все 123 спецификации.

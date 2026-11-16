# Repository identity: различие статуса source mapping

При восстановлении ontology refs обнаружено расхождение. Ниже сохранены исходное наблюдение и результат его сверки 16 ноября.

- В принятом `local.gitview.domain@0.2.0` protocol `GitHubRepository` и policy `RepositoryIdentityContinuity` формулируют numeric GitHub REST repository ID как выбранный ключ сравнения в пределах GitHub instance.
- До этой сверки `GITVIEW-SPEC-0002` и `GITVIEW-SPEC-0038` сохраняли более узкую границу: владелец одобрил примеры одинаковых/разных numeric ID для одного GitHub; сопоставление с конкретным REST identifier оставалось кандидатом, требующим проверки источника.

## Происхождение решений

В SpecDraft `repository-identity-options` и `repository-identity-continuity` владелец выбрал сохранение одного Repository при подтверждённой источником идентичности через rename и transfer. Позднее агент предложил таблицу с одинаковым `id = 42`, другим `id = 99` и HTTP 404; владелец согласился с предложенными правилами (`repository-rest-id-proposal` и `repository-rest-id-decision`, `conversation:gitview/excerpt-60-proposal` / `excerpt-60-reply`). Точная таблица не называет REST; указание REST в `detail` заметки — агентская интерпретация, не дословная формулировка владельца.

Затем владелец отдельно утвердил содержимое выбранного ontology package: [решение и SHA](owner-acceptance-20261116.md). В этом принятом содержимом numeric REST repository ID уже выбран как ключ сравнения внутри одного GitHub instance. Следовательно, конкретный mapping выбран **через последующее принятие package**, а не отдельным прямым выбором REST в ранней таблице. Исторический draft.13 и утверждённый package 0.2.0 не переписываются.

## Основания GitHub и пределы

- [GitHub Blog о repo-jacking](https://github.blog/security/supply-chain-security/how-to-stay-safe-from-repo-jacking/) описывает целочисленный repository ID как уникальный, не меняющийся при rename, и отличающий новый Repository от заменённого.
- [GitHub Docs о transfer](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository) описывает перенос Repository и связанных данных, но приведённая страница не устанавливает явно неизменность numeric ID при transfer. Фактический transfer и API response нами не проверялись; подтверждённое источником тождество остаётся условием сценария.
- [GitHub Docs о миграции GraphQL global node IDs](https://docs.github.com/en/graphql/guides/migrating-graphql-global-node-ids) описывает смену формата global ID. Нельзя отождествлять его строковое представление с REST numeric ID или выводить новую предметную идентичность только из изменения его формата.

Действующие 0002 и 0038 приведены к выбранной policy: при подтверждённых сопоставимых numeric REST IDs в одном instance одинаковый ID относится к одному Repository, другой — к другому. Доступность нужного ID в конкретном source path, корректное сопоставление видов ID, evidence при transfer и обработка конфликтующих/неполных наблюдений остаются открытыми. ID не устанавливает текущий адрес или реальность конкретного transfer. Сохранение history и Projects действует при подтверждённом том же объекте; 404 сам по себе не доказывает удаление или отзыв доступа. Никакой live-проверки, storage scheme или cross-instance policy не утверждается.

Независимые reviewers `review_refs_root` и `review_refs_projects` выявили расхождение в 0002 и 0038. Текущая сверка изменяет спецификации, но не semantic content утверждённого package и не доказывает конкретное действие актора.

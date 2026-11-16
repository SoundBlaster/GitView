# Repository identity: различие статуса source mapping

В ходе восстановления ontology refs обнаружено ранее существовавшее расхождение, которое эта работа не разрешает автоматически.

- В принятом `local.gitview.domain@0.2.0` protocol `GitHubRepository` и policy `RepositoryIdentityContinuity` формулируют numeric GitHub REST repository ID как выбранный ключ сравнения в пределах GitHub instance.
- Действующие `GITVIEW-SPEC-0002` и `GITVIEW-SPEC-0038` сохраняют более узкую границу: владелец одобрил примеры одинаковых/разных numeric ID для одного GitHub; сопоставление с конкретным REST identifier требует проверки источника.

Обе формулировки важно сверить с точной записью пользовательского решения и source evidence. Ссылка на protocol не становится доказательством API-сопоставления, регистрации конкретного Repository или факта действия. До разрешения не следует усиливать требования спецификаций или считать расхождение автоматически исправленным approval пакета. Независимые reviewers `review_refs_root` и `review_refs_projects` указали это в проверках 0002 и 0038; данная запись не меняет ни package, ни поведение приложения.

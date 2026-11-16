# Default Project: сверка с принятой онтологией

Основание: владелец выбрал один Project на Repository по умолчанию и одновременно разрешил несколько Repository в Project и один Repository в нескольких Projects. В `ProjectMembershipScope` принятой `local.gitview.domain@0.2.0` сформулированы те же границы; разница между членством и действием сохраняется.

После предыдущего исправления 0045 верхнеуровневые 0001/0005 и lifecycle/setup узлы 0022/0025/0045 ещё содержали двусмысленные сокращения `one-Repository default` / `default Project corresponds to one Repository`. В контексте их можно было прочитать как постоянное ограничение состава Project. Исправлены направление default и acceptance wording; при этом multi-repository состав и shared membership допустимы, multi-selection остаётся условным, а persistent default association, reuse и storage mechanism не выбираются.

| Узел | Проверенный SHA-256 | Независимый read-only reviewer |
| --- | --- | --- |
| 0001 | `c25d717ddb120020ff31891140435a78dc710eeaf55c3148a6b1d1a3d79ffaaa` | `/root/review_default_root_ontology` |
| 0005 | `27e5b4a26dbdd81cc729353eede36078115a37b534a53dd968fed12d69187e7f` | `/root/review_default_root_ontology` |
| 0022 | `09ecd8148910830d25b84d5631e0fea07baf90d511b7d68ae8dfcc6f673fcff7` | `/root/review_default_lifecycle_ontology` |
| 0025 | `a6408c1a0baaa8cdf042bb5dc399fd190881b9f4cf68535485a2ed3031b6de0f` | `/root/review_default_lifecycle_ontology` |
| 0045 | `790d68db74ed22a8f2b075fdcd26b27d7aef0d28ff70e276de6763fe7c5309c9` | `/root/review_default_lifecycle_ontology` |

Review сравнивал HEAD, package и выбранное владельцем правило. Первичный review указал на остаточную неоднозначность в 0022/0025/0045; исправленные SHA повторно проверены без замечаний. Инвариант одного или нескольких членов применяется к сохранённому Project и не устанавливает обязательный внутренний промежуточный state при редактировании.

Installed runtime 3a7f176a: `lint` для пяти узлов passed, `next-move --candidate-file` для каждого checked. В изолированной копии на TB5 `domain_vocabulary` checked для пяти узлов, соответственно 11/9/5/9/6 bindings и 0 gaps. Отчёты: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology-default-scope-final-3fxfgvux/`. Structural checks не доказывают поведение приложения, полноту source evidence или implementation readiness; выборка и review ограничены default/composition.

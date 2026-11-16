# Восстановление ontology references: review и результаты

**Исторический снимок:** таблица и проверки ниже относятся к результату восстановления в коммите `424344e`. Более поздние содержательные сверки могут изменять отдельные узлы и их SHA; их review записывается отдельно.

База: GitView `6d725ef`. Цель — восстановить явные используемые понятия и отношения в действующих узлах по их текущему scope и принятому `local.gitview.domain@0.2.0`; не переносить механически полный словарь черновиков. Тексты product requirements, scenarios и acceptance не менялись; корректировались ontology context/status и refs. Прежние draft contexts остаются в исторических документах. `sources.ontology_context`, если он указан в действующем узле как рабочий, обновлён на выбранный 0.2.0; остальные узлы используют `specgraph.project.yaml`.

## Независимая сверка

Read-only reviewers указаны построчно. Им были переданы цели, точные SHA и необходимость сверить узел с HEAD, predecessor и утверждённым package. Для замечаний, приведших к дополнению или исключению refs, выполнен focused rereview обновлённого SHA; таблица содержит финальные проверенные файлы. Примеры исправлений: актуальный context и membership в 0006; направленные Issue relations в 0009 и 0078; Metric и source relations в 0012, 0013, 0028–0030, 0046–0047 и 0056; исключение слишком узкого CIStatus из общего CI input в 0040. Review не доказывает отсутствия всех возможных смысловых пробелов или реализации.

| Узел | SHA-256 | Независимый reviewer | Structural bindings | Gaps |
| --- | --- | --- | ---: | ---: |
| GITVIEW-SPEC-0001 | `95cd41843c9dd98057c9a88209694b260f10610037800a3cd6a29ba3260636be` | `review_refs_root` | 11 | 0 |
| GITVIEW-SPEC-0002 | `9d895c14ffe684e8ff9ef0d2b317f46d727eb372f3527911ad027dd15f362b43` | `review_refs_root` | 5 | 0 |
| GITVIEW-SPEC-0003 | `95a364d4813ab40f163e748ea8da69718c721399edcfe6a2ad2d0ee78782dbd0` | `review_refs_root` | 4 | 0 |
| GITVIEW-SPEC-0004 | `0a483209fd5099c8c00c99a1e0506a566be4df2b1cd358c6f5cd5636511e2176` | `review_refs_projects` | 3 | 0 |
| GITVIEW-SPEC-0005 | `c0b1a7ec520edf57b45db6933cec1c0ba8975419332ee99114ab3e9b255c987c` | `review_refs_projects` | 9 | 0 |
| GITVIEW-SPEC-0006 | `cb11e473afd91d72a321a067a08b7fa8ce656fed3fb644d6fa89fddf0404d250` | `review_refs_root` | 5 | 0 |
| GITVIEW-SPEC-0007 | `5c6e5717d5d37b5d04e69bb95596ed74e9d818e126c015b1a502a755809a4b57` | `review_refs_root` | 4 | 0 |
| GITVIEW-SPEC-0008 | `be8c5e8f60ccc5f7abbde334dcbcba2e95a118c4d65d9fdfcfe55a97dbf8bb23` | `review_refs_projects` | 7 | 0 |
| GITVIEW-SPEC-0009 | `4adaa93b30564ab738dd4dc11cd030fdcb093b59087f16838c96eae9769cc5d0` | `review_refs_projects` | 10 | 0 |
| GITVIEW-SPEC-0010 | `2a83938ccd789c20be2b1abf697c27ddc7e8a86513b8478809c94f4ac1d1db76` | `review_refs_projects` | 2 | 0 |
| GITVIEW-SPEC-0011 | `7c38731a083508b984ed05a82cb9860f20a5889345069019c66a60a358850914` | `review_refs_signals` | 4 | 0 |
| GITVIEW-SPEC-0012 | `9d51fe4028009c45bce4fe085eddbd65f3b4e4e72d8efc8bfa09e7a53fd5553d` | `review_refs_signals` | 11 | 0 |
| GITVIEW-SPEC-0013 | `4a56170896c6be7c8b98dd2c409f59bda32bb62986c66df3235d89e7bf624211` | `review_refs_signals` | 9 | 0 |
| GITVIEW-SPEC-0014 | `480f737a78c1f19acc9c650d716de6b6a8489d44ecaf6e7c89c23733ae6a6655` | `review_refs_preview` | 4 | 0 |
| GITVIEW-SPEC-0015 | `f4d35e76286f4ba11bbfeba878d1414e57abf70ac922fac347d855e69ed8447c` | `review_refs_preview` | 4 | 0 |
| GITVIEW-SPEC-0016 | `fcab5f6fb69a0b95bc62b8dbde0d2622618c8cbcdf6a8fde39bb036199b4ed09` | `review_refs_access` | 4 | 0 |
| GITVIEW-SPEC-0017 | `9f73e61b58984f9c60ee74deff32c5c8185a810486db5a4b8c2758cef5a0d9bd` | `review_refs_access` | 5 | 0 |
| GITVIEW-SPEC-0018 | `8e5a9072dd638b8e14f58caa0edbb011e252ac24cea5a7be3c203b915bb6b52c` | `review_refs_setup` | 5 | 0 |
| GITVIEW-SPEC-0019 | `fc7ba18e9ed0cdc258f416c8978f7f0bf2a6325449fc3d116476da9269203c78` | `review_refs_setup` | 4 | 0 |
| GITVIEW-SPEC-0020 | `8e1e9d5029680c3fb14e3ff06a54e3e93a5106971e22d890f233221a91c92bc6` | `review_refs_setup` | 7 | 0 |
| GITVIEW-SPEC-0021 | `227983ae711dc1ba930736e80afd9bb1853a98b9251da670bfc4a3e2f5b4b265` | `review_refs_root` | 0 | 0 |
| GITVIEW-SPEC-0022 | `bd1fff49fa9a1d0b8d47f812e540fe5baa684123a500ea6989d2faacc7961f30` | `review_refs_root` | 5 | 0 |
| GITVIEW-SPEC-0023 | `4086ceea335f6ac8b86afd4256a6cec93da60c6751ad58073c9440291f71b18d` | `review_refs_projects` | 2 | 0 |
| GITVIEW-SPEC-0024 | `f706339aaa0a9b8c0f8cbb5513f3ff11fe7136b67364c837f1f929df7d463eab` | `review_refs_projects` | 4 | 0 |
| GITVIEW-SPEC-0025 | `d20a8b4ce0c769ac882d31d7f4ef1e2e5c3a8d5f54834bfaef569314cd807e41` | `review_refs_projects` | 9 | 0 |
| GITVIEW-SPEC-0026 | `59bbfb063d66ddab02ac586032d01320925f4d93a947b0eab2cb952899aae58a` | `review_refs_access` | 3 | 0 |
| GITVIEW-SPEC-0027 | `9c8a831489242180c11bd48191d2f9f8a59642920c95ef641fe15de49d551a94` | `review_refs_access` | 4 | 0 |
| GITVIEW-SPEC-0028 | `5f3705bac506eb90c8343489c0122506331834542a5cf1247aad2a90cfdb8127` | `review_refs_signals` | 6 | 0 |
| GITVIEW-SPEC-0029 | `e31c622036a599f173748be03f4e1ad6478c226a9b940c7a85d935e987581f09` | `review_refs_signals` | 11 | 0 |
| GITVIEW-SPEC-0030 | `7391aeef240528c51810618eec2d440032a27416f19afd7b3ad82ae916f177ce` | `review_refs_signals` | 9 | 0 |
| GITVIEW-SPEC-0031 | `4577c9f306835420ba96797651b77790d086b2f242f500873f83e4449aee156f` | `review_refs_preview` | 4 | 0 |
| GITVIEW-SPEC-0032 | `456efd4c7cc59444eadc8d513191ea5985534319e128ed8772fd6bab0424f973` | `review_refs_preview` | 5 | 0 |
| GITVIEW-SPEC-0033 | `d7318b75e8ffa03d05c527b8c8b27c197d7b5acf374b1e45b00bbc0f5ea4ffba` | `review_refs_preview` | 4 | 0 |
| GITVIEW-SPEC-0034 | `f6f4ee1c2f0f1215789b8853daec4f5d97eb6fc0a51c61b3720aee676dee4b36` | `review_refs_setup` | 2 | 0 |
| GITVIEW-SPEC-0035 | `6e9d9c73d3eb98324c8a411ab3230e6497951344efbbb57cf7f816950faa273d` | `review_refs_setup` | 4 | 0 |
| GITVIEW-SPEC-0036 | `603e18e92e436714854631ee909e7410a7bcbd2d63c20a16fe97cbc419e9f3ef` | `review_refs_setup` | 3 | 0 |
| GITVIEW-SPEC-0037 | `8b431a8955ecff705ab017a9c6c4f14b1dbb86324ca75428329d8b3fcfddedd3` | `review_refs_projects` | 4 | 0 |
| GITVIEW-SPEC-0038 | `cdcfeb07131ed8ef0b187af092e662ea82b07d741d36993c6cbddef729c97a51` | `review_refs_projects` | 5 | 0 |
| GITVIEW-SPEC-0039 | `658ad4e14a32ff0b85635a16a0260cb3e1a50f2dc00141754d25b26a8df258c8` | `review_refs_access` | 10 | 0 |
| GITVIEW-SPEC-0040 | `b7a4215538c150d860e9aeb2cce1453aafbbd6ab38c6ed289e392e0dbde20d3e` | `review_refs_access` | 1 | 0 |
| GITVIEW-SPEC-0041 | `95f7d4e008fb1dd030264531f37b644ca36556454bcd88ac71e4a4ad4c5f7ff1` | `review_refs_root` | 9 | 0 |
| GITVIEW-SPEC-0042 | `08000ebc6003c6b5241284a0cacf5e68e42cf7b452f29f11f1502d8560804a9f` | `review_refs_root` | 4 | 0 |
| GITVIEW-SPEC-0044 | `c69c6a7a733d9a66f1442f8a81b223f9f4462d807735fb0f20cfe3ce8c95e20f` | `review_refs_projects` | 4 | 0 |
| GITVIEW-SPEC-0045 | `8f777c436335d7c63f3ed03295054c860da97ff655eb27b4ea71078848889c16` | `review_refs_projects` | 6 | 0 |
| GITVIEW-SPEC-0046 | `a34c018b437cb9992b7302000aac1ab41f0e07e0db0b880683005a68e5cf5aee` | `review_refs_signals` | 9 | 0 |
| GITVIEW-SPEC-0047 | `b5e5c88b22055b2bcf64cf9c2d15bce490590a43c75a7e73496be13c08e8a4bf` | `review_refs_signals` | 12 | 0 |
| GITVIEW-SPEC-0048 | `4ca6ed7a5282e571d7d09db399c0304949ff6de47891719e86d43cc3f2b2bb35` | `review_refs_preview` | 5 | 0 |
| GITVIEW-SPEC-0049 | `223538e49c81d208ca12eb78916ec76453368ea8ed171d48304a891fa553c2a0` | `review_refs_preview` | 4 | 0 |
| GITVIEW-SPEC-0050 | `38c3ec186b138af2162abd417a1da7d36295dca3e2ff6cec05db02a311e03a66` | `review_refs_preview` | 6 | 0 |
| GITVIEW-SPEC-0053 | `85999eed583dcb93d1546e22361cf13cfbf2a390f5796f2ca282ccd5218b5d64` | `review_refs_root` | 3 | 0 |
| GITVIEW-SPEC-0054 | `dcb70e842f9424464c837e6547db9b67b8f88bb3188971bcc9a89ba79aee4e84` | `review_refs_root` | 2 | 0 |
| GITVIEW-SPEC-0056 | `b9b013ea8122cf35f1da3ea857a2f34eaba8daff513daf4f645d44263727ab54` | `review_refs_signals` | 9 | 0 |
| GITVIEW-SPEC-0057 | `12cf45c4ae363b20010342e1cb5e60b9ca05fde27b920b11652928d4fca508e3` | `review_refs_signals` | 10 | 0 |
| GITVIEW-SPEC-0058 | `f783fed1dc0142332b38d6fd88cc7e441a2d7c8ba3bd41256c50d99e87f2750b` | `review_refs_projects` | 3 | 0 |
| GITVIEW-SPEC-0059 | `578b3abe59f3b318db1326b1b4b03ab83034e7fad01501a4a6ba2fb67561df03` | `review_refs_projects` | 6 | 0 |
| GITVIEW-SPEC-0062 | `62a69ea21ea791514f1ebdf9ce66578d0601f0ecbcff415a00330bd89a43f0d2` | `review_refs_access` | 5 | 0 |
| GITVIEW-SPEC-0063 | `5d980a12c7fc7b36cbd3d238c31f25db5016c78484f4b81c3655d0d74b6c1cd1` | `review_refs_access` | 6 | 0 |
| GITVIEW-SPEC-0064 | `651d815f73dfbb220d6360007139cfb52ebc64a39c7109b1c5d4515545aa7b06` | `review_refs_setup` | 4 | 0 |
| GITVIEW-SPEC-0065 | `68a2637040da75dce66641f5e3cd25055318edf47f2f67eee404f530dbf88752` | `review_refs_setup` | 6 | 0 |
| GITVIEW-SPEC-0068 | `77d29da69702eb2b09be831a31fddaec713c92c7f6945af40d8cc283dde06544` | `review_refs_setup` | 7 | 0 |
| GITVIEW-SPEC-0072 | `8d47aaab81dff660ba71f8d7521141a1c907d2367cc714fdf4ec90eb0507b949` | `review_refs_setup` | 4 | 0 |
| GITVIEW-SPEC-0073 | `72e6839d14ee190976581ec2e0544d421c23106feb17153b5b68eec081ae4bd0` | `review_refs_setup` | 5 | 0 |
| GITVIEW-SPEC-0074 | `aa5e64938650af98f59c37c14fe43ad561a16b0a6a80a78eac6409f27c35f4fa` | `review_refs_preview` | 6 | 0 |
| GITVIEW-SPEC-0075 | `81d1ab905d7a1095741401237cd6bb381b5cf8b4b82323f78d2a1fed66afaf19` | `review_refs_preview` | 5 | 0 |
| GITVIEW-SPEC-0077 | `fe04ae630439b8322965d7a1c9cd847ce653b2af02e6d4f82940bdc84f80afab` | `review_refs_access` | 4 | 0 |
| GITVIEW-SPEC-0078 | `c5b84713d30de602f13b7077e4fcc1684481a32b90811618b4b01f8fb9ff39cc` | `review_refs_access` | 12 | 0 |
| GITVIEW-SPEC-0084 | `3c35b198d9c3ad48abed0e5a2c3b96513df601e714c4bdcdb854984b545b5882` | `review_refs_projects` | 9 | 0 |
| GITVIEW-SPEC-0089 | `89f2318a83c79898e6d5fcd92dcd5f08a2c1594ead2c34890643a49631eca7a0` | `review_refs_signals` | 6 | 0 |
| GITVIEW-SPEC-0091 | `63b03ae9139f5d381e2abf3e9090fd405ccb06ac25d3188dfc7816ad43d33ea0` | `review_refs_projects` | 6 | 0 |
| GITVIEW-SPEC-0092 | `817fdc79f0802f192638718752d739899e35c9183feb13fd97c18056d628f12f` | `review_refs_signals` | 10 | 0 |
| GITVIEW-SPEC-0093 | `0718c8011d712cdc2032bde0cac70f9c5ccbdad14f2753b4b5b93c270e8e65c5` | `review_refs_root` | 5 | 0 |
| GITVIEW-SPEC-0094 | `e3e8c50a1739428f8e8bcce069b1e2da0f15edd6ea71a7921e173a3a47d9e854` | `review_refs_signals` | 6 | 0 |
| GITVIEW-SPEC-0101 | `5ee509986b94039eee4932308e880df77c71479b1889738a3d28396779949711` | `review_refs_root` | 9 | 0 |
| GITVIEW-SPEC-0102 | `c313d837d8587cebee60d900bbb47f2ffeefffe1f6d28844b67c9ad61331c050` | `review_refs_root` | 6 | 0 |
| GITVIEW-SPEC-0125 | `1845f4c39c731b87bd456ff0f2a5e8c4ca17476acdab6f53b8b83d295e1d266d` | `review_refs_projects` | 6 | 0 |

## Не перенесённые refs predecessor

Это объяснения по текущей области узлов; прежние черновики сохранены. Одинаковое имя в разных полях и ссылки на term не являются доказательством конкретных экземпляров или фактов.

| Узел | Не перенесено | Причина |
| --- | --- | --- |
| 0001 | `motivcore:Motive` | Текущий корень не определяет мотив конкретного актора или Issue-to-Motive; authored Motivation/ссылка не является доказательством мотива. |
| 0002 | `gitview:managesRepository` | Идентичность и её непрерывность не устанавливают действие регистрации или непрерывный интервал управления; contextual protocol сохранён. |
| 0004 | `gitview:PullRequest`, `gitview:Issue` | Текущий узел задаёт общий overview и делегирует типы работы 0006/0007/0047; подробные примеры predecessor не перенесены как его собственные требования. |
| 0016 | `gitview:Project` | Действующий узел об источнике и sharing описывает Repository, PR и Issue, не Project. |
| 0021 | `User`, `Project`, `Repository`, `PullRequest`, `Issue` | Текущий узел — общие engineering/testability принципы; предметные примеры predecessor не являются его требованиями. Намеренно нулевой inventory, проверено независимо. |
| 0023, 0026 | `gitview:PullRequest`, `gitview:Issue` | Текущие узлы задают общие состояния и категории observations; категория-specific содержание старых drafts в них не перенесено. |
| 0036 | `gitview:Project` | Текущая область — подключение, User и сохранённые Repository observations, а не Project. |
| 0040 | `gitview:Project`, `gitview:Repository`, `gitview:Issue` | Общая testability-спецификация с конкретным примером PR; более широкие предметные примеры predecessor не стали её требованиями. Generic CI input не отождествляется со статусом отдельного check entry. |
| 0064 | `gitview:PullRequest`, `gitview:Issue` | Basis исторического графика определён через текущие Project, Repository и Metric; объекты PR/Issue здесь не являются отдельным контрактом. |
| 0093 | `gitview:ReviewThread`, `gitview:CIStatus`, `gitview:Metric` | Текущий preview обсуждает общие observations и неизвестные counts; не устанавливает отдельный thread, check entry или измеренный результат из более богатого predecessor. |

В 0001 predecessor также содержал ключи `specification.terminology`. Релевантные Project, Repository, GitHubRepository, User, GitHub, PR, Issue, ReviewThread, CIStatus и Metric выражены явными refs; `GitView` — имя продукта, а не объявленный domain class; Code и VersionControlSystem не вводятся в более узкое содержание successor. Это смысловая сверка, а не утверждение, что разные формы YAML совпадают посимвольно. Отдельный пилотный runtime PR #926 сравнил обе формы посимвольно; все 14 исчезнувших объявлений 0001 снабжены пояснениями, а их содержательная проверка остаётся независимым review.

## Проверка

- Installed runtime `3a7f176a`: lint прошёл для 75 YAML; candidate `next-move` вернул `checked` для 75 точных копий.
- `supervisor --build-project-ontology-context-check --ontology-context-map-spec-artifact --ontology-context-check-scope domain_vocabulary` выполнен для каждого из 75 nodes по принятой композиции, в четырёх изолированных копиях на проверенном TB5. 75 `checked`, 431 structural binding, 0 gaps; 0021 — осознанно пустой inventory, не успешное разрешение терминов.
- SHA каждого проверенного файла сравнивался с текущим файлом после review; несовпадений нет. Полные результаты и зафиксированные входы: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology-refs-full-ixzubtjr/summary.json` и `worker-*/GITVIEW-SPEC-*.json`.
- Дополнительный read-only `ontology-ref-diff` из отдельной пилотной установки `559091fa` (PR #926, не выбранный рабочим runtime) сравнил 75 текущих drafts и successors: 301 идентичное объявление, 130 добавленных и 36 исчезнувших объявлений с явными пояснениями. Для 0001 — 0 retained, 11 added, 14 removed: инструмент сравнивает точное написание и не считает `Project` равным `gitview:Project`. Отчёты и SHA обоих входов: `ontology-refs-full-ixzubtjr/declaration-diffs/`. Это не автоматическое доказательство семантической эквивалентности.
- Отчёты advisory и `accepted_bindings` показывают структурное разрешение имен, не правильность фактов, semantic acceptance конкретного утверждения, полное извлечение prose или готовность к реализации.
- Обнаружено отдельное [расхождение об authority REST identity](repository-identity-ontology-tension-20261116.md), которое не закрывается восстановлением refs.

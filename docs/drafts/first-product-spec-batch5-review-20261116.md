# Первая продуктовая спецификация: review партии 5

База `e134e32`; задача всей спецификации продолжается. Девять узлов переведены `outlined → specified` в продуктовых границах, без утверждения implementation или device readiness.

Независимые reviewer'ы проверили группы до и после изменений с указанными SHA: 0042/0044/0048 — неполная выборка, свежесть и refresh; 0031/0050/0093 — static preview; 0039/0077/0078 — Issue, счётчики и связи. В 0044 уточнены оба доступных пути после отзыва — recovery и local deletion; остальные восемь узлов изменены только статусом и timestamp. Все итоговые версии повторно проверены. Недостаток источников или наблюдений не превращается в ноль; детали нативного UI, GitHub mapping и доступности на устройстве остаются открытыми.

SpecGraph: candidate checks 9/9, ontology diff против HEAD без новых удалений, domain vocabulary 9/9 checked, 54 structural bindings, 0 gaps/findings/warnings. Predecessor diff: исторические `CIStatus`, `Metric`, `ReviewThread` в 0093 пояснены `--explain-removal`; текущий узел описывает доступность общих данных preview, не установление отдельных check entry, измеренной Metric или содержимого thread. См. [прежний аудит](../../ontology/review/ontology-references-restoration-20261116.md); пояснение не доказывает семантическую эквивалентность. Отчёты: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/whole-spec-batch5-vvnn6a7m`.

| Узел | SHA-256 | Структурные bindings |
| --- | --- | ---: |
| 0031 | `2db124c8bdc4edfb9dfe194b985f2682f13e9580a9e64448bd9c6a384ac48799` | 4 |
| 0039 | `7ca8e989fee361944bed0cccdc512148bce5669c0c7cce62f35fea43746e181a` | 10 |
| 0042 | `b9bd5b0a05e3e401389491ee29b01f5868e5b793294e6a57c63906fb6c048700` | 4 |
| 0044 | `935a1e18bb0896c12796703d6e68e74602dcfefde4c710a220fd7d0abcd1d1fe` | 4 |
| 0048 | `10ccc0499cef6588dce8febd45e3473e96302eff5578127331dce3ba405c8a30` | 5 |
| 0050 | `69e505a8d13ec551d4dc55128c46268c4f01571f946d17974fa372f73b3cdaf0` | 6 |
| 0077 | `8d87837c9b784284ffcd4b75f035f78a6100462901fa4050421355a68a93c6ff` | 4 |
| 0078 | `f7285f3cf049dcff6dd35b15e6f4e1c76622921223f3fa85790be9dd24764f97` | 12 |
| 0093 | `df4e9568ba0ce58915cf062f2f309e9c2688eb868f1d0f943b8b8068f493e9c6` | 5 |

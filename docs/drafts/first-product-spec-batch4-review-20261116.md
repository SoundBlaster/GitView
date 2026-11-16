# Первая продуктовая спецификация: review партии 4

База `9a2d9a8`; работа над всей спецификацией продолжается. Девять узлов переведены `outlined → specified` в продуктовых границах, не в статус готовности реализации.

Независимое review и повторные проверки SHA: 0023/0026/0037 — неполные observations и refresh; 0024/0074/0091 — навигация, возвращение и фильтры; 0029/0030/0064 — измерения и история. В 0023 и 0037 уточнено, что после отзыва остаются оба пути recovery и явного local deletion. В 0026 и 0037 обновление сформулировано как запрос, без гарантии сетевого успеха. В 0024 выбранный принцип filter origin по 0092 отражён без добавления циклической зависимости. Остальные пять узлов изменены только статусом и timestamp. Каждая итоговая версия повторно проверена.

SpecGraph: candidate checks 9/9, ontology diff против HEAD без новых удалений, domain vocabulary 9/9 checked, 49 structural bindings, 0 gaps/findings/warnings. Predecessor diff: ранее задокументированные исключения Issue/PullRequest для 0023/0026/0064 пояснены `--explain-removal` как сужение к Project/Repository observations и Metric scope, см. [прежний аудит](../../ontology/review/ontology-references-restoration-20261116.md). Пояснения не доказывают семантическую эквивалентность. Отчёты: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/whole-spec-batch4-m7eiol8n`.

| Узел | SHA-256 | Структурные bindings |
| --- | --- | ---: |
| 0023 | `b74d8a52c0fae7ddc2a47461e53a6f007a94320401c6504c4d4ffcada82e7381` | 2 |
| 0024 | `228fd3d0adef644081cfdbe1069e11cacc10332a9e009dc8ca794a68b8da7db6` | 4 |
| 0026 | `0cc9ee7726d8e19c3da7fb2470798906ac98701eff678ef9411f642b2092bf38` | 3 |
| 0029 | `b16dc1180fbc4a58ec36f5d5fd21214c9895f1c78327ba769ade4ba2fda77d27` | 11 |
| 0030 | `a7d1d2768604482f113306b4ebc0f0743b280886304366dfdeb38870c3df026d` | 9 |
| 0037 | `0dbb816629e9986ee6d2daa762062d4f14f5a57c13664bf24a30fc63c763385e` | 4 |
| 0064 | `d6348dfcaa1d45a9c0d74d23104bb15021f42bce3d86d7448bef59fc84d053dd` | 4 |
| 0074 | `61047b6870de8a5edc4ba080dbbdf6cb8397d7d6d3f6a5e120ab4cb55a09f652` | 6 |
| 0091 | `be71aa6d2f5cbca1a380fb5557c50aa2eb285b4fad835d619d6006e0fea20350` | 6 |

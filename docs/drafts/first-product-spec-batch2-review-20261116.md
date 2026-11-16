# Первая продуктовая спецификация: review партии 2

База `baa077b`; работа над всей спецификацией продолжается. Девять узлов переведены `outlined → specified` в продуктовых границах, не в статус implementation или device readiness.

Независимые reviewer'ы проверили группы до и после изменений с указанными SHA: 0010/0034/0054 — авторские описания и форматы; 0016/0017/0032 — GitHub handoff, sharing и доступность; 0011/0028/0062 — индивидуальные CI checks, независимые review/thread-сигналы. В 0010/0054 исправлена граница показа сохранённых private описаний: формат сам не скрывает их, но отображение следует политике аккаунта 0019. Добавлены явные зависимости на 0019; граф из 71 узла не содержит отсутствующих зависимостей или циклов по `refines` и `depends_on`. Остальные семь узлов изменены только статусом и timestamp. Результат ограничен содержательным review этих узлов и не доказывает реализацию.

SpecGraph: candidate checks 9/9, ontology diff с HEAD без новых удалений, domain vocabulary 9/9 checked, 35 structural bindings, 0 gaps/findings/warnings. Predecessor diff: старое исключение `gitview:Project` из 0016 пояснено `--explain-removal`: scope связан с sharing Repository/PR/Issue, локальный Project sharing в v1 не требуется; см. [прежний аудит](../../ontology/review/ontology-references-restoration-20261116.md). Это структурные проверки, не доказательство семантической эквивалентности. Отчёты: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/whole-spec-batch2-155u7zp6`.

| Узел | SHA-256 | Структурные bindings |
| --- | --- | ---: |
| 0010 | `bbb049d4df3950b1657947590e52c1e1a182af460ec1d47171593a17c87377aa` | 2 |
| 0011 | `509d9aea6172bdc69416bf74f472a47b28903d6774b66b3ea3853acb6b246bc1` | 4 |
| 0016 | `c42c9cda2038d69d0dde3c7cf50beefdc2689a441468109d9fff7e2840aafd8c` | 4 |
| 0017 | `21758bf1d8fb70a0cffbba02addb73eff4d6f86cd03ca4a852b0b36027fd7f7c` | 5 |
| 0028 | `f50f3e49e693b15ce8fd404c24f33ab68e015999c16dbd3e6ddd73a364a95985` | 6 |
| 0032 | `f3d39dbcc59eb881892f4adeb6a653d0f31760217644aea688dbfe75c428391b` | 5 |
| 0034 | `29eb749f8f1fabd6835ca02aab51e1217b3c2ffa0fc6818e896c6bcee900c210` | 2 |
| 0054 | `da7e5c8efb4e25ec91e0ea85d9b7396704c77e6b49e0a9e1c414dcb24b2721a2` | 2 |
| 0062 | `3a175e706a48c5788194ad084c6d3df7c64df9ead793f498353fc1806bcc791d` | 5 |

# Первая продуктовая спецификация: review партии 6

База `5cbdf4e`; работа над всей спецификацией продолжается. Одиннадцать узлов переведены `outlined → specified` в их продуктовых областях. Это не implementation, device или release readiness; календарь как направление не делает его обязательным для v1, sliding и PR depth не становятся выбранными функциями.

Независимые reviewer'ы проверили группы до и после изменений на указанных SHA: 0056/0057/0068 — история и метрики; 0072/0073/0075 — порядок, фокус и жесты; 0018 — календарь как направление; 0021/0040 — выбранные testability, DI, TDD, mocks и FSD/SpecificationCore как engineering directions; 0094/0125 — ожидание ответа и Done. В 0056/0057/0068 уточнена граница active account/A→B; в 0068 выбранный origin filter и исторический merged-counter scope. В 0057 уточнён контекст того же selected counter. 0018 получил acceptance об ожидаемом pinch-out с открытыми native и v1 деталями. Прочие узлы изменены только статусом и timestamp. Все исправления прошли повторное review.

SpecGraph: candidate checks 11/11, ontology diff против HEAD без новых удалений, domain vocabulary 11/11 checked, 58 structural bindings, 0 gaps/findings/warnings; 0021 — намеренно пустой inventory, а не успешное разрешение терминов. Predecessor diff: исторические доменные примеры в 0021/0040 исключены в рамках инженерных принципов; пояснения записаны через `--explain-removal` и [прежний аудит](../../ontology/review/ontology-references-restoration-20261116.md), что не является доказательством semantic equivalence. Отчёты: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/whole-spec-batch6-xtuflfg5`.

| Узел | SHA-256 | Структурные bindings |
| --- | --- | ---: |
| 0018 | `3c54dfdddf65bf96d4341f2b053f06e88fccbbdd7652b31e50570065ec3f58cc` | 5 |
| 0021 | `96213558bed2c3a4abc30d61e31a8ee816117a89641eadb73b7d217a5bd2d6fb` | 0 |
| 0040 | `9b4085786ef6c4ebdf0a2a7776e3d021c2b2efba06abaf567e2238812797982b` | 1 |
| 0056 | `ea85edc8ccef5f08bdba1e9eed38e4a4d3948e406121a49208802a6f0c39e809` | 9 |
| 0057 | `4904b9b13943e48331603c4f0745abe0282bf3f372e1ba1797fa60d65448abcf` | 10 |
| 0068 | `e779f4e51a5f24a0efc82aa2dab7d09d70cacaf88de4ec618bdad45f2ad46555` | 7 |
| 0072 | `da5ce60eae49c705081d852e6bcffde3e500471ab29fda3844dc4fd5a6297497` | 4 |
| 0073 | `f0fba40bb0f7c5eea1b4444da88793bdca7ce7ba9a9ea1bdc065dafac49f8dc0` | 5 |
| 0075 | `5bda1edb8c206c9a954ca48854ace2d9d2180dcf24a847e79811cfeb174f9499` | 5 |
| 0094 | `efb0b9235375a83dc36710bb26e305b5a1096ad802eeb5151e2726a482211d59` | 6 |
| 0125 | `83af919f38e3ee43d716e527889828a58976dfea74f9531c9c4c2e1cad6efe29` | 6 |

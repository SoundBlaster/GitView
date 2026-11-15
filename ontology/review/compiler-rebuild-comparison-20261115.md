# Сверка compiler для GitView ontology

15 ноября 2026 выполнена независимая локальная release-сборка `ontologyc` из
чистого checkout Ontology `4c5027b7fe075e80d141e77f576eaa58ca0d3679`.
`Package.resolved` имел SHA-256 `7a4d649b0d8b3aff6ccae70634e8bb6df7ca08b24f81332dbc340b2fb661940f`;
использован Swift 6.4 (arm64), `--force-resolved-versions`. Checkout остался
чистым. Scratch и cache направлены на проверенный TB5; продукт —
`/Volumes/TB5/Developer/Builds/GitHub/Ontology-881ba79a220bd2df/swiftpm/out/Products/Release/ontologyc`.

| Инструмент | SHA-256 бинарника | `check` композиции | `compile` с двумя imports |
| --- | --- | --- | --- |
| Использованный ранее в GitView | `30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb` | PASS | PASS |
| Независимо собранный | `3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720` | PASS | PASS |

Оба `compile` произведены для одной композиции draft.11 и одинаковых
motivation-core и events-core imports. Каждый из 10 файлов в output имеет тот
же относительный путь и SHA-256 в обоих выводах. Входные SHA-256:

- GitView composition: `17b530b94f21ee78d6a8ee69a57f4ec1eafe4a02ff5973360cc811075fa22f7d`.
- motivation-core: `3061eca33ddc2296c2c292695d98daf6697e92fb582da544bc1d5107721ae955`.
- events-core: `92a3245fc9acd15748fd1fa3cfb8e4fdc8fda429a5fd6cffd7a97bc13f2f359e`.

Результаты сравнения сохранены на TB5 в каталоге
`GitView-a40d73ccf162f8d8/gitview-compiler-comparison-nigsebbr/`. Это
подтверждает совпадение результата на выбранных входах, а не происхождение
прежнего бинарника или его эквивалентность новому на любых входах. Не
повторялись все SpecGraph bindings и не изменялись выбранные compiler hashes,
ontology package или статус `draft`. Содержательное принятие онтологии и
полнота графа этим экспериментом не установлены.

## Проверка выбранного draft.12

Тем же независимо собранным бинарником 15 ноября повторно выполнены `check`
и `compile --target typescript` выбранной композиции draft.12 с её двумя
импортами; оба завершились успешно. Из десяти файлов компилятора в GitView
сохранён один — `ontology.normalized.json`: его SHA-256 совпал с новым выводом
(`5e37009a03f4354d988ebef78976d8edffe2e9460ecd7f7309ca2ccb05e86055`).
Остальные девять файлов новой генерации не с чем сравнить в сохранённом
каталоге. Новый вывод находится на TB5 в
`GitView-a40d73ccf162f8d8/gitview-draft12-rebuilt-5vhmp8uf/`.

Таким образом, сохранённый IR выбранного пакета воспроизведён с известным
исходным checkout и закреплёнными imports. Это не устанавливает происхождение
ранее использованного бинарника, семантическую правильность пакета или
эквивалентность compiler на других входах; проектная настройка и артефакты
пакета не менялись.

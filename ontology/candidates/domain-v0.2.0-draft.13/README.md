# GitView ontology draft.13 — значение Project

Отдельный невыбранный candidate на основе draft.12. Меняет версию пакета на
`0.2.0-draft-composition.13` и описание Project на предлагаемый смысл:
«единица организации работы для её обзора в GitView». Identity, свойства и
членство в Repository остаются отдельными. Формулировка и её примеры описаны в
[предметной сверке](../../review/project-repository-spec-alignment-20261115.md).
Это предложение агента, не semantic approval и не новый выбор владельца.

Сравнение распарсенных YAML подтвердило, что помимо версии и описания Project
остальные данные source package равны draft.12. Compiler, собранный из checkout
Ontology `4c5027b7fe075e80d141e77f576eaa58ca0d3679`, SHA-256 бинарника
`3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`,
успешно выполнил `ontologyc check` и `compile` с motivation-core и events-core.
SpecGraph `ontology-doctor` с явным selection и тем же pinned compiler вернул
`outcome: verified`, `semantic_approval: not_established`,
`compiler_provenance: not_verified` и пустой `next_steps`. Отчёт и полный
вывод compiler — на TB5 в `GitView-a40d73ccf162f8d8/gitview-draft13-gokn5qw1/`.

Проверка формы не устанавливает правильность предлагаемого значения или
совместимость всех spec bindings. Настройка проекта по-прежнему выбирает
draft.12; новые ID, действия, поля, связи и кардинальности не добавлены.

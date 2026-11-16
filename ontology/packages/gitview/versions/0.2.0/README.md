# GitView ontology 0.2.0

Утверждённая версия локального пакета `local.gitview.domain` для спецификаций GitView. Решение владельца и его границы: [owner acceptance](../../../../review/owner-acceptance-20261116.md).

Источником послужил закреплённый [draft.13](../../../../candidates/domain-v0.2.0-draft.13/README.md). При подготовке изменены только `metadata.version` и `metadata.approvalStatus`; кандидатные и экспериментальные ограничения внутри пакета сохранены. Approval пакета не доказывает существование конкретных отношений или фактов. Импортированные пакеты сохраняют собственные статусы.

- Source SHA-256: `4ee191a0a413eabba2146561cd95c342c63c777156dc705870e9d15c9939f8e2`.
- Normalized IR SHA-256: `e83f0e5d623d6eaf4800a4dd1548e3e931edbc7ccc7b34d06d75b98371d66e7d`.
- Compiler SHA-256: `3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`; см. [сравнение сборок](../../../../review/compiler-rebuild-comparison-20261115.md).
- [Composition selection](composition-context.yaml) связывает package с теми же версиями и hash импортов; она выбрана проектной конфигурацией.

`ontologyc check` и `compile` успешны; `ontology-context` подтвердил структурную композицию. Сверка IR после нормализации версии и source digest не нашла других отличий от draft.13. Это не проверка истинности предметных утверждений или реализации приложения.

Выборочная advisory-проверка действующих спецификаций 0001, 0002, 0005, 0028 и 0045 завершилась `checked`, но каждая вернула `accepted_binding_count: 0`, `passed_check_count: 0` и `next_gap: review_legacy_spec_ontology_bindings`. Это не подтверждение coverage их терминов. Отчёты сохранены на TB5 в `GitView-a40d73ccf162f8d8/ontology-020-bindings-d1itfq4l/`.

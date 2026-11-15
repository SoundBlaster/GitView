# Project composition: перенос и review

На базе GitView `1f910ace120a741dfd30d0d998395a8276b03647` подготовлен
[GITVIEW-SPEC-0005](../../specs/nodes/GITVIEW-SPEC-0005.yaml), уточняющий
канонический корень 0001. В узел перенесены выбранные владельцем границы:
один или более Repository, участие Repository в нескольких Projects, разные
organizations как source metadata и default один Project на Repository.
Предложенная постоянная default association остаётся рабочим вариантом агента,
не выбранным владельцем. Исходный [черновик](GITVIEW-SPEC-0005.yaml) сохранён
как неканонический источник; его технические контракты и ontology bindings не
принимаются автоматически.

Независимый read-only reviewer сопоставил первый вариант узла с родителем,
исходным черновиком и разбором default association. Он указал, что слово
`recoverable` могло обещать восстановление при недоступных evidence. Автор
исправил правило: согласовывать исход при наличии оснований, иначе сохранять
неопределённость и не дублировать возможный эффект. Дополнительно уточнены
статусы association и organization. Reviewer сообщил scoped PASS для
SHA-256 `6e83129522a2b2492dbe55afd5124ed70f96175754ef3917251c1df36d16a937`;
после его неблокирующего уточнения об owner selection подтвердил точечную
правку для итогового SHA-256
`ad032aa4202f355483294f2666ad9b96ea3a648c6b06d20c1cdf9e58eb2476c0`.

Установленные `spec_yaml_format.py` и `spec_yaml_lint.py` проверили формат
YAML; `next-move --target-spec GITVIEW-SPEC-0001` видит оба узла и направление
`0005 refines 0001`. Рекомендация SpecGraph — дальнейшее уточнение с review;
она не подтверждает реализацию. Оба узла имеют статус `outlined`; source,
storage, access, ontology semantics и другие дочерние черновики требуют
самостоятельного уточнения и не принимаются этим переносом.

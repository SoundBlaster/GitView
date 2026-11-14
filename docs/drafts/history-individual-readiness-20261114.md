# GitView: поузловая оценка ветви истории

Авторский review девяти перечисленных candidates на 14 ноября, не независимое
принятие и не разрешение начать реализацию. Все рассматриваемые узлы находятся
в `idea / pre_canonical`. Их точные версии указаны ниже; после изменения
файла оценку нужно перепроверить. Полный транзитивный semantic audit и проверка
реального продукта не выполнены.

| Узел | Что определено | Что ещё нужно решить до реализации соответствующей границы | Отдельное evidence после реализации |
| --- | --- | --- | --- |
| [0056](GITVIEW-SPEC-0056.yaml): outcome selection | Историческое событие, полуоткрытый период, разные единицы event и distinct object, текущий lifecycle и неполный охват. | Конкретизировать source mappings и доступность идентифицированных событий и object selection; при отсутствии подтверждения дать ограниченный путь. | Реальный GitHub adapter и события с reopening; native navigation и accessibility. |
| [0057](GITVIEW-SPEC-0057.yaml): каталог | Единицы open PR/Issue, draft, CI, review, threads, blockers и outcome; динамический Today отдельно от истории и фиксированного cohort. | Установить применимые source facts и predicates, выбрать условный ready predicate либо не предлагать его как известный показатель. | Field permissions, семантика source и фактическое представление. |
| [0064](GITVIEW-SPEC-0064.yaml): membership basis | Кандидат фиксированной ретроспективы по текущим members, отдельные фактическая локальная история состава, доступ и ограничения сравнения разных scope. | Зафиксировать проектное решение о default и практическую lineage для отображения и пересчёта агрегатов; не приравнивать недоступный вклад нулю. | Storage/recovery lineage и native presentation при изменении состава. |
| [0065](GITVIEW-SPEC-0065.yaml): evidence | Событие не доказывает полный bucket; current state не восстанавливает прошлый snapshot; причины и mixed-time данные остаются отдельными. | Для выбранных source operations определить доказуемый охват и корректный fallback при недоступной истории; reconstruction допустима только при достаточной истории. | Проверка реальных permissions, event ordering и source consistency. |
| [0066](GITVIEW-SPEC-0066.yaml): retention | Кандидат сохранять доступные observations после refresh, раздельные state и event facts, storage failures и ограничения выборки. | Завершить data minimization, физический retention и recovery contract, политику объёма и очистки, а также связать их с 0105 и 0117. Не обещать периодический sample от iOS. | Прерывания записи, переполнение, restart, защита и backup на поддерживаемом устройстве. |
| [0069](GITVIEW-SPEC-0069.yaml): первые ряды | Четыре предложенные серии, точные единицы, локальные календарные интервалы, фиксированный период и выбор последнего наблюдаемого daily sample. | Проверить пригодность defaults 7/30 дней, правила выбора sample и доступ к остальным согласованным рядам; разрешить конкретный способ показать gap и partial. | Реальный календарь/DST, chart, Dynamic Type и управление на устройстве. |
| [0097](GITVIEW-SPEC-0097.yaml): расширенный каталог | История согласованных attention и draft metrics, наблюдаемый локальный membership count и category-specific coverage; aggregate не является объектным списком. | Довести каждый выбранный predicate, eligibility для capture, source coverage и доступ к серии; 24-hour comment proxy остаётся авторским выбором, не доказанным возрастом thread. | Фактическое наличие данных, source permissions, retention и полезность представления. |
| [0117](GITVIEW-SPEC-0117.yaml): clear history | Кандидат installation-wide clear с generation и раздельным current cache; повтор и late source result не должны восстанавливать очищенную историю. | Утвердить область и понятный UX, определить фактический coordinator, транзакции, failure mapping, retention и backup semantics. Логическое удаление не является secure erase. | Concurrency, crash/restart, защита файлов и системные backups. |
| [0118](GITVIEW-SPEC-0118.yaml): инспекция и accessibility | Не полагаясь только на цвет и drag, различать zero/gap/partial; сохранять scope, время, event/object units и безопасный фокус. | Выбрать доступный native путь и последовательность инспекции, включая fallback при смене данных или доступа, не обещая платформенных гарантий без evidence. | Реальные VoiceOver и другие поддерживаемые assistive technologies, размеры текста и системные состояния. |

## Единицы и минимальное evidence

- **State:** open PR/Issue и attention — число подтверждённых объектов или
  threads в контексте наблюдения. Отдельное текущее поле не восстанавливает
  значение за прошлый день. У нескольких Repository могут быть разные времена.
- **Outcome:** merged PR и closed Issue — distinct объекты с событием в
  указанном интервале; число events является другой единицей. Причина закрытия
  относится к событию, а не автоматически к текущему состоянию Issue.
- **Local membership:** сохранённое наблюдение состава GitView Project — не
  история GitHub organization и не доказательство состава между двумя samples.
- **Coverage:** показатель требует собственного числителя, знаменателя,
  категории, scope и времени; успешная запись или один видимый Repository не
  делают другие категории полными.

Подробная [матрица источников](metric-source-evidence-matrix-20261114.md)
содержит документальные ориентиры; она не подтверждает выбранные запросы или
права конкретного аккаунта. Пользовательский продукт может показывать
поддержанные частичные данные и gaps. Нельзя заявлять полную историю или
объектный drill-down из одного агрегата.

## Последовательность до реализации

1. Стабилизировать смысл и source evidence категорий 0057/0065, отдельно
   сохраняя неопределённость там, где источник не поддерживает полное history.
2. Закрепить membership basis, период и допустимые сравнения 0064/0069; явные
   агентские defaults остаются предложениями до содержательного review.
3. Согласовать retention, clear и lineage 0066/0097/0117 с общим storage
   contract и data minimization.
4. Специфицировать доступные маршруты инспекции и recovery 0056/0118 и затем
   повторить review всех затронутых зависимостей в общем графе.

```text
0056  7464edd7790a8a412dede483e6ec7a59377da8f138aa8918fb04cce3da0d3671
0057  b66e0ca384d7adfb9a5ff53adb23f6829f695e96c0fd6f777d0f4842f486e0b0
0064  f86d95dc7d602d292d7b65a7447491e4d8fd722cdd6d50598b268602236a486b
0065  2345935a00677d1c4f2e21a9905b9ddbdef1c5b344cf51f269df1dcf94458a4a
0066  f43ced38cbf6a3f21fed04b344da9172a2137c75fec13ecb2e6969bd00df13fa
0069  954370ebb3509952c979a846db73e7a5f40c8fe0b1c63476cd3c7ea557205c09
0097  33e44ffe6c6e65efb398cac3b66eb873f754e54e2ab1a29fab3efa182382a8af
0117  961f95ec1e57dcaaa708ad3d3a2e7c1db173c15f96bacbb52ece93933ce0a590
0118  7c5b0b41db5ebf62a1cdd9daa6c1c30f6258d5ccb27c583a09161c91891548fe
```

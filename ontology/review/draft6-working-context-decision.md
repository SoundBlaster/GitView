# Draft.6 как рабочий контекст GitView

Решение агента в рамках автономного уточнения графа, 14 ноября: использовать
[составной draft.6](../candidates/domain-v0.2.0-draft.6/composition-context.yaml)
для подготовки candidate specs. Это не semantic approval ontology package,
не canonical acceptance и не доказательство исполнения поведения. Draft.5
остаётся доступным контрольным контекстом; применимость и происхождение
конкретных actor/action/instance relationships остаются предметом review.

## Основания

- Draft.6 сохраняет draft.5 и добавляет `RemoveRepository` с типизированной
  ссылкой на `Repository` и action relation `removesRepositoryFrom`. Это
  ограниченный смысл удаления участника из одного Project, а не новая UI entity.
- Компилятор, composition context и тестовый потребитель ранее проверены;
  реальные правила изменения состояния в примере реализованы самим потребителем.
- На 83 неизменённых candidate specs сравнение `domain_vocabulary` в двух
  контекстах показало одинаковое число findings и gaps для каждого узла:
  по одному warning/gap в 0001 для имени продукта `GitView`, в остальных ноль.
  `checked` при этом не означает отсутствие warnings.
- После выбора в 0005 добавлены ссылки на добавление, удаление и membership,
  а в 0025 — на удаление и membership: эти узлы непосредственно определяют
  изменение состава. В 0082 и 0083 термины не добавлены только из-за
  упоминания удаления: их предмет — конкурентность и восстановление правок.
- 0001, 0005 и 0025 повторно проверены на актуальных байтах; 0001 сохраняет
  прежний warning о продуктовой метке, 0005 и 0025 не имеют findings/gaps.
  Все 83 текущих candidate files дополнительно прошли shallow candidate check.
  Сверенные SHA и два baseline — в [отчёте](../../docs/drafts/evidence/autonomous-goal-draft6-selection-20261114.json).

Результат `domain_vocabulary` означает разрешение имён в указанной композиции.
Он не устанавливает instance binding, факт действия конкретного User, цель,
мотив, действительность перехода или соответствие реализации. Action relation,
сохранённое текущее membership и историческое свидетельство — разные вещи.
До наблюдения операции её сценарии остаются ожидаемым поведением.

## Что остаётся

В выбранном package есть декларация action, но lifecycle прекращения и повторного
возникновения membership, события и source provenance формально не приняты.
Остаются проверка смысла `CIStatus`, `Metric`, связанных Issue/PR и другие
ontology gaps. Не выполнялись GitView product tests, реальная запись в storage,
native interaction или интеграция GitHub. Следующий шаг — рассмотреть
формализацию lifecycle membership и evidence actor/action отдельно от фиксации
текущего Project state.

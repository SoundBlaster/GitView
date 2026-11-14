# GitView ontology draft.6 — кандидат удаления membership

Статус: **рабочий draft для подготовки графа**, не canonical ontology.
Первоначально проверялся в изолированном контексте и затем выбран как рабочий
после сравнения 83 candidate specs с draft.5. Исходит из составного draft.5; единственные содержательные
изменения — `RemoveRepository(repository: Ref<Repository>)` и отношение
`User → RemoveRepository → Project` с именем `removesRepositoryFrom`.
`projectIncludesRepository` остаётся описанием membership; новый action не
добавляет постоянного свойства «удалён из» и не заявляет мотив актора.

Этот кандидат отвечает ограниченному случаю: оператор меняет состав одного
Project, а тот же Repository и его membership в других Projects сохраняются.
Граница непустого Project, разрешение ссылки, concurrency, ошибки и сохранение
состояния относятся к поведению приложения и specs 0025/0082/0083. Сам факт
компиляции action и relation не реализует эти правила и не доказывает, что
конкретный актор действовал. Пакет сохраняет `approvalStatus: draft`.

## Проверено 14 ноября

- Закреплённый локально собранный compiler `ontologyc` с SHA-256
  `30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`
  выполнил `check` без diagnostics и сгенерировал TypeScript SDK.
- В тестовом потребителе [verify-removal.ts](verify-removal.ts) перед чтением и
  после чтения записи состав не менялся; после `trigger` с **явно написанным
  обработчиком** `P={R1,R2}, Q={R1}` превратилось в `P={R2}, Q={R1}`.
  Этот обработчик отверг unknown reference, отсутствие membership и попытку
  удалить последнего участника; schema отвергла неверный target, отсутствующий
  параметр и неверный actor type, TypeScript — неподходящий target/object и
  data-only actor без обработчика. Это проверка сгенерированного SDK и
  отдельного test consumer, не приложения, storage, concurrency или платформы.
- Установленный runtime `3593bd75` в отдельном scratch workspace проверил
  [composition context](composition-context.yaml): `verified`,
  `semantic_approval: not_established`. Проверены source/IR digests и names;
  происхождение compiler binary независимо не подтверждено.
- Candidate specs 0005, 0025, 0082 и 0083 отдельно прошли `domain_vocabulary`
  с нулём findings и gaps в этом контексте. Это разрешение используемых ими
  терминов; они не ссылаются на новое действие и проверка не устанавливает
  instance binding, реализацию удаления или семантическое утверждение.

Подробные хеши и первоначальный ограниченный результат — в [verification.json](verification.json);
поле `candidate_status` отражает момент до выбора рабочего контекста. Текущая
project selection указывает на draft.6, draft.5 сохранён для сравнения.
Основание выбора и границы — в [working-context decision](../../review/draft6-working-context-decision.md).
Отдельный [pilot привязки](../../pilots/membership-removal-binding/README.md)
сравнивает ссылки на новый action в draft.5 и draft.6 без изменения исходной spec.

## Воспроизведение SDK-проверки

Использовать проверенный TB5 scratch с установленными зависимостями из lockfile
`ontology/candidates/domain-v0.2.0-draft.3/operator/package-lock.json` и
совпадающего `package.json`. Скопировать оба файла и `verify-removal.ts` в
scratch, затем выполнить `npm ci --ignore-scripts --no-audit --no-fund` с npm
cache на TB5. Далее скомпилировать этот package через `ontologyc compile ...
--target typescript --out generated`, проверить TypeScript со `--strict` и
`--exactOptionalPropertyTypes` и запустить полученный JavaScript. Не запускать
fixture как код GitView и не считать модель доказательством конкурентного или
durable поведения.

Остаются открытыми смысл завершения actor-derived отношения и связь истории
действий с текущим membership, необходимость и authority нового action,
непустой состав в разных стадиях редактирования, а также независимый review.

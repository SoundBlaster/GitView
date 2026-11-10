# GitView: runtime SpecGraph 3593bd75

Установлен отдельный native runtime из checkout SpecGraph commit
`3593bd759c429425cb68030da2b5431b21513f42`. Прежняя установка
`runtime-8303a681` сохранена. Установка использовала Python 3.12.11 и
временные файлы и pip cache на проверенном TB5. Предварительная попытка с
системным Python 3.9 штатно отклонена до создания каталога установки.

## Проверка

- `next-move --candidate-file docs/drafts/GITVIEW-SPEC-0004.yaml` в самом
  GitView возвращает `product_workspace_candidate_check`, `checked`,
  `canonical: false`, `next_action: review_candidate`. SHA-256 в отчёте
  совпадает с файлом:
  `5a940eaa890847a22f9512ba680ebab482647348e2c662a5e452c10a13c64d48`.
- Аналогично проверен 0006, SHA-256
  `eea120e26acd8552eff34ce67a0f4242b92101033bcc787f62ef0e024b6a3023`.
  Проверка читает mapping, kind и соответствие имени ID; она не проверяет
  онтологию, зависимости, критерии или зрелость и не меняет рабочее дерево.
- Для контроля `--target-spec GITVIEW-SPEC-0004` по-прежнему возвращает ошибку:
  узел отсутствует в governed `specs/nodes/`. Создавать копию туда для
  проверки кандидата больше не требуется.
- `ontology-doctor` с выбранным draft.5 и закреплённым compiler возвращает
  `verified`; это не semantic approval.
- `notes verify_history` подтверждает все 102 ревизии. Skill заметок побайтово
  совпадает с новым дистрибутивом; ontology skill отличается только сохранённым
  проектным расширением GitView.

Следующий шаг — применить candidate check к черновику временной выборки и
фильтров при его уточнении.

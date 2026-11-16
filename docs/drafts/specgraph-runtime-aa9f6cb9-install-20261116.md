# Обновление штатного SpecGraph runtime

GitView использует отдельную установку `runtime-aa9f6cb9-py313`, полученную из чистого checkout SpecGraph на commit `aa9f6cb9010a003b8d09b1b4773498c07d1395ba` (PR #926). Native manifest сообщает SpecGraph 0.2.0 и Python 3.13.15; штатный launcher и примеры переключены в `AGENTS.md`. Прежний `runtime-3a7f176a` сохранён для явного rollback.

Проверенные SHA-256:

- launcher: `c0deb021411ca3d892320eeb4c477510d7e6fac1e1e0162142a0e201bfb5ec6c`;
- `runtime.json`: `9745a3443e7dea082395ba129ae50de93f68c9350c19ec7225db136b7030144c`;
- установленный `source/tools/ontology_ref_diff.py`: `67f717935b5758323122e34bcfe22a6c6c91cc7e1a6a47d4af5fd87aac5439e2`.

Штатный launcher распознаёт `ontology-ref-diff`. Для текущих `docs/drafts/GITVIEW-SPEC-0001.yaml` SHA `c50af008ab299641756a381206b4aec2a6949883bcffb6d17e97735a38adaa19` и `specs/nodes/GITVIEW-SPEC-0001.yaml` SHA `c25d717ddb120020ff31891140435a78dc710eeaf55c3148a6b1d1a3d79ffaaa` результат: 0 retained, 11 added, 14 removed, все 14 с пояснениями. Tool сравнивает точное написание: unqualified terminology и qualified refs считаются разными. Пояснение не доказывает семантическую эквивалентность. Полный отчёт находится на TB5: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/runtime-aa9f6cb9-root-diff.json`.

Тем же launcher `lint` для корневого узла и всех 75 nodes вернул `passed`, 0 issues; `ontology-doctor` с закреплённым `ontologyc` подтвердил выбранную композицию 0.2.0 (`verified`). Это проверки структуры и инструментария, не runtime-исполнение GitView и не новое принятие онтологии.

Первая попытка с системным Python 3.9.6 была отклонена до создания каталога. Попытка с `/Users/egor/.local/bin/python3.12` создала неполное окружение `runtime-aa9f6cb9`: его Python не обнаружил stdlib при запуске ensurepip. Каталог сохранён для диагностики и не является штатной установкой. Успешная отдельная установка использовала `/opt/homebrew/bin/python3.13`; pip cache, временные сборочные и bytecode данные были направлены на проверенный TB5.

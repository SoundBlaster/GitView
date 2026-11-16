# Сверка CIStatus и агрегатов: узел 0046

Утверждённый `gitview:CIStatus` — наблюдаемый статус одной status-check entry. `gitview:Metric` — измеренный результат с применимым контекстом. Узел 0046 описывает отдельно наблюдаемые общие CI facts и пример `CI failed at T1`; он не задаёт гранулярность отдельной check entry. Ранее добавленная прямая ссылка на CIStatus была избыточно конкретной. Удалена только эта ссылка; `Metric`, остальные refs, продуктовые требования, сценарии и acceptance сохранены. Узлы 0028/0029/0047 отдельно описывают проверки и сигналы; их ссылки данным исправлением не менялись.

Независимый read-only reviewer `/root/review_aggregate_ci_scope` проверил финальный SHA-256 `43f00c3981012cf2c2393522ef26a4ecb686256a56f529c0a69545552800c0d5` против HEAD, принятого package и соседних узлов. Замечаний нет; review не является полным семантическим аудитом соседей или проверкой приложения.

Installed runtime 3a7f176a: `lint` passed, candidate checked; advisory `domain_vocabulary` checked, 8 structural bindings, 0 gaps. Отчёт на TB5: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/aggregate-ci-scope-ha7a8k2w/GITVIEW-SPEC-0046.json`. Это не live-проверка GitHub и не реализация.

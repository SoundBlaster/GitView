# GitView — полный граф кандидатов

Этот снимок создан из YAML в `docs/drafts/`. Отступы показывают `refines`; таблица ниже — прямые `depends_on`. Узел с несколькими родителями показан под каждым из них; повторная ссылка не является копией спецификации.

Все статусы показаны как записаны в файлах. Структура не доказывает смысловую полноту, принятие, готовность к реализации или выполненные тесты.

Кандидатов: **126**. SHA-256 имён и содержимого исходных YAML: `af7b42a7142fd45b83b9cda9a9bb07ae33aa67bcbd2095f45706fcdd2ebe3de4`.

Воспроизведение и проверка снимка: `python docs/drafts/evidence/render-specification-graph.py` и та же команда с `--check` в Python environment SpecGraph.

## Дерево уточнения

- [GITVIEW-SPEC-0001](GITVIEW-SPEC-0001.yaml): product overview and domain boundary — idea / pre_canonical
  - [GITVIEW-SPEC-0002](GITVIEW-SPEC-0002.yaml): Repository identity across rename and transfer — idea / pre_canonical
    - [GITVIEW-SPEC-0038](GITVIEW-SPEC-0038.yaml): Repository identity under incomplete observations — idea / pre_canonical
      - [GITVIEW-SPEC-0080](GITVIEW-SPEC-0080.yaml): Exact Repository identity comparison — idea / pre_canonical
        - [GITVIEW-SPEC-0081](GITVIEW-SPEC-0081.yaml): Repository address conflict and recovery — idea / pre_canonical
  - [GITVIEW-SPEC-0003](GITVIEW-SPEC-0003.yaml): Stored GitHub observations and refresh — idea / pre_canonical
    - [GITVIEW-SPEC-0026](GITVIEW-SPEC-0026.yaml): Scoped observations and incomplete refresh — idea / pre_canonical
      - [GITVIEW-SPEC-0037](GITVIEW-SPEC-0037.yaml): Refresh ordering and access changes — idea / pre_canonical
        - [GITVIEW-SPEC-0053](GITVIEW-SPEC-0053.yaml): Conflicting source observations — idea / pre_canonical
      - [GITVIEW-SPEC-0044](GITVIEW-SPEC-0044.yaml): Observation status and coverage interpretation — idea / pre_canonical
        - [GITVIEW-SPEC-0071](GITVIEW-SPEC-0071.yaml): Durable observation boundaries and recovery — idea / pre_canonical
          - [GITVIEW-SPEC-0103](GITVIEW-SPEC-0103.yaml): Local operation identity and durable outcome — idea / pre_canonical
            - [GITVIEW-SPEC-0104](GITVIEW-SPEC-0104.yaml): Project configuration storage boundary — idea / pre_canonical
            - [GITVIEW-SPEC-0105](GITVIEW-SPEC-0105.yaml): Observation retention storage boundary — idea / pre_canonical
              - [GITVIEW-SPEC-0116](GITVIEW-SPEC-0116.yaml): Scoped observation exchange for work routes — idea / pre_canonical
              - [GITVIEW-SPEC-0123](GITVIEW-SPEC-0123.yaml): Recoverable observation evidence record contract — idea / pre_canonical
                - [GITVIEW-SPEC-0124](GITVIEW-SPEC-0124.yaml): Durable work identity association and recovery — idea / pre_canonical
              - [GITVIEW-SPEC-0126](GITVIEW-SPEC-0126.yaml): Observation retention and recovery interface contract — idea / pre_canonical
        - [GITVIEW-SPEC-0102](GITVIEW-SPEC-0102.yaml): Population coverage evidence across refreshes — idea / pre_canonical
    - [GITVIEW-SPEC-0048](GITVIEW-SPEC-0048.yaml): Refresh triggers and visible outcomes — idea / pre_canonical
  - [GITVIEW-SPEC-0004](GITVIEW-SPEC-0004.yaml): Main screen — idea / pre_canonical
    - [GITVIEW-SPEC-0006](GITVIEW-SPEC-0006.yaml): Project contents and navigation — idea / pre_canonical
      - [GITVIEW-SPEC-0007](GITVIEW-SPEC-0007.yaml): Timeline and filters — idea / pre_canonical
        - [GITVIEW-SPEC-0027](GITVIEW-SPEC-0027.yaml): Today selection and filter uncertainty — idea / pre_canonical
          - [GITVIEW-SPEC-0049](GITVIEW-SPEC-0049.yaml): Today boundary and active navigation — idea / pre_canonical
          - [GITVIEW-SPEC-0089](GITVIEW-SPEC-0089.yaml): Temporal applicability of Today and filter evidence — idea / pre_canonical
          - [GITVIEW-SPEC-0101](GITVIEW-SPEC-0101.yaml): Normalize GitHub work representations for Today — idea / pre_canonical
          - [GITVIEW-SPEC-0110](GITVIEW-SPEC-0110.yaml): Pure Today selection decision contract — idea / pre_canonical
        - [GITVIEW-SPEC-0042](GITVIEW-SPEC-0042.yaml): Work ordering and uncertain selection presentation — idea / pre_canonical
        - [GITVIEW-SPEC-0056](GITVIEW-SPEC-0056.yaml): Historical outcome selection — idea / pre_canonical
      - [GITVIEW-SPEC-0014](GITVIEW-SPEC-0014.yaml): Zoomable grid — idea / pre_canonical
        - [GITVIEW-SPEC-0015](GITVIEW-SPEC-0015.yaml): Peek and Pop and future sliding preview — idea / pre_canonical
          - [GITVIEW-SPEC-0031](GITVIEW-SPEC-0031.yaml): Preview identity and dismissal — idea / pre_canonical
            - [GITVIEW-SPEC-0050](GITVIEW-SPEC-0050.yaml): Compact preview content by object type — idea / pre_canonical
              - [GITVIEW-SPEC-0093](GITVIEW-SPEC-0093.yaml): First-version preview content and availability — idea / pre_canonical
        - [GITVIEW-SPEC-0035](GITVIEW-SPEC-0035.yaml): Density changes within an overview — idea / pre_canonical
          - [GITVIEW-SPEC-0075](GITVIEW-SPEC-0075.yaml): Grid gesture arbitration and interruption — idea / pre_canonical
      - [GITVIEW-SPEC-0024](GITVIEW-SPEC-0024.yaml): Navigation context and restoration — idea / pre_canonical
      - [GITVIEW-SPEC-0074](GITVIEW-SPEC-0074.yaml): Overview levels and scope transitions — idea / pre_canonical
        - [GITVIEW-SPEC-0091](GITVIEW-SPEC-0091.yaml): Work scope continuity as Project membership changes — idea / pre_canonical
        - [GITVIEW-SPEC-0120](GITVIEW-SPEC-0120.yaml): Targeted zoom across overview scopes — idea / pre_canonical
    - [GITVIEW-SPEC-0022](GITVIEW-SPEC-0022.yaml): First launch and project setup — idea / pre_canonical
      - [GITVIEW-SPEC-0045](GITVIEW-SPEC-0045.yaml): Confirm and recover repository selection — idea / pre_canonical
        - [GITVIEW-SPEC-0052](GITVIEW-SPEC-0052.yaml): Recover an interrupted default Project save — idea / pre_canonical
      - [GITVIEW-SPEC-0108](GITVIEW-SPEC-0108.yaml): Setup and Project creation route composition — idea / pre_canonical
    - [GITVIEW-SPEC-0023](GITVIEW-SPEC-0023.yaml): Project overview observation states — idea / pre_canonical
    - [GITVIEW-SPEC-0047](GITVIEW-SPEC-0047.yaml): Project overview and signal navigation — idea / pre_canonical
      - [GITVIEW-SPEC-0072](GITVIEW-SPEC-0072.yaml): Stable Project overview order and position — idea / pre_canonical
      - [GITVIEW-SPEC-0092](GITVIEW-SPEC-0092.yaml): Signal-origin selection and explicit filter changes — idea / pre_canonical
  - [GITVIEW-SPEC-0005](GITVIEW-SPEC-0005.yaml): Project composition and membership — idea / pre_canonical
    - [GITVIEW-SPEC-0025](GITVIEW-SPEC-0025.yaml): Project lifecycle and default association — idea / pre_canonical
      - [GITVIEW-SPEC-0082](GITVIEW-SPEC-0082.yaml): Concurrent Project edits and deletion — idea / pre_canonical
        - [GITVIEW-SPEC-0083](GITVIEW-SPEC-0083.yaml): Review and retry a conflicting Project edit — idea / pre_canonical
      - [GITVIEW-SPEC-0084](GITVIEW-SPEC-0084.yaml): Project membership lifecycle and evidence — idea / pre_canonical
        - [GITVIEW-SPEC-0111](GITVIEW-SPEC-0111.yaml): Project configuration validity decision — idea / pre_canonical
  - [GITVIEW-SPEC-0008](GITVIEW-SPEC-0008.yaml): Pull request overview — idea / pre_canonical
    - [GITVIEW-SPEC-0011](GITVIEW-SPEC-0011.yaml): Current checks and review signals — idea / pre_canonical
      - [GITVIEW-SPEC-0028](GITVIEW-SPEC-0028.yaml): PR check counters and independent review signals — idea / pre_canonical
        - [GITVIEW-SPEC-0060](GITVIEW-SPEC-0060.yaml): Current status-check entries and source context — idea / pre_canonical
          - [GITVIEW-SPEC-0061](GITVIEW-SPEC-0061.yaml): Status-check count categories — idea / pre_canonical
        - [GITVIEW-SPEC-0062](GITVIEW-SPEC-0062.yaml): Independent review attention conditions — idea / pre_canonical
          - [GITVIEW-SPEC-0094](GITVIEW-SPEC-0094.yaml): Unresolved review threads with an older observed comment — idea / pre_canonical
      - [GITVIEW-SPEC-0125](GITVIEW-SPEC-0125.yaml): Distinguish completed work and PR review stage — idea / pre_canonical
    - [GITVIEW-SPEC-0041](GITVIEW-SPEC-0041.yaml): PR overview facts and change counters — idea / pre_canonical
  - [GITVIEW-SPEC-0009](GITVIEW-SPEC-0009.yaml): Issue overview — idea / pre_canonical
    - [GITVIEW-SPEC-0039](GITVIEW-SPEC-0039.yaml): Issue state, links and discussion counters — idea / pre_canonical
      - [GITVIEW-SPEC-0063](GITVIEW-SPEC-0063.yaml): Blocked Issue attention and source access — idea / pre_canonical
      - [GITVIEW-SPEC-0077](GITVIEW-SPEC-0077.yaml): Issue discussion counts and latest comment time — idea / pre_canonical
      - [GITVIEW-SPEC-0078](GITVIEW-SPEC-0078.yaml): Issue links, hierarchy and partial access — idea / pre_canonical
  - [GITVIEW-SPEC-0010](GITVIEW-SPEC-0010.yaml): Issue and PR description formats — idea / pre_canonical
    - [GITVIEW-SPEC-0034](GITVIEW-SPEC-0034.yaml): Authored description sections and source text — idea / pre_canonical
      - [GITVIEW-SPEC-0051](GITVIEW-SPEC-0051.yaml): Conservative description section recognition — idea / pre_canonical
    - [GITVIEW-SPEC-0054](GITVIEW-SPEC-0054.yaml): Required Issue and PR description workflow — idea / pre_canonical
      - [GITVIEW-SPEC-0076](GITVIEW-SPEC-0076.yaml): Description conformance and revision lifecycle — idea / pre_canonical
        - [GITVIEW-SPEC-0090](GITVIEW-SPEC-0090.yaml): Required description process outcome and path coverage — idea / pre_canonical
  - [GITVIEW-SPEC-0012](GITVIEW-SPEC-0012.yaml): Repository and project summaries — idea / pre_canonical
    - [GITVIEW-SPEC-0029](GITVIEW-SPEC-0029.yaml): Scope and uniqueness of work summaries — idea / pre_canonical
      - [GITVIEW-SPEC-0046](GITVIEW-SPEC-0046.yaml): Aggregate counts with incomplete observations — idea / pre_canonical
        - [GITVIEW-SPEC-0119](GITVIEW-SPEC-0119.yaml): Scoped summary aggregation decision — idea / pre_canonical
  - [GITVIEW-SPEC-0013](GITVIEW-SPEC-0013.yaml): Metrics, history and charts — idea / pre_canonical
    - [GITVIEW-SPEC-0030](GITVIEW-SPEC-0030.yaml): Time series, coverage and observed outcomes — idea / pre_canonical
      - [GITVIEW-SPEC-0055](GITVIEW-SPEC-0055.yaml): Fixed PR cohort completion view — idea / pre_canonical
      - [GITVIEW-SPEC-0064](GITVIEW-SPEC-0064.yaml): Project membership basis for historical metrics — idea / pre_canonical
      - [GITVIEW-SPEC-0065](GITVIEW-SPEC-0065.yaml): Evidence for historical metric values — idea / pre_canonical
        - [GITVIEW-SPEC-0066](GITVIEW-SPEC-0066.yaml): Retained observations for metric history — idea / pre_canonical
          - [GITVIEW-SPEC-0067](GITVIEW-SPEC-0067.yaml): Clear and recover retained metric history — idea / pre_canonical
            - [GITVIEW-SPEC-0117](GITVIEW-SPEC-0117.yaml): Durable history clear and observation admission — idea / pre_canonical
          - [GITVIEW-SPEC-0097](GITVIEW-SPEC-0097.yaml): History for the agreed Project summary metrics — idea / pre_canonical
    - [GITVIEW-SPEC-0057](GITVIEW-SPEC-0057.yaml): Project metric catalog and coverage — idea / pre_canonical
    - [GITVIEW-SPEC-0068](GITVIEW-SPEC-0068.yaml): Metric history presentation and navigation — idea / pre_canonical
      - [GITVIEW-SPEC-0069](GITVIEW-SPEC-0069.yaml): Initial metric series and calendar periods — idea / pre_canonical
      - [GITVIEW-SPEC-0097](GITVIEW-SPEC-0097.yaml): History for the agreed Project summary metrics — тот же узел под другим родителем
      - [GITVIEW-SPEC-0118](GITVIEW-SPEC-0118.yaml): Accessible historical point inspection and return — idea / pre_canonical
  - [GITVIEW-SPEC-0016](GITVIEW-SPEC-0016.yaml): Original source and sharing — idea / pre_canonical
    - [GITVIEW-SPEC-0033](GITVIEW-SPEC-0033.yaml): Open and share the original source — idea / pre_canonical
      - [GITVIEW-SPEC-0121](GITVIEW-SPEC-0121.yaml): Source handoff admission and access ordering — idea / pre_canonical
  - [GITVIEW-SPEC-0017](GITVIEW-SPEC-0017.yaml): Accessibility and platform behavior — idea / pre_canonical
    - [GITVIEW-SPEC-0032](GITVIEW-SPEC-0032.yaml): Accessible grid and navigation — idea / pre_canonical
      - [GITVIEW-SPEC-0073](GITVIEW-SPEC-0073.yaml): Accessible focus during live overview updates — idea / pre_canonical
    - [GITVIEW-SPEC-0109](GITVIEW-SPEC-0109.yaml): Initial iOS platform and system interaction baseline — idea / pre_canonical
  - [GITVIEW-SPEC-0018](GITVIEW-SPEC-0018.yaml): Calendar overview and future depth — idea / pre_canonical
  - [GITVIEW-SPEC-0019](GITVIEW-SPEC-0019.yaml): GitHub access and repository discovery — idea / pre_canonical
    - [GITVIEW-SPEC-0036](GITVIEW-SPEC-0036.yaml): Connection state and restricted observations — idea / pre_canonical
      - [GITVIEW-SPEC-0112](GITVIEW-SPEC-0112.yaml): Repository access evidence applicability — idea / pre_canonical
    - [GITVIEW-SPEC-0058](GITVIEW-SPEC-0058.yaml): Authorization attempt and local connection lifecycle — idea / pre_canonical
      - [GITVIEW-SPEC-0085](GITVIEW-SPEC-0085.yaml): Credential expiry and connection recovery — idea / pre_canonical
        - [GITVIEW-SPEC-0086](GITVIEW-SPEC-0086.yaml): Credential replacement and interrupted secure storage — idea / pre_canonical
          - [GITVIEW-SPEC-0114](GITVIEW-SPEC-0114.yaml): Recoverable connection binding across local stores — idea / pre_canonical
    - [GITVIEW-SPEC-0059](GITVIEW-SPEC-0059.yaml): Repository discovery and selection continuity — idea / pre_canonical
      - [GITVIEW-SPEC-0099](GITVIEW-SPEC-0099.yaml): GitHub App installation scope in first setup — idea / pre_canonical
    - [GITVIEW-SPEC-0087](GITVIEW-SPEC-0087.yaml): Authorization selection and grant transparency — idea / pre_canonical
      - [GITVIEW-SPEC-0088](GITVIEW-SPEC-0088.yaml): Partial source capabilities and overview coverage — idea / pre_canonical
        - [GITVIEW-SPEC-0100](GITVIEW-SPEC-0100.yaml): GitHub App read-permission coverage for selected data — idea / pre_canonical
      - [GITVIEW-SPEC-0098](GITVIEW-SPEC-0098.yaml): GitHub App public-client authorization and renewal — idea / pre_canonical
  - [GITVIEW-SPEC-0020](GITVIEW-SPEC-0020.yaml): Pilot end-to-end acceptance — idea / pre_canonical
    - [GITVIEW-SPEC-0043](GITVIEW-SPEC-0043.yaml): Cross-branch overview and recovery scenarios — idea / pre_canonical
  - [GITVIEW-SPEC-0021](GITVIEW-SPEC-0021.yaml): Pilot architecture and decision boundaries — idea / pre_canonical
    - [GITVIEW-SPEC-0040](GITVIEW-SPEC-0040.yaml): Testable behavior and injected dependencies — idea / pre_canonical
      - [GITVIEW-SPEC-0070](GITVIEW-SPEC-0070.yaml): Verification of metric history behavior — idea / pre_canonical
      - [GITVIEW-SPEC-0079](GITVIEW-SPEC-0079.yaml): Cross-cutting verification applicability — idea / pre_canonical
    - [GITVIEW-SPEC-0095](GITVIEW-SPEC-0095.yaml): Architecture boundaries for overview decisions — idea / pre_canonical
      - [GITVIEW-SPEC-0096](GITVIEW-SPEC-0096.yaml): Project work journey composition and contracts — idea / pre_canonical
        - [GITVIEW-SPEC-0107](GITVIEW-SPEC-0107.yaml): Initial FSD ownership for Project work data — idea / pre_canonical
          - [GITVIEW-SPEC-0115](GITVIEW-SPEC-0115.yaml): Project Today inspection route assembly — idea / pre_canonical
      - [GITVIEW-SPEC-0106](GITVIEW-SPEC-0106.yaml): Logical local data composition and commit boundaries — idea / pre_canonical
        - [GITVIEW-SPEC-0113](GITVIEW-SPEC-0113.yaml): Local transactional storage direction — idea / pre_canonical
          - [GITVIEW-SPEC-0122](GITVIEW-SPEC-0122.yaml): Local store schema evolution and recovery — idea / pre_canonical

## Прямые зависимости

| Кандидат | `depends_on` |
| --- | --- |
| [0001](GITVIEW-SPEC-0001.yaml) | — |
| [0002](GITVIEW-SPEC-0002.yaml) | — |
| [0003](GITVIEW-SPEC-0003.yaml) | [0002](GITVIEW-SPEC-0002.yaml) |
| [0004](GITVIEW-SPEC-0004.yaml) | [0003](GITVIEW-SPEC-0003.yaml) |
| [0005](GITVIEW-SPEC-0005.yaml) | [0002](GITVIEW-SPEC-0002.yaml) |
| [0006](GITVIEW-SPEC-0006.yaml) | [0005](GITVIEW-SPEC-0005.yaml) |
| [0007](GITVIEW-SPEC-0007.yaml) | [0003](GITVIEW-SPEC-0003.yaml), [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml) |
| [0008](GITVIEW-SPEC-0008.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml) |
| [0009](GITVIEW-SPEC-0009.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml) |
| [0010](GITVIEW-SPEC-0010.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml) |
| [0011](GITVIEW-SPEC-0011.yaml) | [0003](GITVIEW-SPEC-0003.yaml) |
| [0012](GITVIEW-SPEC-0012.yaml) | [0003](GITVIEW-SPEC-0003.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml), [0011](GITVIEW-SPEC-0011.yaml) |
| [0013](GITVIEW-SPEC-0013.yaml) | [0003](GITVIEW-SPEC-0003.yaml), [0012](GITVIEW-SPEC-0012.yaml) |
| [0014](GITVIEW-SPEC-0014.yaml) | [0007](GITVIEW-SPEC-0007.yaml) |
| [0015](GITVIEW-SPEC-0015.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml) |
| [0016](GITVIEW-SPEC-0016.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml) |
| [0017](GITVIEW-SPEC-0017.yaml) | [0014](GITVIEW-SPEC-0014.yaml), [0015](GITVIEW-SPEC-0015.yaml), [0016](GITVIEW-SPEC-0016.yaml) |
| [0018](GITVIEW-SPEC-0018.yaml) | [0013](GITVIEW-SPEC-0013.yaml), [0014](GITVIEW-SPEC-0014.yaml) |
| [0019](GITVIEW-SPEC-0019.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml), [0005](GITVIEW-SPEC-0005.yaml) |
| [0020](GITVIEW-SPEC-0020.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml), [0004](GITVIEW-SPEC-0004.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0006](GITVIEW-SPEC-0006.yaml), [0007](GITVIEW-SPEC-0007.yaml), [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml), [0010](GITVIEW-SPEC-0010.yaml), [0011](GITVIEW-SPEC-0011.yaml), [0012](GITVIEW-SPEC-0012.yaml), [0013](GITVIEW-SPEC-0013.yaml), [0014](GITVIEW-SPEC-0014.yaml), [0015](GITVIEW-SPEC-0015.yaml), [0016](GITVIEW-SPEC-0016.yaml), [0017](GITVIEW-SPEC-0017.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0021](GITVIEW-SPEC-0021.yaml) |
| [0021](GITVIEW-SPEC-0021.yaml) | [0003](GITVIEW-SPEC-0003.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0007](GITVIEW-SPEC-0007.yaml), [0011](GITVIEW-SPEC-0011.yaml), [0019](GITVIEW-SPEC-0019.yaml) |
| [0022](GITVIEW-SPEC-0022.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0025](GITVIEW-SPEC-0025.yaml) |
| [0023](GITVIEW-SPEC-0023.yaml) | [0003](GITVIEW-SPEC-0003.yaml), [0012](GITVIEW-SPEC-0012.yaml), [0017](GITVIEW-SPEC-0017.yaml), [0019](GITVIEW-SPEC-0019.yaml) |
| [0024](GITVIEW-SPEC-0024.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0007](GITVIEW-SPEC-0007.yaml), [0014](GITVIEW-SPEC-0014.yaml), [0017](GITVIEW-SPEC-0017.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0036](GITVIEW-SPEC-0036.yaml) |
| [0025](GITVIEW-SPEC-0025.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0019](GITVIEW-SPEC-0019.yaml) |
| [0026](GITVIEW-SPEC-0026.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0019](GITVIEW-SPEC-0019.yaml) |
| [0027](GITVIEW-SPEC-0027.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0028](GITVIEW-SPEC-0028.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0012](GITVIEW-SPEC-0012.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0026](GITVIEW-SPEC-0026.yaml) |
| [0029](GITVIEW-SPEC-0029.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0011](GITVIEW-SPEC-0011.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0027](GITVIEW-SPEC-0027.yaml) |
| [0030](GITVIEW-SPEC-0030.yaml) | [0007](GITVIEW-SPEC-0007.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0029](GITVIEW-SPEC-0029.yaml) |
| [0031](GITVIEW-SPEC-0031.yaml) | [0017](GITVIEW-SPEC-0017.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml) |
| [0032](GITVIEW-SPEC-0032.yaml) | [0014](GITVIEW-SPEC-0014.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0031](GITVIEW-SPEC-0031.yaml) |
| [0033](GITVIEW-SPEC-0033.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0019](GITVIEW-SPEC-0019.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0034](GITVIEW-SPEC-0034.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml), [0011](GITVIEW-SPEC-0011.yaml), [0026](GITVIEW-SPEC-0026.yaml) |
| [0035](GITVIEW-SPEC-0035.yaml) | [0007](GITVIEW-SPEC-0007.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0032](GITVIEW-SPEC-0032.yaml) |
| [0036](GITVIEW-SPEC-0036.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0003](GITVIEW-SPEC-0003.yaml) |
| [0037](GITVIEW-SPEC-0037.yaml) | [0036](GITVIEW-SPEC-0036.yaml) |
| [0038](GITVIEW-SPEC-0038.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml) |
| [0039](GITVIEW-SPEC-0039.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0034](GITVIEW-SPEC-0034.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0040](GITVIEW-SPEC-0040.yaml) | [0007](GITVIEW-SPEC-0007.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0036](GITVIEW-SPEC-0036.yaml) |
| [0041](GITVIEW-SPEC-0041.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0034](GITVIEW-SPEC-0034.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0042](GITVIEW-SPEC-0042.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0061](GITVIEW-SPEC-0061.yaml) |
| [0043](GITVIEW-SPEC-0043.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0054](GITVIEW-SPEC-0054.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0059](GITVIEW-SPEC-0059.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0070](GITVIEW-SPEC-0070.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0072](GITVIEW-SPEC-0072.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0074](GITVIEW-SPEC-0074.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0076](GITVIEW-SPEC-0076.yaml), [0077](GITVIEW-SPEC-0077.yaml), [0078](GITVIEW-SPEC-0078.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0080](GITVIEW-SPEC-0080.yaml), [0081](GITVIEW-SPEC-0081.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0083](GITVIEW-SPEC-0083.yaml), [0084](GITVIEW-SPEC-0084.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0086](GITVIEW-SPEC-0086.yaml), [0087](GITVIEW-SPEC-0087.yaml), [0088](GITVIEW-SPEC-0088.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0090](GITVIEW-SPEC-0090.yaml), [0091](GITVIEW-SPEC-0091.yaml), [0092](GITVIEW-SPEC-0092.yaml), [0093](GITVIEW-SPEC-0093.yaml), [0094](GITVIEW-SPEC-0094.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0099](GITVIEW-SPEC-0099.yaml), [0100](GITVIEW-SPEC-0100.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0108](GITVIEW-SPEC-0108.yaml), [0109](GITVIEW-SPEC-0109.yaml), [0110](GITVIEW-SPEC-0110.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0115](GITVIEW-SPEC-0115.yaml), [0117](GITVIEW-SPEC-0117.yaml), [0118](GITVIEW-SPEC-0118.yaml), [0119](GITVIEW-SPEC-0119.yaml), [0120](GITVIEW-SPEC-0120.yaml), [0121](GITVIEW-SPEC-0121.yaml), [0122](GITVIEW-SPEC-0122.yaml), [0124](GITVIEW-SPEC-0124.yaml), [0125](GITVIEW-SPEC-0125.yaml), [0126](GITVIEW-SPEC-0126.yaml) |
| [0044](GITVIEW-SPEC-0044.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml) |
| [0045](GITVIEW-SPEC-0045.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml) |
| [0046](GITVIEW-SPEC-0046.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0030](GITVIEW-SPEC-0030.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0047](GITVIEW-SPEC-0047.yaml) | [0005](GITVIEW-SPEC-0005.yaml), [0006](GITVIEW-SPEC-0006.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0035](GITVIEW-SPEC-0035.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml) |
| [0048](GITVIEW-SPEC-0048.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0049](GITVIEW-SPEC-0049.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0050](GITVIEW-SPEC-0050.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0047](GITVIEW-SPEC-0047.yaml) |
| [0051](GITVIEW-SPEC-0051.yaml) | [0026](GITVIEW-SPEC-0026.yaml) |
| [0052](GITVIEW-SPEC-0052.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml) |
| [0053](GITVIEW-SPEC-0053.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0054](GITVIEW-SPEC-0054.yaml) | [0008](GITVIEW-SPEC-0008.yaml), [0009](GITVIEW-SPEC-0009.yaml) |
| [0055](GITVIEW-SPEC-0055.yaml) | [0007](GITVIEW-SPEC-0007.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0049](GITVIEW-SPEC-0049.yaml) |
| [0056](GITVIEW-SPEC-0056.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0030](GITVIEW-SPEC-0030.yaml), [0044](GITVIEW-SPEC-0044.yaml) |
| [0057](GITVIEW-SPEC-0057.yaml) | [0028](GITVIEW-SPEC-0028.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0030](GITVIEW-SPEC-0030.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml) |
| [0058](GITVIEW-SPEC-0058.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml) |
| [0059](GITVIEW-SPEC-0059.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0058](GITVIEW-SPEC-0058.yaml) |
| [0060](GITVIEW-SPEC-0060.yaml) | [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml) |
| [0061](GITVIEW-SPEC-0061.yaml) | [0028](GITVIEW-SPEC-0028.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0062](GITVIEW-SPEC-0062.yaml) | [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0063](GITVIEW-SPEC-0063.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml) |
| [0064](GITVIEW-SPEC-0064.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml) |
| [0065](GITVIEW-SPEC-0065.yaml) | [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0064](GITVIEW-SPEC-0064.yaml) |
| [0066](GITVIEW-SPEC-0066.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0064](GITVIEW-SPEC-0064.yaml) |
| [0067](GITVIEW-SPEC-0067.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0068](GITVIEW-SPEC-0068.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0030](GITVIEW-SPEC-0030.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0047](GITVIEW-SPEC-0047.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0102](GITVIEW-SPEC-0102.yaml) |
| [0069](GITVIEW-SPEC-0069.yaml) | [0030](GITVIEW-SPEC-0030.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0066](GITVIEW-SPEC-0066.yaml) |
| [0070](GITVIEW-SPEC-0070.yaml) | [0030](GITVIEW-SPEC-0030.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0068](GITVIEW-SPEC-0068.yaml), [0069](GITVIEW-SPEC-0069.yaml), [0102](GITVIEW-SPEC-0102.yaml) |
| [0071](GITVIEW-SPEC-0071.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0067](GITVIEW-SPEC-0067.yaml) |
| [0072](GITVIEW-SPEC-0072.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml) |
| [0073](GITVIEW-SPEC-0073.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0072](GITVIEW-SPEC-0072.yaml) |
| [0074](GITVIEW-SPEC-0074.yaml) | [0004](GITVIEW-SPEC-0004.yaml), [0005](GITVIEW-SPEC-0005.yaml), [0014](GITVIEW-SPEC-0014.yaml), [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0035](GITVIEW-SPEC-0035.yaml), [0047](GITVIEW-SPEC-0047.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0072](GITVIEW-SPEC-0072.yaml), [0073](GITVIEW-SPEC-0073.yaml) |
| [0075](GITVIEW-SPEC-0075.yaml) | [0015](GITVIEW-SPEC-0015.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0073](GITVIEW-SPEC-0073.yaml) |
| [0076](GITVIEW-SPEC-0076.yaml) | [0034](GITVIEW-SPEC-0034.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0051](GITVIEW-SPEC-0051.yaml) |
| [0077](GITVIEW-SPEC-0077.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0078](GITVIEW-SPEC-0078.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0079](GITVIEW-SPEC-0079.yaml) | [0017](GITVIEW-SPEC-0017.yaml), [0032](GITVIEW-SPEC-0032.yaml) |
| [0080](GITVIEW-SPEC-0080.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0081](GITVIEW-SPEC-0081.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml) |
| [0082](GITVIEW-SPEC-0082.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml) |
| [0083](GITVIEW-SPEC-0083.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0052](GITVIEW-SPEC-0052.yaml) |
| [0084](GITVIEW-SPEC-0084.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0083](GITVIEW-SPEC-0083.yaml) |
| [0085](GITVIEW-SPEC-0085.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0059](GITVIEW-SPEC-0059.yaml) |
| [0086](GITVIEW-SPEC-0086.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0059](GITVIEW-SPEC-0059.yaml) |
| [0087](GITVIEW-SPEC-0087.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0059](GITVIEW-SPEC-0059.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0086](GITVIEW-SPEC-0086.yaml) |
| [0088](GITVIEW-SPEC-0088.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0059](GITVIEW-SPEC-0059.yaml) |
| [0089](GITVIEW-SPEC-0089.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0060](GITVIEW-SPEC-0060.yaml), [0061](GITVIEW-SPEC-0061.yaml) |
| [0090](GITVIEW-SPEC-0090.yaml) | [0034](GITVIEW-SPEC-0034.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0051](GITVIEW-SPEC-0051.yaml), [0054](GITVIEW-SPEC-0054.yaml) |
| [0091](GITVIEW-SPEC-0091.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0084](GITVIEW-SPEC-0084.yaml) |
| [0092](GITVIEW-SPEC-0092.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0074](GITVIEW-SPEC-0074.yaml), [0088](GITVIEW-SPEC-0088.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0091](GITVIEW-SPEC-0091.yaml), [0094](GITVIEW-SPEC-0094.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0119](GITVIEW-SPEC-0119.yaml) |
| [0093](GITVIEW-SPEC-0093.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0028](GITVIEW-SPEC-0028.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0034](GITVIEW-SPEC-0034.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0047](GITVIEW-SPEC-0047.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0112](GITVIEW-SPEC-0112.yaml) |
| [0094](GITVIEW-SPEC-0094.yaml) | [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0047](GITVIEW-SPEC-0047.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0089](GITVIEW-SPEC-0089.yaml) |
| [0095](GITVIEW-SPEC-0095.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0079](GITVIEW-SPEC-0079.yaml) |
| [0096](GITVIEW-SPEC-0096.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0027](GITVIEW-SPEC-0027.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0047](GITVIEW-SPEC-0047.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0074](GITVIEW-SPEC-0074.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0091](GITVIEW-SPEC-0091.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0100](GITVIEW-SPEC-0100.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml) |
| [0097](GITVIEW-SPEC-0097.yaml) | [0102](GITVIEW-SPEC-0102.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0046](GITVIEW-SPEC-0046.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0069](GITVIEW-SPEC-0069.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0094](GITVIEW-SPEC-0094.yaml) |
| [0098](GITVIEW-SPEC-0098.yaml) | [0019](GITVIEW-SPEC-0019.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0059](GITVIEW-SPEC-0059.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0086](GITVIEW-SPEC-0086.yaml), [0088](GITVIEW-SPEC-0088.yaml) |
| [0099](GITVIEW-SPEC-0099.yaml) | [0022](GITVIEW-SPEC-0022.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0087](GITVIEW-SPEC-0087.yaml), [0088](GITVIEW-SPEC-0088.yaml), [0098](GITVIEW-SPEC-0098.yaml) |
| [0100](GITVIEW-SPEC-0100.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0060](GITVIEW-SPEC-0060.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0063](GITVIEW-SPEC-0063.yaml), [0077](GITVIEW-SPEC-0077.yaml), [0078](GITVIEW-SPEC-0078.yaml), [0094](GITVIEW-SPEC-0094.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0099](GITVIEW-SPEC-0099.yaml) |
| [0101](GITVIEW-SPEC-0101.yaml) | [0002](GITVIEW-SPEC-0002.yaml), [0026](GITVIEW-SPEC-0026.yaml), [0029](GITVIEW-SPEC-0029.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0100](GITVIEW-SPEC-0100.yaml) |
| [0102](GITVIEW-SPEC-0102.yaml) | [0027](GITVIEW-SPEC-0027.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0101](GITVIEW-SPEC-0101.yaml) |
| [0103](GITVIEW-SPEC-0103.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0083](GITVIEW-SPEC-0083.yaml), [0102](GITVIEW-SPEC-0102.yaml) |
| [0104](GITVIEW-SPEC-0104.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0083](GITVIEW-SPEC-0083.yaml), [0095](GITVIEW-SPEC-0095.yaml) |
| [0105](GITVIEW-SPEC-0105.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0095](GITVIEW-SPEC-0095.yaml), [0097](GITVIEW-SPEC-0097.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml) |
| [0106](GITVIEW-SPEC-0106.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0096](GITVIEW-SPEC-0096.yaml), [0097](GITVIEW-SPEC-0097.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0105](GITVIEW-SPEC-0105.yaml) |
| [0107](GITVIEW-SPEC-0107.yaml) | [0021](GITVIEW-SPEC-0021.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0095](GITVIEW-SPEC-0095.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0100](GITVIEW-SPEC-0100.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0105](GITVIEW-SPEC-0105.yaml), [0106](GITVIEW-SPEC-0106.yaml) |
| [0108](GITVIEW-SPEC-0108.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0059](GITVIEW-SPEC-0059.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0099](GITVIEW-SPEC-0099.yaml), [0100](GITVIEW-SPEC-0100.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0105](GITVIEW-SPEC-0105.yaml), [0106](GITVIEW-SPEC-0106.yaml), [0107](GITVIEW-SPEC-0107.yaml), [0111](GITVIEW-SPEC-0111.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0122](GITVIEW-SPEC-0122.yaml) |
| [0109](GITVIEW-SPEC-0109.yaml) | [0014](GITVIEW-SPEC-0014.yaml), [0024](GITVIEW-SPEC-0024.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0033](GITVIEW-SPEC-0033.yaml), [0035](GITVIEW-SPEC-0035.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0068](GITVIEW-SPEC-0068.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0093](GITVIEW-SPEC-0093.yaml), [0107](GITVIEW-SPEC-0107.yaml) |
| [0110](GITVIEW-SPEC-0110.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0107](GITVIEW-SPEC-0107.yaml) |
| [0111](GITVIEW-SPEC-0111.yaml) | [0025](GITVIEW-SPEC-0025.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0082](GITVIEW-SPEC-0082.yaml), [0083](GITVIEW-SPEC-0083.yaml), [0095](GITVIEW-SPEC-0095.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0106](GITVIEW-SPEC-0106.yaml) |
| [0112](GITVIEW-SPEC-0112.yaml) | [0037](GITVIEW-SPEC-0037.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0059](GITVIEW-SPEC-0059.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0111](GITVIEW-SPEC-0111.yaml) |
| [0113](GITVIEW-SPEC-0113.yaml) | [0019](GITVIEW-SPEC-0019.yaml), [0045](GITVIEW-SPEC-0045.yaml), [0052](GITVIEW-SPEC-0052.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0086](GITVIEW-SPEC-0086.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0105](GITVIEW-SPEC-0105.yaml), [0112](GITVIEW-SPEC-0112.yaml) |
| [0114](GITVIEW-SPEC-0114.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0058](GITVIEW-SPEC-0058.yaml), [0085](GITVIEW-SPEC-0085.yaml), [0098](GITVIEW-SPEC-0098.yaml), [0113](GITVIEW-SPEC-0113.yaml) |
| [0115](GITVIEW-SPEC-0115.yaml) | [0033](GITVIEW-SPEC-0033.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0074](GITVIEW-SPEC-0074.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0091](GITVIEW-SPEC-0091.yaml), [0092](GITVIEW-SPEC-0092.yaml), [0093](GITVIEW-SPEC-0093.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0108](GITVIEW-SPEC-0108.yaml), [0109](GITVIEW-SPEC-0109.yaml), [0110](GITVIEW-SPEC-0110.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0116](GITVIEW-SPEC-0116.yaml), [0119](GITVIEW-SPEC-0119.yaml), [0123](GITVIEW-SPEC-0123.yaml), [0126](GITVIEW-SPEC-0126.yaml) |
| [0116](GITVIEW-SPEC-0116.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0048](GITVIEW-SPEC-0048.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0110](GITVIEW-SPEC-0110.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0113](GITVIEW-SPEC-0113.yaml) |
| [0117](GITVIEW-SPEC-0117.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0066](GITVIEW-SPEC-0066.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0097](GITVIEW-SPEC-0097.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0105](GITVIEW-SPEC-0105.yaml), [0113](GITVIEW-SPEC-0113.yaml) |
| [0118](GITVIEW-SPEC-0118.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0056](GITVIEW-SPEC-0056.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml), [0067](GITVIEW-SPEC-0067.yaml), [0069](GITVIEW-SPEC-0069.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0092](GITVIEW-SPEC-0092.yaml), [0097](GITVIEW-SPEC-0097.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0116](GITVIEW-SPEC-0116.yaml) |
| [0119](GITVIEW-SPEC-0119.yaml) | [0029](GITVIEW-SPEC-0029.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0040](GITVIEW-SPEC-0040.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0064](GITVIEW-SPEC-0064.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0110](GITVIEW-SPEC-0110.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0116](GITVIEW-SPEC-0116.yaml) |
| [0120](GITVIEW-SPEC-0120.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0031](GITVIEW-SPEC-0031.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0035](GITVIEW-SPEC-0035.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0049](GITVIEW-SPEC-0049.yaml), [0073](GITVIEW-SPEC-0073.yaml), [0075](GITVIEW-SPEC-0075.yaml), [0091](GITVIEW-SPEC-0091.yaml), [0115](GITVIEW-SPEC-0115.yaml) |
| [0121](GITVIEW-SPEC-0121.yaml) | [0024](GITVIEW-SPEC-0024.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0037](GITVIEW-SPEC-0037.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0081](GITVIEW-SPEC-0081.yaml), [0112](GITVIEW-SPEC-0112.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0115](GITVIEW-SPEC-0115.yaml) |
| [0122](GITVIEW-SPEC-0122.yaml) | [0023](GITVIEW-SPEC-0023.yaml), [0036](GITVIEW-SPEC-0036.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0104](GITVIEW-SPEC-0104.yaml), [0105](GITVIEW-SPEC-0105.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0117](GITVIEW-SPEC-0117.yaml) |
| [0123](GITVIEW-SPEC-0123.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0038](GITVIEW-SPEC-0038.yaml), [0044](GITVIEW-SPEC-0044.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0071](GITVIEW-SPEC-0071.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0116](GITVIEW-SPEC-0116.yaml), [0117](GITVIEW-SPEC-0117.yaml), [0122](GITVIEW-SPEC-0122.yaml) |
| [0124](GITVIEW-SPEC-0124.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0079](GITVIEW-SPEC-0079.yaml), [0101](GITVIEW-SPEC-0101.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0122](GITVIEW-SPEC-0122.yaml) |
| [0125](GITVIEW-SPEC-0125.yaml) | [0027](GITVIEW-SPEC-0027.yaml), [0032](GITVIEW-SPEC-0032.yaml), [0039](GITVIEW-SPEC-0039.yaml), [0041](GITVIEW-SPEC-0041.yaml), [0042](GITVIEW-SPEC-0042.yaml), [0057](GITVIEW-SPEC-0057.yaml), [0061](GITVIEW-SPEC-0061.yaml), [0062](GITVIEW-SPEC-0062.yaml), [0089](GITVIEW-SPEC-0089.yaml), [0092](GITVIEW-SPEC-0092.yaml), [0110](GITVIEW-SPEC-0110.yaml), [0119](GITVIEW-SPEC-0119.yaml) |
| [0126](GITVIEW-SPEC-0126.yaml) | [0036](GITVIEW-SPEC-0036.yaml), [0053](GITVIEW-SPEC-0053.yaml), [0102](GITVIEW-SPEC-0102.yaml), [0103](GITVIEW-SPEC-0103.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0116](GITVIEW-SPEC-0116.yaml), [0122](GITVIEW-SPEC-0122.yaml), [0123](GITVIEW-SPEC-0123.yaml), [0124](GITVIEW-SPEC-0124.yaml) |

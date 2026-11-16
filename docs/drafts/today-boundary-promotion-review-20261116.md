# Today day boundary: outlined node

Baseline `eda2114`; predecessor `docs/drafts/GITVIEW-SPEC-0049.yaml` at `33fb739`. The node follows the owner-selected user local day, previously unfinished work, current-day completion and persistent filters. Exact time-zone source, interval mechanics, native reordering and background timing remain open; the node is not implementation-ready.

Independent read-only first-draft review checked SHA `c84373e509e1ecf05a6e1ca4f9287d9ec593ec15a4f57106f7e034bee15f38a3` against 0007/0019/0024/0027/0031/0042 and the owner decisions. No direct contradiction was found. The reviewer suggested making the saved-filter scenario concrete; the author added a saved merged exclusion across the day change while keeping an unsaved change distinct. Focused rereview confirmed final SHA `7944b339af868488257a96e0508fae097eef2db5351b3af8fd1c4c05ec962551` and found the clarification sound.

A byte-identical temporary candidate returned `checked`; target next-move and YAML lint passed. These checks do not prove source completeness, actual clock behavior or native interaction. The ontology compiler digest mismatch is recorded in the 0AL ledger; no fresh composition verification is claimed.

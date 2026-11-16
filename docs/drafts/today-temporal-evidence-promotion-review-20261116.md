# Temporal context of Today and filters: outlined node

Baseline `bde6608`. Node 0089 refines the selected local-day Today and persistent-filter behavior without choosing a universal freshness duration, source strategy or additional inclusion alternatives. Ontology vocabulary remains draft.

Independent read-only first-draft review of SHA `14ea529f403e980e06b568f24ad5e2706e3009b84c249369d47b7ea6e3041ed2` found that event time and observation time must be preserved independently when supported, including for an event received after the local day changes. The author corrected the requirement and added the late-event scenario; focused rereview confirmed final SHA `644b9eb56fbd5ddffc7def711f8fefc6bffdd9384145fbb76b119bf418f538c9` without further findings in scope.

A byte-identical candidate returned `checked`; target next-move and runtime YAML lint passed. Text and structural review does not establish actual source coverage, native presentation, ontology acceptance or implementation readiness.

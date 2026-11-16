# Today selection and uncertainty: outlined node

Baseline `d8e91c9`; predecessor `docs/drafts/GITVIEW-SPEC-0027.yaml`; canonical owner decisions in 0007, 0019 and 0047. The node refines product-visible handling of incomplete Today data and filters. Additional inclusion conditions, source queries and native uncertainty presentation remain open; `outlined` is not implementation readiness.

Independent first-draft read-only review checked SHA `f78e37da8a5f28637e8d0995074f6647807ace3964c2de4b02472fe4ba020b27`. It identified a concrete mismatch: a true inclusion alternative cannot make the whole selection a confirmed match while a required active filter is unknown. It also noted the one-cell rule applies to included objects and the historical counter relationship needed an explicit graph edge. The author corrected these points; focused rereview confirmed final SHA `fee595ac67339e68619ef2ff5fdf0eef86c6d4ae4854c5ee372b511a13865eb7` and found the findings closed.

A byte-identical temporary candidate returned `checked`; `next-move --target-spec` and YAML lint passed. These do not prove source availability, native behavior or implementation readiness.

# Testability and injected dependencies: outlined node

Baseline `1e23c95`. Node 0040 refines owner-requested testability, DI, TDD and network/data test doubles without choosing a framework, wiring or claiming implementation. Ontology vocabulary remains draft; the pinned compiler mismatch is recorded in the 0AL ledger.

Independent read-only first-draft review of SHA `154e523548777c11699c1f3fe59d2c6203483e119fdea50a7ab2b8e7bce8137e` found that unknown CI need not determine a composite filter when another condition is independently false, that pure decision evaluation must explicitly exclude network and persistence I/O, and that acceptance should state the TDD sequence. The author corrected all three; focused rereview confirmed final SHA `b7abe30e003410f9458c077869c128ca11bbde157c7f1a09a5c62bf6ab22ed6d` and found no further issue within that scope.

The byte-identical candidate returned `checked`; target next-move and YAML lint passed. These checks do not establish implemented tests, actual GitHub compatibility, ontology composition validity or implementation readiness.

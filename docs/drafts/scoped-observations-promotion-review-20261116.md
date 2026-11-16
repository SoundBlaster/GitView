# Scoped observations and partial refresh: outlined node

Baseline `4b5f381`; predecessor `docs/drafts/GITVIEW-SPEC-0026.yaml`, owner root intent and local data decision in 0019. The outlined node specifies scope, supported time, incomplete coverage, failed refresh and the result of confirmed revocation without selecting GitHub operations or implementation. It is not a claim of implementation readiness.

Independent first-draft read-only review checked SHA `fe249c49169c318dee0bfe23b5efd80538a5a0c6f298fbeee99bbf8ccc0865d2` against 0002/0003/0019/0023, predecessor and owner source. It found that the acceptance text could incorrectly forbid the supported observation time of a successfully refreshed part when a wider refresh is partial, and that the failure requirement lacked the `when known` qualification for saved time. The author distinguished the successful part from the last complete wider observation and prohibited inventing missing times. Focused rereview confirmed final SHA `a03d4ecae11e7b1621b15b5cc475458552eb665866334a901d26c44c493a9ef7` and reported both findings closed.

The byte-identical temporary candidate returned `checked`; `next-move --target-spec` and YAML lint passed. These checks do not prove source availability, native behavior, or implementation readiness.

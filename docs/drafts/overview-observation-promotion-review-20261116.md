# Overview observation states: outlined graph node

Baseline `9bbf79f`. The owner decisions and rationale are recorded in SpecDraft revision `ef1c2f72ef08420980a423cd63c6d34a`; the existing explicit revocation decision is in canonical 0019. The new 0023 node refines the main overview with product-visible empty, unreadable, incomplete, failed and last-known states, and retains available local data and recovery or explicit deletion after confirmed private Repository revocation. This is an outlined node, not implementation readiness. Native presentation, source evidence and other account cases remain open.

An independent first-draft read-only review compared 0023 SHA `a32aaf048af225d119084601c87076975a07f81040198997e2717e245ccd4aeb` to its predecessor, parents and owner source. No blocking contradiction was found. The reviewer suggested explicitly making displayed values and state available to assistive technology; the author adopted it and focused rereview confirmed final SHA `bc2dbc699428125a8bf3ba498f9b2f8f8f6f8a53b70c028a53ae1f05d5a4bbe7`.

Separately, canonical 0019 records the owner's reason for maintaining a discoverable local entry point to recovery or intentional local deletion. Independent review found no contradiction on SHA `06552fdc3e31c37a9ce76ae17529be4d0ee5abfe38d879c85e782cb2f1a60c26`. The only subsequent edit added the owner source reference; focused rereview confirmed it and final SHA `8303c18a59eeb31a0363df0512797f068148ca8f65e7b993a1f1e36459127258`.

Byte-identical temporary candidate copies passed `next-move --candidate-file`; target checks and standalone YAML lint passed for both nodes. Candidate `checked` is a structural result, not semantic acceptance, device verification or evidence of implementation.

# Accessibility and retained private data: correction review

Baseline `9090580`, node 0017 SHA `382ccee24cfeb4029a18c69772303bffc498d201f6b31a253caea9ec646e9881`. The root accessibility requirement's generic restricted-disclosure wording could be read as hiding saved local information after confirmed GitHub revocation, contrary to owner-selected behavior under 0019. The correction adds the explicit 0019 dependency, preserves saved data visually and for assistive technology, and adds a revocation scenario without selecting other account-disclosure policies.

Independent read-only correction review of initial revised SHA `d896a08a236365d8f296c0609198168ddac807d54e7a4deafdf3954c5c0ff2e1` found no blocking contradiction and suggested making both recovery and explicit deletion routes clear. The author clarified both without promising recovery succeeds; focused rereview confirmed final SHA `b45dd6752d81c1281a5b6c6833efd9ad947240489329a9e2d859caaf731d549c` without further findings in scope. The reviewer found no `depends_on` return path from 0019 to 0017.

A byte-identical candidate returned `checked`; target next-move and runtime YAML lint passed. Semantic review does not establish actual device accessibility, source behavior or ontology acceptance.

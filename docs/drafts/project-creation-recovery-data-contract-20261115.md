# Project creation: logical records and recovery

Status: agent-authored design candidate for 0045, 0052, 0103–0104, 0113 and
0122–0123. It refines their existing obligations without asserting a physical
SQLite schema, selecting a Swift adapter, implementing a store, or proving
crash durability. All referenced specifications remain pre-canonical.

## Logical records

These are storage responsibilities, not new product ontology entities. A
physical schema may divide or combine records if it preserves the constraints.

| Record | Minimum supported content | Constraints and privacy |
| --- | --- | --- |
| Confirmed Repository reference | Stable local reference, source instance, identifier kind and exact source identity; separately supported aliases where available. | One reference per confirmed scoped numeric identity under 0123; name and URL are not keys. Unresolved selection evidence is not a confirmed reference. |
| Project configuration | Stable local Project identity, valid name, optional purpose, non-reused version token, creation order and nonempty distinct member references. | One consistent configuration per version; different Projects may share members. A revision is not a source timestamp. |
| Default association | Confirmed Repository reference and current member Project identity. | At most one active default per Repository; the referenced membership must exist. Removal or editing must not leave a dangling active association. |
| Confirmed batch and entry | Stable batch and entry identities, non-secret initiating account context, active/cancelled fence and enough supported selection and per-entry processing evidence for recovery. | Durable before submitting its entries. Unresolved identity stays unresolved; distinct entries can later resolve to the same Repository without losing their provenance. Never store credentials or require source text in the batch record. |
| Logical operation | Unique operation identity, kind, target and immutable reviewed intent or a recoverable binding sufficient to determine exact compatible redelivery, preconditions, and terminal result if established. | Separate intentional custom creations remain separate even for identical content. An indeterminate outcome is not a terminal failure. A changed intent cannot reuse an identity. |
| Operation outcome | Attribution to the operation and one established applied/created/reused/rejected/conflict result, including the identity and context needed to interpret it. | An applied result and its effect, or a validated reuse and its result, share a recoverable consistency boundary. A historical receipt must remain interpretable after a subsequent edit or deletion; it is not proof of current membership. |
| Admission evidence | Durable non-secret account-generation and batch eligibility evidence, plus operation binding and applicable access context required by the coordinator. | Check under the same coordinated write boundary as admission. A local fence orders locally known events, not an unobserved remote grant change. |

The actual source of authorization and disclosure remains 0036 and 0112.
Protect project-related names, identity, intent and receipt data as applicable;
don't expose them through diagnostics or a recovery UI merely because a record
is readable. The credential itself belongs to the secure credential boundary.
The representation of bound intent, its retention and collision-resistant
comparison need an explicit provider-level decision; a hash alone does not
automatically establish exact intent equality or safe disclosure.

## Transaction boundaries

1. Confirm a batch and persist its context and entry identities before
   starting any corresponding Project mutation. A partially persisted or
   unreadable record cannot be treated as a confirmed exhaustive selection.
2. For a submitted entry, bind the immutable intent and operation identity.
   Within the coordinated effect transaction validate the durable account and
   batch fence, Repository identity, current association and intended outcome.
   Commit either Project + membership + default association + order + version
   + operation result together, or an independently validated reuse/conflict
   and its result. A conflict cannot silently become a reviewed reuse.
3. An explicit custom Project uses its own operation and commits one valid
   reviewed configuration and result; it must not quietly drop an ineligible
   member or create default associations. Existing Projects are unaffected.
4. A cancellation or applicable account-fence update has its own ordered
   durable boundary. Earlier admitted work may complete; later admissions must
   see the new fence. Network, Keychain and UI operations are outside the write
   transaction. If ordering cannot be established, affected admission stays
   unavailable rather than assuming it succeeded.

This is a logical protocol. Provider-specific transaction state, SQL schema,
constraints, migration and thread/process coordination remain to be specified
and verified. In particular, a single-process coordinator is not a guarantee
for an uncoordinated extension or other process.

## Recovery decisions

| Recovered evidence | Permitted conclusion and next action |
| --- | --- |
| Batch confirmed; entry definitely unsubmitted | Do not auto-submit after restart. Offer explicit retry only if the original batch, account and current admission remain eligible. |
| Entry submitted; operation result and effect or reuse evidence are recoverable | Report the historical result. Read current Project separately before navigation; re-evaluate disclosure. |
| Submission may have occurred; result or continuing writer is unresolved | Keep the operation indeterminate. Reconcile it or redeliver the same bound identity only when the boundary can ensure one logical effect; do not authorize a competing replacement. |
| Entry record or its binding is unreadable | Expose a local recovery limitation. Do not infer that the entry was unsubmitted, claim an exhaustive batch result, or synthesize a replacement identity. |
| Cancellation definitely committed | No further admission to that batch. Earlier admitted entries retain independent outcomes; a later attempt needs a separately reviewed batch. |
| Effect receipt exists but Project read fails or confirms later deletion | The receipt remains historical evidence; do not assert a current Project, navigate to it, or recreate it on replay. |
| Independently identified older store restored | Local operation and fence records may have rolled back together. Reconcile with independent evidence or retain uncertainty under 0122; do not claim universal rollback detection. |

## Remaining decisions and verification

Before leaf implementation readiness, specify exact record encoding and
constraints, operation-binding comparison, schema migration and protection,
provider calls and transaction/error semantics. Establish a deterministic
scenario matrix covering concurrent duplicate defaults, different custom
operations with equal content, interruption before and after commit, damaged
or missing evidence, cancellation and account changes. Doubles test the
boundary contract; actual provider restart, device file protection and backup
require separate evidence. The proposed table is a traceable design input, not
a completed implementation specification or executed test.

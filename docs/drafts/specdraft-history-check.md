# SpecDraft local history check

Status: local backup and recovery observation. This is not a specification,
an approval of the sketch, or permission to publish its quotations.

## Verified snapshot

- Source: `conversation_memory/sketches/gitview/` in this product workspace.
- SpecGraph native runtime commit: `ae423c62e17dc37ef1da9782e2046e7dda1ba9d0`.
- Source revision: `1396c542e64749d1bdad985fb1f732b2`.
- `notes verify_history` returned `complete`, 9 revisions and `canonical: false`.
- The local snapshot includes `CURRENT` and `notes.hc`, `notes.hcs`, and
  `metadata.json` for each reachable ancestor: 28 files total. It excludes
  `.lock` and does not include runtime files or generated reports.
- Local backup repository:
  `/Users/egor/.local/share/specgraph/backups/gitview-1396c542-history`, commit
  `8f4a11c16c5e53ae9d9d02ea1a1a7e01c85de563`. It has no Git remote.
- A fresh local clone was created at
  `/Users/egor/.local/share/specgraph/backups/gitview-1396c542-restored`.
  Each of its 28 files matched the source by SHA-256, and `verify_history` on
  `sketch/` returned the same revision and 9 complete revisions. The clone's
  `origin` is the local backup path, not a network remote.

The backup and restored copy have owner-only directory permissions. They contain
the full quoted history, including the original incorrectly encoded excerpt and
its later correction. Both remain local. The backup is a point-in-time snapshot:
later note updates are not copied into it automatically. GitView's existing
sketch exclusion remains in place, and a GitView clone alone cannot recover it.

## Future recovery and updates

Follow the installed skill's Git storage contract before creating a new backup:
inspect all ancestor contents for the chosen destination, avoid concurrent
writers, copy `CURRENT` and every reachable ancestor's three files together,
and check that the source did not change during the copy. Keep private material
out of any remote unless that destination and disclosure are authorized.

To verify a recovered copy with the installed launcher, replace `<copy>` with
the directory that contains its `CURRENT` file and `revisions/`:

```sh
/Users/egor/.local/share/specgraph/runtime-ae423c62/specgraph-runtime \
  --workspace /Users/egor/Development/GitHub/GitView \
  draft -- notes verify_history --workspace <copy>
```

`verify_history` checks chain and snapshot integrity; it does not authenticate
the quotations or metadata. Compare file hashes when proving that a particular
copy matches its source. A bounded `read_notes --history-limit` is not a full
history check.

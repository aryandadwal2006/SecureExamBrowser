# Organizer-Stated Scope and Pre-Finals Baseline Demo

**Updated:** 2026-10-09  
**Working branch:** `redteam/monitoring-audit-2026-10-09`

## Scope reported by the user

The organizer reportedly clarified that:

- No server-side monitoring is part of the pre-finals baseline check; the supplied SEB client is the target at this stage.
- The assessment link is not available for vulnerability testing before the finals.
- A baseline-check demonstration is required to advance.

These are organizer-stated constraints relayed by the user, not independently verified technical facts. Record written organizer guidance if available.

## What this changes

The immediate deliverable is a **client-only baseline capture**, not a claim about an active assessment. The missing assessment link is a scope limitation, not evidence of a vulnerability. The absence of server-side telemetry means this stage cannot establish anything about a remote detection path.

The previously completed public-package and local-file hash checks provide a useful identity baseline. They do not establish which runtime controls are active.

## Safe baseline procedure

Use the supplied installation and the normal launch/exit paths. Do not patch binaries, suppress alerts, disguise prohibited activity, or test against a real hiring assessment.

1. **Record context.** Note the date/time with timezone, Windows edition/build, SEB version, installation path, and that no assessment link/session was provided.
2. **Confirm identity.** Preserve the existing hash/signature report for the installed SEB core and reported Chromium files. Re-hash only if the installation changed since the last report.
3. **Start from a clean desktop.** Start SEB normally using the supplied shortcut/configuration. Do not change configuration to manufacture a result.
4. **Capture the baseline UI.** Record the exact landing-page/message shown, including “no tests available” if that is what appears. Capture version/about information and any ordinary startup prompts. Mark the session state **inactive / no assessment loaded**.
5. **Record ordinary runtime artifacts.** Capture a process tree and relevant command lines, then collect the application's ordinary startup/shutdown logs where available. Keep credentials, personal data, tokens, and unrelated desktop content out of screenshots and logs.
6. **Exit normally.** Record the shutdown outcome and whether ordinary local logs were produced. Preserve raw evidence separately and calculate SHA-256 digests for evidence files.
7. **Write an observation table.** For each item, record **observed**, **not observed**, **not collected**, or **unknown**. Do not convert a missing UI warning or absent log into a claim that an event would go undetected.

## Minimum presentation to judges

- The tested build and its hash/signature provenance.
- The screen recording or screenshots of normal startup and the actual inactive landing page.
- Process-tree and ordinary log evidence, with sensitive fields redacted in the presentation copy.
- A concise statement of what the baseline does and does not establish.
- A clear list of tests blocked by the lack of an assessment link.

## Permitted conclusion

A correct result for this stage can be: **“The supplied SEB client was launched and documented in its current no-assessment state; this baseline does not determine behavior under an active assessment.”**

Do not call this an undetected bypass or assert that monitoring is absent. Active-session enforcement, event reporting, and any independent observation remain untested until the organizer provides an authorized test link/session and the permitted test cases.

## Current status

The public package comparison and user's reported installed-file comparisons are complete for the files measured. This baseline capture has not yet been reported as executed in the current conversation. The next immediate task is to capture it; active assessment validation is blocked until the link/session becomes available.

# Progress and Demonstration Readiness

**Updated:** 2026-10-09  
**Working branch:** `redteam/monitoring-audit-2026-10-09`

## Progress estimate

These percentages are milestone-based estimates, not calculated from TODO checkbox totals.

| Workstream | Estimate | Basis |
|---|---:|---|
| Repository and architecture inventory | 90% | Root artifacts, REA tool, static application/service inventory, high-level call/control maps and test matrix are documented. |
| Public package and reported installed-file identity | 95% for reported files | 39/39 root EXE/DLLs and 12/12 selected source/config files match the public SEB MSI; all core files and 11/11 Chromium binaries in the user's inventory match expected hashes. Four additional Chromium payload files were not included in the local report. |
| Static monitoring/configuration review | 80% | Main control families and sample config selection/merge logic are recorded. Runtime activation, effective assessment config and full authorization paths are unresolved. |
| Runtime validation | 0% | No active/mock assessment session has been run and no independent host-to-server event correlation exists. |
| Verified demonstration of an undetected assessment violation | 0% | No bypass has been reproduced or independently verified. |

**Overall investigation-preparation estimate: approximately 60–65%.**  
**Judge-ready proof that cheating succeeds undetected: 0% verified.**

The immediate pre-finals task is a documented client-only baseline capture, now specified in [organizer-scope-and-baseline-demo.md](organizer-scope-and-baseline-demo.md). Active-session validation remains blocked until the organizer supplies the assessment link/session. More hashing is not the main remaining task.

## What has been completed

- Built and tested the REA static-analysis toolchain in GitHub Actions.
- Inspected the main executable, Windows service and contracts DLL without executing target binaries.
- Verified signatures of the publicly linked SEB/Chromium installer MSIs.
- Extracted package payloads as data only and recorded reproducible SHA-256 manifests.
- Compared 39 root EXE/DLL files and 12 selected legacy source/config files against the public SEB package.
- Compared the user's reported SEB files and 11 Chromium executables/DLLs against the package hashes; all reported files match.
- Documented the launch flow, privacy/recording distinctions, sample config ambiguity, screenshot source findings and a test matrix of T-001–T-019.
- Added a high-priority defensive review of privileged service authorization. It is an open question, not a confirmed vulnerability.

## Why an idle SEB shell is not proof of undetected cheating

Opening SEB when it says no test is available does not establish the effective configuration or monitoring state of an active assessment. A second browser visibly opening in that idle state would prove, at most, that the current idle-shell setup did not block that launch. It would not prove that the same action is unobserved or unreported during a real configured session, and it would not resolve independent human observation or server-side signals.

Do not label an idle-shell observation as a successful bypass. It can be recorded as baseline behaviour with the assessment/session state clearly marked **inactive**.

## Minimum evidence for a credible judge demonstration

1. Written authorization from the competition organizer for a specific test tenant/session and a defined scope.
2. A documented build/config identity and a clean, restorable Windows test environment.
3. A known-positive control showing that the independent host and app/service collectors are functioning.
4. A pre-approved, benign test action and explicit success/failure criteria.
5. Independent host evidence, candidate-visible outcome, available local logs and an authorized server receipt correlated by timestamp/event ID.
6. An independent reviewer able to reproduce and confirm the outcome.
7. A report separating **observed**, **not observed**, **not collected** and **unknown**. A missing warning alone is not proof of non-detection.

If the organizer cannot provide a mock/authorized active session, the final report must say runtime evasion remains untested. Static evidence may motivate a vulnerability hypothesis; it cannot substitute for reproducible demonstration.

## Organizer scope update (user-reported, 2026-10-09)

The organizer reportedly said the pre-finals gate is a baseline-check demonstration, with no server-side monitoring at this stage and no assessment link available for vulnerability testing before the finals. This is user-relayed scope, not independently verified technical evidence. See [organizer-scope-and-baseline-demo.md](organizer-scope-and-baseline-demo.md).

The next immediate action is to capture normal SEB startup, the actual inactive landing-page state, process identity and ordinary local logs, then present the result with the session state clearly marked **inactive / no assessment loaded**. This can satisfy a baseline-documentation task but cannot prove an active-session bypass or establish absence of monitoring. No more file inventory is needed unless the installed build changes.

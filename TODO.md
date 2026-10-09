# Audit TODO

**Last updated:** 2026-10-09  
**Branch:** redteam/monitoring-audit-2026-10-09

Statuses: [x] done, [ ] not done, [?] blocked/needs evidence.

## Repository reconnaissance
- [x] Confirm repository and default branch.
- [x] Create a separate investigation branch; leave main untouched.
- [x] Inventory root artifacts and map rea-main.
- [x] Read root competition README and REA README / managed-code analysis docs.
- [x] Inspect relevant legacy XUL modules, configs and service log.
- [x] Draft persistent plan, TODO, memory, architecture and initial findings documents.
- [x] Verify audit files are visible on GitHub and branch head is correct.

## Target identification
- [x] Obtain a clean automated checkout/artifact set through GitHub Actions without executing the large installer; the action analyzed the supplied files from a clean runner checkout.
- [x] Record raw SHA-256, assembly versions, MVIDs, PE architecture and managed metadata for all three managed artifacts in audit/artifact-manifest.md.
- [ ] Verify Authenticode status and exact runtime/loaded-module identity in a Windows VM.
- [ ] Determine launch chain, child processes, loaded modules, active config path and runtime version.
- [ ] Snapshot a clean VM and establish restore procedure.

## Static analysis
- [x] Build REA in GitHub Actions using rea-main/.nvmrc and the pinned lockfile; build and fast checks passed.
- [x] Perform read-only PE/CLI metadata triage on the service and contracts DLL, then run REA artifact/member/native-boundary inspection on the main app, service and contracts DLL.
- [x] Run exact-build member/CIL static inventory and record SHA-256/MVID in audit/static-application-analysis.md and audit/static-service-analysis.md. Full source-like C# decompilation remains optional/pending.
- [x] Initial static inventory confirms process/watchdog, foreground/window/display, integrity/health and log-protection component groups; detailed lifecycle and report-path mapping remains open.
- [ ] Confirm or reject correspondence between legacy XUL sources and supplied Windows build.

## Dynamic validation in an isolated lab
- [ ] Establish a known-positive instrumentation/control case.
- [ ] Capture independent process/session telemetry before, during and after a synthetic exam session.
- [ ] Run benign cases in audit/test-matrix.md and align raw timestamps.
- [ ] Investigate mismatches between OS events, UI, service log and authorized test-server records.
- [ ] Repeat candidate findings after restoring a clean snapshot.
- [ ] Mark unsupported tests and unavailable channels explicitly instead of treating them as passes.

## Online and human-observation boundaries
- [ ] Inventory client code and requests only in an authorized test session.
- [ ] Map observable visibility/focus, page lifecycle, permissions, screenshots/camera and network events where applicable.
- [ ] Document server-side and independent-agent behaviour that cannot be observed.
- [ ] Record a visual-observation assessment without implementing concealment or telemetry suppression.

## Findings and reporting
- [x] Update findings.md with static evidence, confidence and limits.
- [x] Update memory.md after material discoveries.
- [x] Update this TODO after each work session.
- [ ] Produce final report with build identity, test matrix, verified findings, limitations and defensive remediations.

## Scope note
This branch is for authorized assessment and reproducible detection-gap validation. It will not contain a one-click stealth toggle, alarm-suppression patch, log tampering, or operational procedures for hiding prohibited activity from a live invigilator or remote proctor.


## Progress update — 2026-10-09 (REA CI and main-app inventory)
- [x] GitHub Actions run [37901362719](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719) succeeded.
- [x] REA fast suite: 321 test files passed, 1 skipped; 3,450 tests passed, 4 skipped.
- [x] Static artifact/member/native-boundary reports created for SecureExamBrowser.exe, SebWindowsServiceWCF.exe and SEBWindowsServiceContracts.dll; see audit/static-application-analysis.md and audit/static-service-analysis.md.
- [ ] Create a Windows VM snapshot and establish collector health with a documented known-positive control.
- [ ] Validate detector activation and the alert/report chain dynamically; current CI tests the REA toolchain and parses binaries, not the running exam browser.

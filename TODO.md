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
- [ ] Obtain a clean checkout/artifact set without executing the large installer. The container cannot resolve GitHub DNS; continue through an authorized local Windows analysis host if needed.
- [ ] Verify signatures and local runtime identity; SHA-256, assembly versions, MVIDs and PE metadata from static analysis are recorded in audit/artifact-manifest.md.
- [ ] Determine launch chain, child processes, loaded modules, active config path and runtime version.
- [ ] Snapshot a clean VM and establish restore procedure.

## Static analysis
- [ ] Build REA from its own folder in a separate workspace; record environment and test output.
- [x] Perform read-only PE/CLI metadata triage on the service and contracts DLL; selected service CIL bodies were decoded in-memory. Full REA build and complete inspection remain pending.
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
- [ ] Update findings.md with evidence IDs and confidence.
- [ ] Update memory.md after material discoveries.
- [ ] Update this TODO after each work session.
- [ ] Produce final report with build identity, test matrix, verified findings, limitations and defensive remediations.

## Scope note
This branch is for authorized assessment and reproducible detection-gap validation. It will not contain a one-click stealth toggle, alarm-suppression patch, log tampering, or operational procedures for hiding prohibited activity from a live invigilator or remote proctor.
\n## Progress update — 2026-10-09\n- Read-only static check of service PE/CLI and selected CIL methods completed; see audit/static-service-analysis.md.\n- Main SecureExamBrowser.exe remains unanalyzed because the connected GitHub file path returned an empty base64 body for this larger binary.\n- No Windows runtime tests have run; do not report a bypass found or disproven.\n
## Progress update — 2026-10-09 (REA CI)
- [x] Add .github/workflows/seb-static-audit.yml; GitHub Actions run 37900802418 succeeded.
- [x] Download and inspect the static report artifact; update F-008/F-009 in findings.md.
- [ ] Create Windows VM snapshot and run a benign known-positive control.
- [ ] Validate detector activation and alert/report flow dynamically; current tests do not run SEB or test a bypass.

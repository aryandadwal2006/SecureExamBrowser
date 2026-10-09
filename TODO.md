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
- [x] Produce current static report and execution ledger in audit/static-application-analysis.md, audit/static-service-analysis.md, audit/test-results.md and findings.md. Runtime validation remains pending.

## Scope note
This branch is for authorized assessment and reproducible detection-gap validation. It will not contain a one-click stealth toggle, alarm-suppression patch, log tampering, or operational procedures for hiding prohibited activity from a live invigilator or remote proctor.


## Progress update — 2026-10-09 (REA CI and main-app inventory)
- [x] GitHub Actions run [37901362719](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719) succeeded.
- [x] REA fast suite: 321 test files passed, 1 skipped; 3,450 tests passed, 4 skipped.
- [x] Static artifact/member/native-boundary reports created for SecureExamBrowser.exe, SebWindowsServiceWCF.exe and SEBWindowsServiceContracts.dll; see audit/static-application-analysis.md and audit/static-service-analysis.md.
- [ ] Create a Windows VM snapshot and establish collector health with a documented known-positive control.
- [ ] Validate detector activation and the alert/report chain dynamically; current CI tests the REA toolchain and parses binaries, not the running exam browser.


## Progress update — 2026-10-09 (platform flow and call-graph review)
- [x] Reviewed user's screenshots and public HirePro Accenture SEB page; summarized launch flow and visible recording notice in audit/platform-observations.md.
- [x] Distinguished the browser external-application prompt from a Windows UAC elevation dialog.
- [x] Added static call-edge notes linking the SEB lifecycle to prohibited-process checks, process monitoring, local browser communication and watchdog/integrity reporting.
- [x] Added tests T-013 to T-017 for launch provenance, policy positive controls, watchdog/report delivery and authorized recording/network observation.
- [ ] Confirm active configuration and per-session feature activation in an isolated Windows VM.
- [ ] Correlate host/process/device events with sanitized local logs and an authorized test-server receipt.
- [ ] Verify installer Authenticode signature/publisher on Windows; the public guide's request to disable antivirus / override Defender needs provenance verification.

- [x] Add a Windows-only CI job to hash the shipped executables/installer and inspect Authenticode publisher/status without executing binaries.
- [x] Review Windows provenance output from workflow run [37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412); primary EXE signature is valid, service/contract/installer are unsigned; see audit/artifact-manifest.md.


## Progress update — 2026-10-09 (Windows provenance)
- [x] Windows-only hash/signature job completed for the four repository artifacts; see audit/artifact-manifest.md and finding F-014.
- [ ] Obtain/verify expected signer/hash for unsigned service, contract DLL and repo Chromium installer; absence of a signature is not a malware verdict.
- [ ] Confirm whether the repository's large Chromium installer matches any file delivered by the email invitation; currently unverified.


## Progress update — latest automation (2026-10-09)
- [x] Both jobs in [workflow run 37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412) succeeded.
- [x] REA fast suite on the latest run: 321 test files passed, 1 skipped; 3,450 tests passed, 4 skipped.
- [x] Windows provenance artifact collected; exact hash/signer states are recorded in audit/artifact-manifest.md.
- [x] Consolidated automated/pending results in audit/test-results.md.
- [ ] Perform approved Windows VM positive-control tests; this is the main remaining execution gap.


## Progress update — 2026-10-09 (official package identity)
- [x] Verified that the current generic HirePro SEB page publicly links a separate Chromium 1.0.1 MSI and Secure Exam Browser 2.0.2 MSI.
- [x] Added a Windows CI comparison job for the public MSI packages and repository artifacts; it downloads and inspects but does not execute them.
- [x] Review Windows artifact from run [37906017253](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253); the public MSIs are signed, while the repo Chromium EXE is unsigned and differs by hash/size.

- [ ] Compare the contents/embedded file manifest of the signed public SEB MSI to repository app/service/DLL hashes without installing it.

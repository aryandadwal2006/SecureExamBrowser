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
- [ ] Verify process tree, loaded-module identity and effective runtime configuration in an authorized Windows VM; file hashes alone do not establish loaded modules.
- [ ] In an authorized Windows VM, establish launch chain, child processes, loaded modules, active config path and effective runtime configuration.
- [ ] Snapshot a clean VM and establish restore procedure.

## Static analysis
- [x] Build REA in GitHub Actions using rea-main/.nvmrc and the pinned lockfile; build and fast checks passed.
- [x] Perform read-only PE/CLI metadata triage on the service and contracts DLL, then run REA artifact/member/native-boundary inspection on the main app, service and contracts DLL.
- [x] Run exact-build member/CIL static inventory and record SHA-256/MVID in audit/static-application-analysis.md and audit/static-service-analysis.md. Full source-like C# decompilation remains optional/pending.
- [x] Initial inventory and selected lifecycle/call paths are documented in audit/static-application-analysis.md and audit/control-map.md; effective runtime activation/reporting remains pending.
- [x] Confirm selected legacy XUL sources/config/startup files correspond exactly to the current signed public MSI; see audit/legacy-source-package-comparison.md.

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
- [x] Verify Authenticode for current public SEB/Chromium MSIs; both are validly signed by Hirepro Consulting Pvt Ltd. Keep antivirus enabled and confirm any candidate-specific package with the organizer.

- [x] Add a Windows-only CI job to hash the shipped executables/installer and inspect Authenticode publisher/status without executing binaries.
- [x] Review Windows provenance output from workflow run [37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412); primary EXE signature is valid, service/contract/installer are unsigned; see audit/artifact-manifest.md.


## Progress update — 2026-10-09 (Windows provenance)
- [x] Windows-only hash/signature job completed for the four repository artifacts; see audit/artifact-manifest.md and finding F-014.
- [x] Match service, contract DLL and repo Chromium bootstrapper byte-for-byte to files extracted from the signed public SEB MSI; see audit/vendor-package-comparison.md. Their standalone unsigned status alone is not evidence of tampering.
- [ ] Candidate-link delivery provenance is not independently captured. Installed bootstrapper and repository file match the public signed MSI payload; do not request session tokens or share the candidate URL.


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

- [x] Extract the signed public SEB MSI without installing it and compare hashes for app EXE, service EXE, contracts DLL, and bundled Chromium EXE. All four match exact package payload files.
- [x] Expand the comparison to every top-level EXE/DLL: 39 of 39 match the signed public SEB MSI payload exactly by SHA-256; see audit/vendor-package-comparison.md.



## Progress update — 2026-10-09 (full package comparison)
- [x] Compared all 39 root-level EXE/DLL files to the signed public SEB 2.0.2 MSI extracted without installation: 39 exact hash matches, zero mismatches.
- [x] Both jobs in [workflow run 37906673190](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190) completed successfully.
- [x] Repository-to-vendor package provenance is established for the current public SEB MSI snapshot (39/39 root EXE/DLL and 12/12 selected XUL/config assets match). Runtime identity/control validation is the remaining execution gap.


## Progress update — 2026-10-09 (static control map)
- [x] Consolidated session startup, process/device/watchdog/integrity, local IPC, log/reporting, online-proctoring and human-observation layers in audit/control-map.md.
- [x] Prioritized remaining checks by required evidence and clearly separated static evidence from runtime assumptions.
- [x] Review available legacy configuration/source and map message/reporting paths at a high level; see audit/config-profile-analysis.md and audit/control-map.md. Effective per-session settings remain unknown.


## Hash manifest
- [x] Commit the full 39-file SHA-256 table in audit/vendor-component-hashes.md for reproducible provenance review.

- [x] Add a privacy-scope caveat for local native/browser message-schema fields: schema presence does not prove remote collection.
- [ ] If authorized server-side receipts become available, correlate sanitized event IDs with the local observation chain, without collecting secrets/recordings.

- [x] Document current published privacy-policy claims separately from unverified full-desktop capture/session-specific telemetry in audit/platform-observations.md and audit/control-map.md.
- [ ] Only claim actual screen capture if supported by a concrete call path and/or authorized runtime evidence; keep current status unknown.

- [x] Inspect legacy screenshot module and screenshot-related message handler; record as source-level capability with correspondence/activation unknown (F-018).
- [x] Resolve selected legacy XUL source-to-package correspondence: 12 of 12 selected assets exact match. Actual session screenshot activation/scope remains unknown and requires authorized runtime evidence.

- [x] Add audit/README.md as the navigation index for continuation.


## Progress update — 2026-10-09 (canonical XUL source comparison)
- [x] Fix Windows source/package comparison to hash canonical Git blobs rather than CRLF-transformed worktree files.
- [x] Confirm all 12 selected legacy source/config/startup assets exactly match files extracted from the signed public SEB MSI; see audit/legacy-source-package-comparison.md.
- [x] Document config variability and distinguish source presence from runtime activation in audit/config-profile-analysis.md.
- [ ] Obtain effective configuration and independently validate expected positive controls in an authorized Windows VM. No local session is available to this environment.


## Defensive assurance pass — 2026-10-09
- [x] Add recommendations for signed/effective configuration, fail-closed monitor lifecycle, event correlation, local IPC hardening, package integrity, privacy clarity and regression validation in audit/defensive-hardening-recommendations.md.
- [x] Add audit/config-profile-analysis.md explaining why checked-in profiles do not establish the live assessment configuration.
- [ ] Runtime test remains pending: requires a disposable Windows VM and an explicitly authorized mock/test tenant. Do not use CI to run the actual assessment client.


## Latest progress — 2026-10-09 (canonical source + local inventory prep)
- [x] Workflow run [37908852563](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563) succeeded on both jobs, including corrected canonical Git blob comparison.
- [x] Add a read-only local inventory script at audit/scripts/Collect-LocalSEBInventory.ps1. It collects only hashes/file metadata/signature status and avoids reading config contents, process arguments, tokens, logs or recordings.
- [x] Add a Windows PowerShell parser check so the local inventory script is syntax-validated but not run in CI.
- [x] Use the read-only local inventory when needed to confirm installed core SEB files against the public package.

- [x] Prepare and run a safe local file inventory; user-provided reports confirm installed core SEB files and 11/11 reported Chromium payload binaries match package hashes.
- [x] Document exact usage in audit/scripts/README.md and verify the collector's hash before running it.

- [x] Define an authorized, controlled human-observation validation protocol that separates observer reports from browser/host/server evidence in audit/human-observation-protocol.md.
- [ ] Execute that protocol only in an approved mock environment with organizer approval and consent; no live test has been run.

- [x] Verify full workflow run [37909760671](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37909760671) completed successfully: PowerShell parser pass, REA build/check/test and static package inspection pass.
- [x] Obtain and compare the user's local inventory; the primary file-identity question is closed for all reported files.


## User inventory follow-up — 2026-10-09
- [x] Compare reported installed core SEB file hashes against the repository/public MSI; all reported core files match.
- [x] Explain service .config package/Git byte difference as CRLF working-tree transformation: installed 186-byte file matches package/Windows copy.
- [x] Compare installed chrome.exe and selected runtime DLLs against extracted vendor payload; 11/11 reported Chromium files match.
- [ ] Effective assessment config/runtime telemetry remains unknown; no configuration contents or process arguments should be collected for the next inventory.

- [x] Add an all-binary inventory for the extracted public Chromium and SEB MSIs (artifact 11614615520). This inventories package payloads only and does not execute them.

- [x] Updated CI run [37925812683](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37925812683) passed both jobs: REA fast test/static scan and Windows artifact provenance/package inventory; current local collector parses successfully.
- [x] Compare installed `chrome.exe`, `chrome.dll`, `chrome_elf.dll` and other reported Chromium binaries against the official nested payload: 11/11 reported files match (see audit/local-install-comparison.md).
- [ ] Optional completeness check: collect hashes for `chrome_wer.dll`, `dxcompiler.dll`, `dxil.dll`, and `eventlog_provider.dll`; these four names were not included in the local inventory.

- [x] Explore nested Chromium installer with 7-Zip without executing it; initial extraction returned exit code 0 but no EXE/DLL results.
- [x] Record and fix a CI tooling failure where Chocolatey could not resolve pinned lessmsi 2.12.9; the workflow now installs the currently available package version instead.
- [x] Verify the retry [37926726531](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926726531) succeeded; it identified chrome.7z inside the nested installer.
- [x] Extract nested chrome.7z as data; 86 files found, 15 EXE/DLL hashes recorded in audit/chromium-payload-hashes.md.

- [x] Compare all 11 Chromium EXE/DLL files present in the second user inventory to audit/chromium-payload-hashes.md; all matched exactly.
- [ ] Optional: hash the four remaining Chromium manifest entries not requested by the collector (chrome_wer.dll, dxcompiler.dll, dxil.dll, eventlog_provider.dll).
- [x] Add the privileged service authorization review and new controlled assurance case T-019.
- [ ] Run T-019 only in an authorized disposable Windows VM using a vendor-approved, non-destructive harness. Endpoint access control and command-operation authorization remain unknown; no vulnerability is asserted.


## Demonstration-readiness checkpoint — 2026-10-09
- [x] Estimate progress and distinguish static preparation from verified bypass evidence in audit/progress-status.md.
- [x] Record why an idle SEB shell is not evidence about an active assessment's monitoring/reporting state.
- [ ] Obtain organizer-approved active/test-session access and written scope before any runtime detection/reporting claims.
- [ ] If no approved session becomes available, finalize the deliverable as a static risk assessment with runtime claims explicitly untested; do not claim a successful undetected-cheating demonstration.

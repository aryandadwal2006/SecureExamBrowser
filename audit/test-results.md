# Test Results and Execution Ledger

**Updated:** 2026-10-09  
**Branch:** `redteam/monitoring-audit-2026-10-09`  
**Scope:** Static analysis and artifact provenance only. No assessment browser, installer or target service was executed by these jobs.

## Completed checks

| ID | Check | Result | Evidence | What the result means |
|---|---|---|---|---|
| R-001 | REA dependency install/build | Pass | [CI run 37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412) | Analysis tool built successfully. |
| R-002 | REA fast types/lint checks | Pass | Same CI run | REA's fast code-quality checks passed. |
| R-003 | REA fast unit/integration suite | Pass, with skips | Same CI run | 321 test files passed and 1 was skipped; 3,450 tests passed and 4 were skipped. These are REA tests, **not** tests of SEB's runtime security. |
| R-004 | Managed PE/CLI inventory for app, service and contracts | Pass | [Static report artifact](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412/artifacts/11603352933) | Reports created for all three artifacts without loading/executing the target binaries. |
| R-005 | Windows SHA-256 and Authenticode status | Pass as an evidence collection step | [Windows provenance artifact](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412/artifacts/11603138113) | Main `SecureExamBrowser.exe` signature validates and names Hirepro Consulting Pvt Ltd. The service executable, contract DLL and repo's Chromium installer are reported as unsigned. Unsigned status is not proof of malware. |
| R-006 | Public landing page/privacy notice and supplied screenshots reviewed | Observed | [Platform observations](platform-observations.md) | Documents the native-app handoff, app closure warning, visible recording notice and published data categories. Not a measurement of the session's network payloads. |
| R-007 | Static call graph review of session startup/watchers | Pass as static evidence gathering | [Static application analysis](static-application-analysis.md) | Call edges connect the session-opening path to process monitoring, prohibited-process checks, local browser communication and watcher/integrity reporting. Runtime activation remains unverified. |

## Pending validation

| ID | Check | Required environment/evidence | Status |
|---|---|---|---|
| D-001 | Verify actual installed file identity and active configuration | Authorized Windows VM; hashes/versions, loaded modules, process ancestry and config path | Not run |
| D-002 | Confirm detector activation using a benign positive control | Disposable Windows VM with healthy independent process/session telemetry | Not run |
| D-003 | Verify end-to-end detection/report delivery | Correlated host event, app/service log and authorized test-server receipt | Not run |
| D-004 | Test documented device restrictions and session transitions | Disposable VM/test device and approved benign controls | Not run |
| D-005 | Measure browser/platform recording and network event flow | Authorized mock session, permission evidence and sanitized/authorized server records | Not run |
| D-006 | Verify integrity coverage for all loaded/shipped components | Source/CIL review plus vendor-provided expected hashes/publishers; no file tampering required | Not run |
| D-007 | Determine whether a separate human observer is present and what that observer can see | Explicit organizer confirmation / authorized protocol documentation | Unknown |

## Verdict discipline

- A static type, call edge or string proves only what is present in the identified artifact.
- Successful REA tests validate the analysis toolchain, not SEB's effectiveness.
- An Authenticode result applies to the exact hashed repository file, not automatically to the user's downloaded/installed copy.
- “No warning seen” is not a finding of missing telemetry unless independent capture and all required reporting channels have been validated.
- No bypass has been reproduced, and no bypass has been disproven.


## New provenance subtask

Run [37906017253](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253) downloaded both public HirePro MSI packages, collected SHA-256 plus Authenticode signer/status for those files and the repository artifacts, and uploaded the JSON report. The Windows job succeeded; the REA job was still running when this report was compiled. Results: both public MSIs have valid signatures; the repo Chromium EXE is unsigned and differs from the public Chromium MSI by hash and size. See [vendor-package-comparison.md](vendor-package-comparison.md).


## R-008 — Extract and compare current signed MSI payload (completed)
- **Result:** Passed. The Windows job extracted the signed public SEB MSI without installation and found exact SHA-256 matches for all four examined root artifacts.
- **Evidence:** [Workflow run 37906360710](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906360710); [component comparison artifact](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906360710/artifacts/11604692503).
- **Limit:** This confirms correspondence to the current public installer contents, not identity of files on the user's machine. Other root-level DLLs remain to be compared.


## R-009 — Full root-level component identity check (Windows CI)
- **Result:** Passed. All 39 top-level repository EXE/DLL files had an exact same-named, same-SHA-256 counterpart in the extracted signed public SEB 2.0.2 MSI; zero mismatches.
- **Evidence:** [Workflow run 37906673190](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190); [artifact 11604173812](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812).
- **Limit:** This verifies repository files against the public package, not files installed on the user's laptop. The parallel REA test job was still running when this row was added.


## Static-control-map checkpoint
- **Result:** Completed as a documentation synthesis of the verified artifact inventory, call-graph relationships, package provenance and user-provided visible platform flow.
- **Evidence:** [audit/control-map.md](control-map.md).
- **Limit:** It is a model for test planning, not a Windows runtime test or a claim that a security gap exists.


Complete per-file table: [audit/vendor-component-hashes.md](vendor-component-hashes.md). It records all 39 repository root-level EXE/DLL filenames, lengths, SHA-256 values, extracted MSI paths, and exact-match result.


## Public-policy interpretation boundary
The current HirePro privacy policy names possible video/audio/live-image, device/browser, page/link and suspicious-activity processing. It does not by itself prove continuous full-desktop capture in a specific session. The screenshot's recording notice establishes that the UI disclosed audio/video recording; runtime collection and server receipts remain unmeasured. See [platform-observations.md](platform-observations.md).


## R-010 — Canonical legacy-source / installer match
- **Result:** Pass. 12 selected XUL modules/configuration/startup assets matched exactly by SHA-256 to same-named files extracted from the current public signed SEB 2.0.2 MSI.
- **Correction:** The first attempt hashed Windows working-tree copies with CRLF conversion; the corrected job hashes canonical Git blobs. The apparent initial mismatches were a line-ending artifact, not a source/package mismatch.
- **Evidence:** [Run 37908852563](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563); [artifact 11605307704](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563/artifacts/11605307704); [audit/legacy-source-package-comparison.md](legacy-source-package-comparison.md).
- **Limit:** File identity supports static source review; it does not establish active config or runtime behavior.


## R-011 — Source/config interpretation and hardening review
- **Result:** Documentation checkpoint complete. The active config selection/merge semantics and the limits of sample profiles are recorded in [config-profile-analysis.md](config-profile-analysis.md); proposed defensive controls and test acceptance criteria are in [defensive-hardening-recommendations.md](defensive-hardening-recommendations.md).
- **Limit:** This creates no new runtime evidence. The assessment's effective config and event path remain unknown.


## R-012 — Local inventory script syntax (Windows CI)
- **Result:** PowerShell parser step passed and both jobs in the workflow completed successfully. The script itself was not executed by CI.
- **Evidence:** [Successful workflow run 37909760671](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37909760671).
- **Limit:** This validates script syntax only. It does not inventory the user's machine and does not test SEB runtime behavior.


## R-013 — User-provided installed-file inventory compared to package manifest
- **Result:** Core reported file hashes match existing repository/public MSI evidence: main EXE, service EXE, contracts DLL, bundled Chromium bootstrapper, `config.json`, `config.SEB22.json`, `default.json`, main EXE .config and service .config package copy.
- **Evidence:** [audit/local-install-comparison.md](local-install-comparison.md); [current public package comparison](vendor-package-comparison.md).
- **Limit:** First inventory script did not search for `chrome.exe`; the installed Chromium browser executable and associated runtime DLLs remain unmeasured. The inventory did not reveal effective session configuration or runtime behavior.


## R-014 — Full packaged-binary inventory (read-only)
- **Result:** The Windows job extracted both public MSIs and wrote hashes, signatures and package paths for each EXE/DLL. No installer was run.
- **Evidence:** [Run 37925812683](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37925812683); [artifact 11614615520](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37925812683/artifacts/11614615520).
- **Observation:** The Chromium package's `chromium-135-0-7049-96.exe` has the same size/SHA-256 as the user's `hirepro-chromium-installer.exe` and is contained in a signed MSI.
- **Limit:** The package contains a nested installer, not its post-install `chrome.exe`; installed browser binary identity remains pending.


## R-015 — Latest integrated static/provenance run
- **Result:** Pass. Both jobs completed successfully in [workflow run 37925812683](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37925812683). This includes REA build/check/test, binary static inspection, PowerShell parser validation, package extraction, component hashing and full EXE/DLL inventory of the public MSIs.
- **Limit:** No target binary was executed. The user's installed `chrome.exe`/runtime DLL hash remains pending.


## R-016 — Nested Chromium installer archive exploration (in progress)
- Initial 7-Zip run returned exit code 0 but recorded no extracted EXE/DLL entries; that report omitted non-binary filenames, so interpretation is open.
- An enhanced report now records extracted filenames, extensions, sizes and hashes, as well as EXE/DLL signatures.
- Run [37926598648](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926598648) failed before extraction because Chocolatey could not resolve pinned `lessmsi` version 2.12.9. The version pin was removed; retry [37926726531](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926726531) was queued at document update time.
- This is a tooling issue and does not change previously successful hash/signature results.


## R-017 — Nested Chromium payload inventory (completed)
- **Result:** Pass. The Windows job extracted the vendor MSI without installation, extracted the nested Chromium bootstrapper archive as data, and then extracted its `chrome.7z` payload. The inner extraction returned exit code 0 and contained 86 files, including 15 EXE/DLL files; none were run.
- **Evidence:** [Workflow run 37926967501](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926967501); [artifact 11613754590](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926967501/artifacts/11613754590); [hash manifest](chromium-payload-hashes.md).
- **Limit:** Installed Chromium binary hashes remain unmeasured until the corrected local collector is run.


## R-018 — Installed Chromium binary comparison (user-provided report)
- **Result:** Pass for the 11 reported Chromium EXE/DLL files. The local SHA-256 values and byte counts exactly match the extracted public Chromium 135.0.7049.96 payload.
- **Evidence:** User's second inventory; [audit/local-install-comparison.md](local-install-comparison.md); [audit/chromium-payload-hashes.md](chromium-payload-hashes.md).
- **Limit:** Four packaged binary names were not requested by the local collector and are unverified. This is a collection-scope gap, not a detected mismatch.
- **Security boundary:** File identity does not prove effective assessment settings, monitor activation, remote telemetry receipt or human-observer coverage.


## R-019 — Privileged service authorization design review
- **Result:** Static review item documented; dynamic outcome pending.
- **Evidence:** [audit/privileged-service-authorization-review.md](privileged-service-authorization-review.md); [test case T-019](test-matrix.md).
- **Limit:** Presence of policy-management methods and a process-launch helper does not establish untrusted reachability. Endpoint ACL, authentication, allow-listing and runtime denial behaviour remain unknown.


## R-020 — Final local identity checkpoint
- **Result:** Pass for all files reported by the user: core SEB executable/service/configuration artifacts match the package evidence, and 11/11 reported Chromium EXE/DLL files match the nested Chromium payload.
- **Evidence:** [audit/local-install-comparison.md](local-install-comparison.md); [audit/chromium-payload-hashes.md](chromium-payload-hashes.md); comprehensive static workflow [37926967501](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926967501).
- **Remaining optional collection gap:** four Chromium package names were not requested by the local collector. No mismatch is known.
- **Dynamic validation remains not run:** effective config, endpoint authorization, monitoring activation, remote receipt delivery and human observation need approved test-environment evidence.

# Investigation Memory / GPT Handoff

**Last updated:** 2026-10-09  
**Repository:** https://github.com/aryandadwal2006/SecureExamBrowser  
**Working branch:** redteam/monitoring-audit-2026-10-09  
**Default branch:** main

## Goal
Perform a systematic, evidence-backed audit of the supplied SecureExamBrowser build for the authorized red-team competition. Priority is identifying active detection/enforcement/reporting controls and reproducing any genuine monitoring false negative in an isolated test environment.

Do not assume a bypass exists. Do not modify main. Scope excludes a one-click stealth mode, remote telemetry suppression, and disguising prohibited activity from a live invigilator.

## Repository map

### Root
- SecureExamBrowser.exe (about 1.9 MB in GitHub contents metadata).
- SebWindowsServiceWCF.exe (about 170 KB).
- SEBWindowsServiceContracts.dll.
- SecureExamBrowser.exe.config and SebWindowsServiceWCF.exe.config.
- SebWindowsBrowser/xul_seb/: readable legacy XUL/JavaScript browser source, configs and resources.
- sebwindowsservice.log: checked-in Windows service log.
- hirepro-chromium-installer.exe (about 103 MB).
- Supporting DLLs include TraceEvent-related, DIA, video/camera and PowerShell libraries. Presence does not prove usage.

### Added rea-main/
- REA (Reverse Engineer Anything), a TypeScript/Node.js codebase from morluto/rea.
- Includes CLI/MCP, docs, tests and static .NET PE/CLI analysis.
- Docs worth reading: docs/managed-code-analysis.md, docs/process-capture.md, docs/native-investigation.md, docs/mcp-contracts.md and docs/reconstruction-readiness.md.
- Managed tools inspect artifact metadata, members/CIL and managed/native boundary declarations without loading target assemblies.
- REA managed inspection is not a full C# source decompiler. Use a suitable .NET decompiler if source-like reconstruction is required.
- REA docs say newly captured PTY process scenarios currently require Linux/macOS; it is not native Windows process-tree capture. WSL is not native Windows coverage.

## Initial source observations (not runtime-confirmed)
1. SebHost.jsm has an optional browser messaging WebSocket and dispatches configured incoming messages to handlers including Close, RestartExam, LockSeb, UnlockSeb and Reconfigure. Application-level authentication is not apparent in the displayed dispatch method alone; endpoint/server auth and whether this code runs in the competition build are unknown.
2. SebServer.jsm is a separate channel configured with sebServerEnabled and has shutdown/reboot/lock/unlock/screenshot-related handlers. Checked-in config.json sets sebServerEnabled false; active config remains unknown.
3. SebConfig.jsm merges JSON config with defaults and can accept a config path/URI through command-line input or reconfiguration. Actual precedence and integrity checks in the supplied build require verification.
4. config.default.json includes monitorProcesses: false, enableLogging: false and browserMessagingSocketEnabled: false. These are legacy config values, not proof of Windows service behaviour.
5. config.json contains example hostnames and placeholder-looking values including sebserver.example.com; do not treat them as active endpoints or secrets.
6. SecureExamBrowser.exe.config comments say WCF endpoint/binding are configured in compiled code and describe a historical plaintext diagnostic-log issue involving auth tokens. Current checked-in config does not enable WCF message logging.
7. sebwindowsservice.log records policy changes related to Task Manager/workstation/password restrictions and Windows Update service state. This proves those actions were logged on that machine, not that a complete process detector exists.
8. SebScreenshot.jsm contains screenshot routines exposed through the XUL layer. Active use, triggers and online-platform screenshot collection remain unverified.
9. Initial tree review did not find the C# source for the compiled Windows app/service. Source-to-binary correspondence is unknown.

## Static service analysis completed 2026-10-09
- Service binary has Git blob ID 1364103ef2f4ce48f42f0dc3a71616fc3d40cf7d and repository size 170,496 bytes. This Git object ID is not the raw-file SHA-256.
- Read-only PE parse reports machine 0x014c (x86), valid CLR/CLI metadata and .text/.rsrc/.reloc sections.
- IsSebRunning calls System.Diagnostics.Process.GetProcessesByName("secureexambrowser"). ResetOnStartup calls IsSebRunning and logs that a new SecureExamBrowser process stops reset attempts. This is a process-presence/lifecycle check in the examined path, not proof of broad process surveillance or its absence elsewhere.
- InitializeHost creates a NetNamedPipeBinding and has the endpoint string net.pipe://localhost/SebWindowsServiceWCF/service. Runtime auth semantics still need verification.
- Service types include RegistryService and CommandExecutor; registry policy values are preserved and reset, and CommandExecutor uses ProcessStartInfo/Process.Start. Caller/argument validation remains to be traced.
- Supporting notes: audit/static-service-analysis.md and audit/artifact-manifest.md.
- Initially the GitHub file connector returned an empty base64 body for the ~1.92 MB main exe, and the local container could not resolve github.com. This was resolved for static inspection by adding .github/workflows/seb-static-audit.yml; GitHub Actions successfully checked out the branch and produced full REA reports for all three managed artifacts. This did not perform Windows runtime testing.

## Main application static analysis and CI verification — 2026-10-09
- Successful workflow: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719
- Result: complete; REA dependency install, build, fast check and fast tests succeeded. Tests: 321 files passed, 1 skipped; 3,450 passed, 4 skipped. These are REA/toolchain tests, not tests of SecureExamBrowser's runtime.
- Downloadable artifact: Actions artifact ID 11601833774, `seb-static-analysis`.
- Main exe: 1,924,120 bytes, SHA-256 `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`; assembly 2.0.2.0; MVID `704e0878-fd78-47f7-922f-49d7ed0a9f18`; target .NET Framework 4.5.2; metadata coverage complete; 377 types, 2,212 methods, 17,867 call edges, 126 P/Invoke declarations, 273 native-implementation indicators (indicators aren't proof of resolved native semantics).
- Main app type inventory contains candidate subsystems for process startup/process handling, process/foreground/display/window watchdogs, prohibited-process handling, clipboard/network-activity checks, screen sharing/desktop/camera/VM, executable integrity and watchdog/log health.
- Service exe SHA-256 `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57`; assembly 2.2.0.0; MVID `aea1abb8-cb61-45e8-9b75-81f72e71d848`. Contracts DLL SHA-256 `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5`; assembly 2.2.0.0; MVID `e7845311-4100-4832-b088-bb4dea31ed85`.
- Static component presence does not establish active configuration, reliable detection, remote reporting or absence of gaps. The full summary and limits are in audit/static-application-analysis.md and audit/artifact-manifest.md.

## First next steps
1. Verify branch head and audit files.
2. Obtain a clean checkout or artifact set without executing the large installer.
3. Hash/version/sign the application, service and contracts DLL.
4. Build REA from its own folder in a separate workspace; record test outputs.
5. Run REA managed inspections and use a .NET decompiler for targeted methods.
6. Map actual observation → decision → enforcement → local/remote reporting.
7. Run the isolated test matrix and correlate browser, Windows, service and test-server observations.

## Required terminology
- Observed: directly confirmed.
- Inferred: supported interpretation, not direct proof.
- Unknown / untested / unsupported: evidence absent or tool/platform cannot perform test.
- False negative: only after an event occurred, expected detection coverage is defined, independent capture is healthy and the expected detection/reporting event is absent.
- Not observed is not the same as not collected unless channel completeness is verified.

See plan.md, TODO.md, findings.md, audit/architecture.md, audit/test-matrix.md, audit/static-application-analysis.md, audit/static-service-analysis.md and audit/artifact-manifest.md.


## HirePro/Accenture platform evidence added — 2026-10-09
- User supplied email/browser/test screenshots. They were not committed because they contain candidate/assessment information.
- The public landing page is https://securetest.hirepro.in/accenture/ and matches the general launch sequence. The exact email short URL https://a.hirepro.in/d1INrdCM did not resolve in the retrieval session; don't claim its specific redirect was verified. Never store the opaque `data=` token from the candidate URL.
- Screenshot dialog saying `securetest.hirepro.in wants to open this application` is the browser's external-app/protocol handoff prompt, not itself a Windows UAC prompt.
- The running mock-test UI is labelled Secure Exam Browser 2.0.2 and visibly states video/audio are recorded and reviewed for integrity. Public HirePro privacy policy (updated 2026-01-13) says proctored services may collect video/audio/live images, device information, IP/derived location, assessment performance, page/link usage and technical data; for customer/partner assessments, HirePro processes data under the customer's instructions.
- Public page states supported OS/admin rights/Chrome requirements and says other applications should close; it also asks users to disable antivirus and says to choose “More Info” / “Run Anyway” if Defender warns. Treat this as an informational supply-chain caution, not evidence of malware; verify signer/hash with the organizer or vendor and do not leave protection disabled globally.
- Static main-exe call edges now mapped at a high level: OpenSEBForm references CheckProhibitedProcesses, MonitorProcesses and SEBXULRunnerWebSocketServer.StartServer; ProcessWatchDog and other watchdogs reference tick/heartbeat reporting; ExeIntegrityWatchDog references VerifyCurrentExe and check-status reporting; logger paths reference zipped-log upload. SEBXULMessage schema includes device/system-information fields. All are static observations, not proof that the current session used each path.
- See audit/platform-observations.md, audit/static-application-analysis.md, findings.md and test cases T-013–T-017 in audit/test-matrix.md.

## Current Windows provenance check — 2026-10-09
- Added a Windows GitHub Actions job that computes raw SHA-256 and captures Authenticode signature status, signer subject/issuer/thumbprint and certificate dates for SecureExamBrowser.exe, SebWindowsServiceWCF.exe, SEBWindowsServiceContracts.dll and hirepro-chromium-installer.exe. It does not execute them.
- Workflow run completed successfully: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412. Windows artifact ID 11603138113 has been downloaded/reviewed and its findings recorded in audit/artifact-manifest.md and findings.md.


## Windows signature preflight results — 2026-10-09
- Workflow run: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412, Windows artifact ID 11603138113. The job hashes files and calls Get-AuthenticodeSignature; it does not execute them.
- SecureExamBrowser.exe: SHA-256 `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`; signature Valid; signer `CN=Hirepro Consulting Pvt Ltd`; signer thumbprint `B522BE129C67224D25A7566A9F293E5C256CC143`.
- SebWindowsServiceWCF.exe: SHA-256 `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57`; NotSigned.
- SEBWindowsServiceContracts.dll: SHA-256 `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5`; NotSigned.
- hirepro-chromium-installer.exe in the repo: SHA-256 `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16`; NotSigned. Do not assume this is identical to the invite-linked file.
- Unsigned status alone is not proof of malware. Next: request expected vendor hashes/publishers; compare exact installed files in an isolated VM; keep AV enabled unless vendor IT gives a verified, narrow exception.


## Latest combined run verified — 2026-10-09
- Both static REA audit and Windows signature/hash jobs succeeded in workflow run 37904465412.
- Latest REA tests: 321 test files passed, 1 skipped; 3,450 tests passed, 4 skipped.
- The test ledger is audit/test-results.md. These results do not include a live SEB runtime/proctoring test; those cases remain pending.


## Official package identity comparison — 2026-10-09
- General current page https://securetest.hirepro.in/ says to install both Chromium and SEB and links to:
  - https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/Chromium_1.0.1_signed.msi
  - https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/SecureExamBrowserInstaller_en_2.0.2.msi
- The /accenture/ page differs and displays the SEB download + launch handoff. Current tenant/version differences are possible.
- Repo `hirepro-chromium-installer.exe` is a distinct filename/extension and unsigned. Don't equate it to the public signed MSI or to the candidate's installer unless hashes prove that relationship.
- Updated Windows workflow run 37906017253 downloads public MSI files and gathers SHA-256/Authenticode without executing; check its artifact/result before reporting a conclusion.


## Public package comparison completed — 2026-10-09
- Workflow run https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253 succeeded in its Windows package/provenance job; artifact ID 11604756323.
- Official current `Chromium_1.0.1_signed.msi`: 103,059,456 bytes; SHA-256 `946557de73da7aaccda17f9b1af63716492058069cfd6bdd709a825f7666d67f`; Authenticode Valid; signer Hirepro Consulting Pvt Ltd.
- Official current `SecureExamBrowserInstaller_en_2.0.2.msi`: 111,493,632 bytes; SHA-256 `ab22021acbfb81e30ff191d57772e616ec4fd971a88016fe6fd972f9cb322f42`; Authenticode Valid; signer Hirepro Consulting Pvt Ltd.
- Repo `hirepro-chromium-installer.exe`: 102,636,032 bytes; SHA-256 `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16`; NotSigned; not the same byte identity as the current public MSI.
- Repo `SecureExamBrowser.exe` signed by same signer thumbprint as current official MSIs; the service exe and contracts DLL are unsigned individually. This does not establish whether installer package signing covers those internal files or whether the exact candidate build matches.
- See audit/vendor-package-comparison.md. Next high-value read-only comparison is package manifest/contained file hashes, not executing the installer.


## Signed installer payload comparison — 2026-10-09
- Windows job run: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906360710
- Artifact 11604692503: read-only lessmsi extraction / SHA-256 comparison.
- The signed public SEB 2.0.2 MSI contains exact byte/hash matches for all four root artifacts checked: SecureExamBrowser.exe, SebWindowsServiceWCF.exe, SEBWindowsServiceContracts.dll and hirepro-chromium-installer.exe.
- Thus, although service EXE, contract DLL and Chromium EXE are not signed individually, they are identical to files inside the currently published, Authenticode-valid SEB MSI. Do not describe their unsigned status by itself as suspicious.
- Remaining: broaden match to all top-level DLLs; local installed file identity still unknown.
- Updated report: audit/vendor-package-comparison.md; finding F-017.


## Full root dependency match confirmed — 2026-10-09
- Latest Windows comparison run: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190
- Artifact 11604173812 includes hashes and paths for all repository root-level EXE/DLLs.
- Result: 39 of 39 exact SHA-256 matches to same-named files extracted from the current public signed SEB 2.0.2 MSI; zero missing/mismatched files.
- This materially corrects the earlier standalone signature concern: root service/DLL/Chromium components are unsigned individually, but the exact bytes are in an Authenticode-valid vendor MSI. No evidence of injected root-level binaries was found by this comparison.
- User's installed files and candidate-specific asset are still unknown, and no target executable was run.


## Latest CI run consolidated — 2026-10-09
- Workflow run https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190 completed successfully; both jobs succeeded.
- REA built, fast checks/tests passed, and all three managed target artifacts were statically inspected. Latest run's fast suite result is same as preceding run: 321 files passed / 1 skipped; 3,450 tests passed / 4 skipped.
- Windows job downloaded the current public HirePro MSIs, verified Authenticode + SHA-256, extracted the public SEB MSI with lessmsi without installing it, and compared all 39 root-level EXE/DLL files to the package. 39/39 exact matches, 0 mismatches.
- The package comparison confirms repository root-level components correspond exactly to the public signed installer. It does not verify the user's local install or behavior of a running assessment.


## Control map added — 2026-10-09
- New report: audit/control-map.md.
- High-level session path: session-opening references environment checks, prohibited-process checks, local XUL communication server and monitoring startup. Separate control families include process/watchdog, foreground/display, device/desktop/Bluetooth/camera, VM/remote-session preflight, executable integrity, watchdog health, local IPC and log/telemetry reporting.
- Static references establish code structure and call relationships, not runtime activation. Online proctoring data flow and human observation remain separate channels.
- Current public signed SEB MSI contains exact matches for all 39 root EXE/DLL files from the repo; this establishes repository/package provenance for the current public package, not the user's installed identity.
- No live runtime or candidate-session test is done. Next is static configuration/message-flow review; later requires authorized Windows VM evidence.


## Full hash table
- Added audit/vendor-component-hashes.md with each of the 39 root-level EXE/DLL file names, byte lengths, SHA-256, matching extracted MSI path and exact-match flag. All 39 match.


## Local message schema scope — 2026-10-09
- Static REA member metadata shows local native/browser `SEBXULMessage` schema categories for machine/system characteristics, display/camera and device-change state, process-handling summaries, blocked-domain summaries, and watchdog/logger health.
- This is local schema evidence. Do not claim data reaches HirePro without a measured session payload or authorized server receipt. A declared field is not proof it was populated, sent, or retained.

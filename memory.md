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
- Successful workflow: https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37900802418
- Result: complete; REA dependency install, build, fast check and fast tests succeeded. Tests: 321 files passed, 1 skipped; 3,450 passed, 4 skipped. These are REA/toolchain tests, not tests of SecureExamBrowser's runtime.
- Downloadable artifact: Actions artifact ID 11602131772, `seb-static-analysis`.
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

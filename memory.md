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

See plan.md, TODO.md, findings.md, audit/architecture.md and audit/test-matrix.md.

# Initial Architecture Map

**Last updated:** 2026-10-09  
**Evidence maturity:** Initial source/tree review only; runtime identities and links remain to be confirmed.

## Components and boundaries

```text
                         remote exam platform
                    (client scripts / API / server)
                                  ^
                                  | observable network/session events
                                  |
Windows host <--> SecureExamBrowser.exe <--> browser runtime
     ^                    |
     |                    | IPC / WCF (implementation not yet inspected)
     |                    v
     +------------ SebWindowsServiceWCF.exe
                                  |
                          SEBWindowsServiceContracts.dll

Legacy source/config:
  SebWindowsBrowser/xul_seb/modules/*
  SebWindowsBrowser/xul_seb/config*.json
       | correspondence with Windows binaries: unknown

Assessment instrumentation:
  independent Windows process/event observations
  browser/network observations in authorized test session
  app/service logs and authorized test-server records
```

This diagram is a hypothesis framework, not a proven runtime call graph. Confirm arrows from PE/IL, loaded modules, IPC configuration and event-correlated tests.

## Layer A — Windows host/enforcement
Known artifacts: application exe, WCF service exe, contracts DLL, supporting dependencies and service log.

Questions:
- Which component enumerates or subscribes to process/session events?
- Are descendants, foreground focus changes and session transitions observed?
- Which account/privilege context executes each control?
- Which operations enforce policy, and what happens if telemetry is unavailable?
- Do local logs and remote reports represent detector decisions or only application lifecycle?

## Layer B — Embedded browser
Source inspected: SebHost.jsm, SebServer.jsm, SebBrowser.jsm, SebWin.jsm, seb.jsm, SebScreenshot.jsm, SebConfig.jsm, SebUtils.jsm, SebLog.jsm, main/lockscreen XUL and JSON preferences.

Potential functions include URL filtering, popup/window handling, lock/unlock UI, configurable WebSocket commands, screenshots, session clearing and logging. These are static source observations; their presence in the active executable is unverified.

## Layer C — Online page/network
The online platform is not included as source in the repo root. Delivered scripts, endpoints, event uploads, server decisions and retention cannot be inferred from local XUL source alone. Obtain them only through an authorized test session and state limitations explicitly.

## Layer D — Human observation
Human observation is independent of local software instrumentation. Assess what information is available to an observer and what cannot be concluded; do not implement functionality designed to conceal activity from an invigilator.

## Evidence labels
- **Observed:** directly measured or read from an exact, identified artifact.
- **Inferred:** explanation consistent with evidence but not directly confirmed.
- **Unknown:** insufficient evidence or access.
- **Unsupported:** the current platform/tool cannot perform the test.
- **N/A:** not applicable.

Never treat a missing log entry as proof of absence unless channel completeness, time synchronization and capture health are independently established.


## Additional static evidence from main application (2026-10-09)

REA's complete managed metadata inventory of `SecureExamBrowser.exe` (assembly 2.0.2.0, target .NET Framework 4.5.2) shows distinct type groups for process observation/enforcement, foreground/window/display supervision, clipboard and network-activity monitoring, screen-sharing/desktop facilities, camera/VM checks, executable integrity, watchdog health and log protection.

This broadens the architecture hypothesis: the main client itself contains candidate observation/enforcement layers; the service's `IsSebRunning` check is only one narrow lifecycle/recovery behaviour. Do not infer the main client is bypassable or fully effective from type names alone. Runtime activation, active configuration, event delivery and online-server telemetry remain unverified.

The exact artifact identity, counts and evidence limits are in [audit/static-application-analysis.md](static-application-analysis.md). The REA CI workflow run completed static inspection, but did not execute the exam browser.

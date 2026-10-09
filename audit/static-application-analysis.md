# Static Application Analysis — First Pass

**Updated:** 2026-10-09  
**Target:** `SecureExamBrowser.exe` on the investigation branch's checked-out repository snapshot  
**Analysis path:** GitHub Actions workflow `SEB static artifact audit`, run 37901362719  
**Evidence artifact:** [Workflow run and downloadable report](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719)  
**Method:** REA managed PE/CLI inspection and CIL member analysis; target code was not executed.

## Artifact identity

- Repository path: `SecureExamBrowser.exe`
- File length: 1,924,120 bytes
- SHA-256: `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`
- Assembly identity: `SecureExamBrowser, Version=2.0.2.0`
- Module MVID: `704e0878-fd78-47f7-922f-49d7ed0a9f18`
- PE machine: x86 (`0x014c`); PE32 format
- Target framework: .NET Framework 4.5.2
- Managed architecture classification: AnyCPU
- Metadata coverage: complete, with no parser issues reported
- Member inventory: 377 types, 2,212 methods, 2,269 fields, 1,692 member references and 17,867 call edges. Of 2,212 methods, 1,931 have file-backed method bodies and 281 do not; REA reports no truncated method bodies in this inventory.
- Declared boundary inventory: 11 module references, 126 P/Invoke declarations and 273 native-implementation indicators. These indicators are not proof that every native target resolves or that REA reconstructed all native behaviour.

The full machine-readable artifact/member/boundary results are in the Actions artifact linked above; they are not committed as large generated JSON files in the source tree.

## Defensive subsystems observed in metadata

The main application has substantially more security-related structure than the standalone service's process-presence check. Its managed type inventory includes named subsystems for:

- Process-start observation, process management, prohibited-process handling and a process watchdog.
- Foreground/window and display monitoring.
- Clipboard handling and observation of unusually high data-sending activity.
- Screen-sharing, desktop/session control and external-camera/virtual-machine checks.
- Executable-integrity verification, periodic integrity checking, log protection and watchdog-health reporting.
- UI paths for process notices and process management.

This is an inventory of compiled types and method metadata. Type names establish that code with these roles is present in the assembly, but do not prove that every subsystem is enabled in a given exam configuration, that every branch works, or that every event reaches a remote server. Those questions require call-graph review plus controlled runtime evidence.

## What this changes

The earlier service-only review established that `SebWindowsServiceWCF.exe` checks whether the SEB process itself is running as part of its startup-reset behaviour and manages host policies through a service contract. That was not a complete assessment of the main application.

The application binary contains a much broader set of candidate observation and enforcement components. Therefore, the repository cannot responsibly be described as lacking process, foreground/window or integrity monitoring based on the service method alone. We have not established an undetected route around these controls, and this report does not attempt to construct one.

## Remaining unknowns

1. Which subsystems start in the actual competition configuration and when they start/stop.
2. Which effective settings and signed/configured inputs govern these subsystems.
3. What each detector does with benign known-positive test cases, including UI, process enforcement and logging outcomes.
4. How detection results are propagated through the local service and any external endpoint.
5. What online exam-page scripts, remote services or separately installed agents observe.
6. What evidence is recorded outside the local browser and what an in-room human observer can independently see.

## Recommended next audit actions

- Inspect the startup/orchestration and configuration-loading relationships statically, maintaining exact artifact/MVID identities.
- Map detector classes to their lifecycle owner and reported outputs at a high level.
- Use a disposable Windows VM and benign positive-control scenarios to establish which components activate and whether their expected alerts are delivered. Do not infer success from the absence of a UI warning.
- Treat remote-side logic and human observation as separate channels, rather than assuming that local binary changes settle them.

## Limits

This was a static managed-code inventory, not a Windows runtime test, not a decompilation of all dependencies, and not verification of online/server behaviour. Complete parser coverage does not mean complete semantic understanding.


## Call-graph follow-up (static, 2026-10-09)

REA's method-level call-edge inventory provides more than type-name evidence. In the identified main-executable artifact:

- `SebWindowsClient.SebWindowsClientForm.OpenSEBForm` has call edges to `CheckProhibitedProcesses`, `MonitorProcesses` and `SEBXULRunnerWebSocketServer.StartServer`.
- `SebWindowsClient.SebWindowsClientMain.Main` has a call edge to the executable integrity check routine `RunCheckNow`.
- `ProcessWatchDog.CheckRunningProcessesTimer_Elapsed` references `ReportTickStart` and `ReportTickEnd`; `DisplayWatchDog.CheckDisplaysTimer_Elapsed` and `HighDataSendingProcessWatchDog.CheckHighDataSendingProcessTimer_Elapsed` reference `ReportHeartbeat`.
- `ExeIntegrityWatchDog.Start` and its timer callback reference `RunCheckNow`, which references `VerifyCurrentExe` and `ReportCheckNotCompleted`.
- The static call graph has references to log-upload methods such as `SendZippedLogFileToS3` from startup, logging and lifecycle paths. Static references do not prove an upload occurred in the supplied mock-test session.
- The `SEBXULMessage` type declares fields/properties for system and hardware facts including MAC addresses, machine GUID, system model/OS, monitor count, camera presence and device plug/unplug counters. This is a message schema; which fields are populated, sent, or forwarded during this session remains unverified.
- The client has device/desktop methods related to Bluetooth, multiple displays, virtual-machine/remote-connection checks and camera enumeration. Their existence does not establish which conditions the HirePro assessment enables.

This evidence updates the static architecture but does not identify a verified false negative. See [platform observations](platform-observations.md).

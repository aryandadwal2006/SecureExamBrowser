# Static Control Map and Validation Priorities

**Updated:** 2026-10-09  
**Artifact basis:** `SecureExamBrowser.exe`, SHA-256 `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`, MVID `704e0878-fd78-47f7-922f-49d7ed0a9f18`; plus the matched service/contract files.  
**Method:** REA static metadata and CIL/call-edge inspection, plus public package provenance checks. Target binaries were not executed.

## Executive readout

The main application contains multiple distinct control families. The code is not just a browser shell: the static call graph ties the session-opening path to process policy, watchdog setup, local browser communication and executable-integrity checks. The current signed public SEB 2.0.2 MSI also contains byte-identical copies of all 39 root-level repository EXE/DLL files.

**What this proves:** the source artifact includes the named methods and the listed static call relationships, and the repository root binaries match the current public signed installer payload.

**What it does not prove:** which runtime branches execute in the candidate's session, whether every control successfully enforces policy, whether every event reaches the server, or what a human observer independently sees. No Windows runtime or candidate-session telemetry test has been performed.

## Control-family map

| Control family | Static evidence | Expected security purpose | Still unknown / validation requirement |
|---|---|---|---|
| Session startup and preflight | Session-opening method references environment checks, prohibited-process checks, local browser communication startup and monitoring setup. | Establish a supported host/session state before the assessment proceeds. | Active configuration, order of all asynchronous operations, treatment of errors/timeouts, and whether every check is enabled in the candidate's package. |
| Process observation and policy | Process-related watchdog type and timer path; prohibited-process evaluation/handling methods; overlay/foreground-related helpers. | Observe running processes and act on policy violations. | Complete rule coverage, conditions under which the detector is started/stopped, false positives/negatives, and actual event/report delivery. |
| Window, foreground and display state | Foreground watchdog using Windows event hooks; display watchdog with monitor and camera enumeration references. | Observe changes in foreground/display state and enforce supported display/camera requirements. | Runtime activation, exact per-session configuration, UI/error behavior and remote reporting. |
| Desktop and device controls | Session setup/desktop methods, clipboard cleanup, Bluetooth management and camera/device checks. | Limit unsupported host capabilities/devices during an assessment. | Which checks the assessment invokes, whether changes are reversible, and how unexpected OS/API errors are handled. |
| Virtual-machine / remote-session preflight | Dedicated VM and remote-connection check methods are called by session opening. | Reject or flag unsupported execution environments. | Exact environment policy, vendor-configured behavior and whether the platform records each outcome. |
| Executable integrity and watchdog health | Main entry point references immediate integrity check; integrity watchdog runs repeated checks; watcher classes reference heartbeat/tick reporting. | Check the current application's integrity and make monitoring health observable. | Which artifacts are included in integrity scope, failure handling, watchdog independence, and receipt of health signals remotely. Do not assume validation of the main EXE also validates every loaded DLL. |
| Local browser IPC | The session path starts the XUL communication server. Its message type contains system/device metadata fields and event-related handlers. | Coordinate the native client and embedded browser UI/session behavior. | Actual message sequence in the supplied runtime, field population, protocol hardening and whether a given local message is forwarded to a remote service. |
| Logs and telemetry | Main executable call graph references watchdog tick/heartbeat reporting and zipped-log upload routines. | Preserve diagnostics and provide health/evidence signals. | Exact endpoint, transport success, server receipt, retry behavior and retention for this mock assessment. A static method reference is not proof of an upload. |
| Online proctoring layer | User screenshots show a video/audio recording notice; current HirePro privacy policy describes possible proctoring data categories. | Record/review the assessment and associated data under the assessment's configuration. | Actual payloads, sampling intervals, session-specific server rules, human review and any independent endpoint agent. |
| Human observation | Independent from local binary design. | Physical oversight can notice context unavailable to the browser alone. | Whether an observer is present and what is within their view; only the organizer can establish the official observation protocol. |

## End-to-end evidence chain to validate

Use the following model when collecting evidence:

```text
stimulus / host state
        |
        v
detector starts and observes it
        |
        v
decision + local enforcement (if required)
        |
        +----> visible UI result
        |
        +----> local event/log
        |
        +----> watchdog/health or IPC event
                      |
                      v
              network/report layer
                      |
                      v
              authorized server receipt
```

The key measurement is the first point at which expected evidence disappears. An absent on-screen warning alone cannot distinguish a detector miss from a UI issue, a logging gap, a reporting failure or an unobserved server-side event.

## Prioritized next checks

1. **Runtime identity and active configuration:** in an authorized disposable Windows VM, establish exact EXE hashes, loaded module identities, process ancestry and active configuration path.
2. **Known-positive control:** use a documented benign condition that should produce a visible event and verify instrumentation health before interpreting a quiet run.
3. **Lifecycle/report correlation:** compare independent Windows process/session events, visible result, app/service logs and authorized test-server receipts under a common timestamp.
4. **Integrity scope:** compare implementation's documented verification scope with a vendor-confirmed list of shipped components. Current standalone signature/package checks establish package provenance, not runtime integrity-monitor scope.
5. **Platform-specific notice:** collect only permitted, redacted network metadata from an authorized mock session and distinguish client-visible telemetry from server-only rules.

No bypass has been reproduced or ruled out. The control map is intended to turn static leads into a measurable, defensive test plan.

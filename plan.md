# SecureExamBrowser Red-Team Investigation Plan

**Updated:** 2026-10-09  
**Working branch:** redteam/monitoring-audit-2026-10-09  
**Baseline:** main at branch creation  
**Status:** Initial reconnaissance completed; artifact verification and controlled tests are next.

## Objective
Determine, with reproducible evidence, which components of the supplied SecureExamBrowser build observe and enforce exam-session restrictions, how observations become alerts, and whether monitoring gaps exist in the authorized competition environment. A finding must distinguish observed behaviour from inference and unknowns.

## Scope and guardrails
- Work only against the supplied build in an isolated Windows VM or another explicitly authorized test environment.
- Preserve hashes and an untouched baseline before changing any artifact.
- Prefer read-only static inspection before executing unknown binaries.
- Do not test against a live exam, real candidate account, or production proctoring system.
- Do not implement stealth toggles, suppress detection telemetry, tamper with evidence, or provide procedures for disguising prohibited activity from an invigilator.
- Do not generalize a local test result to server-side or human observation unless those channels were independently observed.

## System model
Treat these as separate observation layers until evidence proves a dependency:
1. Windows host controls and process state.
2. SecureExamBrowser.exe, browser runtime, configuration, and loaded libraries.
3. SebWindowsServiceWCF.exe, WCF contracts, IPC and privilege boundary.
4. Online exam client and network/server event path.
5. Human observation and any separate camera, room-monitoring or endpoint agent.

For every suspected control, trace: **signal/source → detector → decision → enforcement → local record → remote record**.

## Workstreams

### WS0 — Preserve and identify the target
- [ ] Record commit SHA, paths, sizes, file versions, SHA-256 hashes, signatures and PE architecture for relevant executables/DLLs.
- [ ] Identify launch chain, process tree, command-line config inputs, loaded browser runtime and active configuration.
- [ ] Preserve original artifacts read-only; conduct experiments against copies/snapshots.
- Exit criterion: artifact manifest and repeatable clean restore procedure exist.

### WS1 — Static analysis
- [ ] Build and verify the bundled REA project in a separate working copy.
- [ ] Use REA managed PE/CLI inventory and member inspection on the application, service and contract DLL.
- [ ] Use a suitable .NET decompiler for C#-like reconstruction where needed; REA managed inspection is not a full C# decompiler.
- [ ] Trace process/foreground observation, service commands, event tracing, registry/policy changes, configuration loading, alert reporting and IPC authentication.
- [ ] Preserve exact artifact hashes, method identities, IL/native boundaries, call edges and coverage limitations.
- Exit criterion: evidence-backed call graph with unknowns marked explicitly.

### WS2 — Browser source/config correspondence
- [ ] Compare legacy XUL modules and committed JSON with packaged files and runtime behaviour.
- [ ] Identify effective config precedence, signature/integrity checks, reconfiguration paths and whether legacy components are used.
- [ ] Check which messaging channels are actually enabled; do not infer runtime enablement from source defaults.
- Exit criterion: each relied-upon source/config fact is connected to the target build or labelled unconfirmed.

### WS3 — Monitoring coverage tests
- [ ] Establish independent baseline telemetry and one known-positive control case.
- [ ] Execute the benign test matrix in audit/test-matrix.md in a disposable VM.
- [ ] Correlate process/session events, browser UI, app/service logs, Windows telemetry and authorized test-server events by timestamp.
- [ ] Repeat candidate false negatives after restoring a clean snapshot.
- Exit criterion: claims about detection or alert absence are backed by channel-by-channel records.

### WS4 — Online boundary
- [ ] In an authorized test session, inventory delivered scripts, requested permissions, network endpoints and observable session events.
- [ ] Separate client-side observations from server-side decisions and independent monitoring agents.
- [ ] Record unavailable remote logic as unknown.
- Exit criterion: data-flow map identifies direct observations and unresolved areas.

### WS5 — Findings and reporting
- [ ] Give each finding an ID, severity rationale, prerequisites, evidence, reproduction procedure, impact, confidence and limitation.
- [ ] Keep negative results and failed/unsupported cases.
- [ ] Produce a concise evidence-backed report and remediation suggestions for verified defensive gaps.
- Exit criterion: another tester can reproduce the result against the documented build and environment.

## Decision gates
1. Do not patch binaries before WS0–WS2; first establish that a suspected control exists and is active.
2. Do not call a test a bypass unless independent telemetry confirms the event occurred and all relevant detection/reporting channels have been checked.
3. Do not infer global stealth from one absent warning. Server telemetry, independent agents, stored evidence and human observation are distinct channels.
4. Do not modify main; keep investigation notes and permitted test tooling on this branch.

## Initial status
See findings.md and audit/architecture.md. Initial source review is not runtime validation; the Windows executables have not yet been decompiled or dynamically tested in this workflow.

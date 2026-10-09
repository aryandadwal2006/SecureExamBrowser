# SecureExamBrowser Red-Team Investigation Plan

**Updated:** 2026-10-09  
**Working branch:** redteam/monitoring-audit-2026-10-09  
**Baseline:** main at branch creation  
**Status:** Repository reconnaissance and static PE/CLI inventory completed by CI; isolated Windows runtime tests are next.

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
- [x] Record repository object IDs, sizes, raw SHA-256 hashes, assembly versions/MVIDs and PE architecture for the three managed application/service artifacts (audit/artifact-manifest.md).
- [x] Verify Authenticode signature status and raw SHA-256 for the repository GUI, service, contracts DLL and Chromium installer on a Windows CI runner (audit/artifact-manifest.md).
- [ ] Verify product/file-version metadata and exact installed/runtime file identity in a Windows VM.
- [ ] Identify launch chain, process tree, command-line config inputs, loaded browser runtime and active configuration.
- [ ] Preserve original artifacts read-only; conduct experiments against copies/snapshots.
- Exit criterion: artifact manifest and repeatable clean restore procedure exist.

### WS1 — Static analysis
- [x] Build REA in GitHub Actions; fast checks and the fast suite passed.
- [x] Use REA managed PE/CLI inventory, member/CIL inspection and native-boundary inventory on the application, service and contract DLL.
- [ ] Use a suitable .NET decompiler for C#-like reconstruction where needed; REA managed inspection is not a full C# decompiler.
- [ ] Trace process/foreground observation, service commands, event tracing, registry/policy changes, configuration loading, alert reporting and IPC authentication.
- [x] Preserve artifact hashes, MVIDs, type/method inventory sizes and coverage limitations in the audit reports.
- [ ] Complete focused call-graph tracing of startup/configuration, enforcement and reporting relationships.
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
- [ ] In an authorized test session, inventory delivered scripts, requested permissions, network endpoints and observable session events; the visible recording notice/public privacy policy have been documented, but session-specific payloads are still unmeasured.
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

## Current status
See findings.md, audit/static-application-analysis.md, audit/static-service-analysis.md, audit/artifact-manifest.md and audit/test-results.md. REA successfully built, passed its fast checks and fast tests, and produced static inventories for the main app, service and contracts DLL. Static inspection is not runtime validation. Windows Authenticode/hash checks and static artifact analysis have run successfully. No SEB runtime or online-platform event-correlation tests have run, and no bypass has been claimed.


## Platform-flow follow-up
The user-provided screenshots and HirePro public page have been documented in audit/platform-observations.md. The browser external-application handoff, SEB's app-closing notice and the visible video/audio recording notice are separate from Windows service policy. Static main-client call edges connect startup/session paths to process monitoring and watchdog/integrity reporting, but runtime activation and remote receipts remain unverified.


## Static control map
The system-level map is now consolidated in [audit/control-map.md](audit/control-map.md), including each control family, observable/expected output, unverified runtime behavior, and prioritized validation steps. The static phase can be deepened through configuration/data-flow inspection; Windows runtime claims remain blocked pending a disposable lab.


For the fastest continuation, see [audit/README.md](audit/README.md), which links the evidence and summarizes the static/provenance results and remaining runtime blockers.


## Legacy source/config checkpoint
A corrected canonical-byte check found 12 selected legacy XUL/config/startup files in exact hash agreement with the signed public SEB MSI. See [audit/legacy-source-package-comparison.md](audit/legacy-source-package-comparison.md). Sample configuration files do not establish the effective per-session configuration; active settings and actual capture/report behavior remain pending an authorized Windows runtime test.


## Defensive assurance checkpoint
Recommended hardening and acceptance criteria are documented in [audit/defensive-hardening-recommendations.md](audit/defensive-hardening-recommendations.md). They focus on explicit effective configuration, detector readiness/failure semantics, authenticated IPC, event correlation, package integrity and accurate recording disclosure. They are design recommendations, not claims that those controls are currently absent.


## Human-observation track
The human-observation layer is documented in [audit/human-observation-protocol.md](audit/human-observation-protocol.md). Actual validation requires an authorized mock session with organizer approval; no such in-room exercise has been performed.

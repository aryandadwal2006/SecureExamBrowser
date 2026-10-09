# Isolated Monitoring Validation Matrix

**Last updated:** 2026-10-09  
**Purpose:** Defensive validation of monitoring and alert delivery. Use a disposable VM, synthetic exam page and harmless test processes. Do not use a live candidate account or production exam service.

## Preconditions
- [ ] Record hashes, file versions and effective configuration; preserve untouched artifacts.
- [ ] Make a restorable VM snapshot.
- [ ] Establish time synchronization and a shared timestamp format.
- [ ] Enable independent host-side process/event capture.
- [ ] Verify expected log/telemetry collectors are functioning.
- [ ] Run a known-positive control that should yield a documented alert.
- [ ] Store raw evidence separately; redact credentials and session tokens before sharing.

## Cases

| ID | Test question | Controlled stimulus | Independent evidence | Required interpretation | Status |
|---|---|---|---|---|---|
| T-001 | Is the expected build running? | Start supplied test build from a clean snapshot. | Executable hashes, process tree, loaded modules, command line and active config path. | If identity/config is ambiguous, downstream tests are inconclusive. | Not run |
| T-002 | Does a known-positive control reach the expected alert? | Use a documented harmless positive-control condition. | Host event, app/service log, UI outcome and test-server event. | If the control fails or capture is incomplete, silent outcomes cannot count as false negatives. | Not run |
| T-003 | Is external-process observation functioning? | Launch a benign, clearly named test application during a synthetic session without hiding it or suppressing signals. | Process-start event, parent/child relationships, detector output, UI/log/server outcomes. | An absent UI warning alone does not show detector failure. | Not run |
| T-004 | Does timing alter coverage? | Repeat benign process observation at documented lifecycle points; restore VM between trials. | Session lifecycle timestamps and process telemetry. | Differences require equivalent build/config and healthy collectors. | Not run |
| T-005 | Is process lineage covered? | Compare a benign directly launched test app with a benign child from a known test harness. | Parent/child PIDs, image hashes, detector events and reporting records. | Do not infer complete descendant coverage from one sample. | Not run |
| T-006 | Are focus/session events recorded? | Use a test page and ordinary visible focus/window changes. | Page visibility/focus events, window/process state, network records and authorized server logs. | Separate page-observed events from host-wide telemetry. | Not run |
| T-007 | Are lock/reconnect transitions fail-safe? | Exercise documented lock/reconnect/error flows only in the isolated build. | UI state, socket/service state, timestamps, logs and authorized test-server events. | Unknown state or missing telemetry is not a pass. | Not run |
| T-008 | Is configuration provenance sound? | Compare documented test config with active path and supported reconfiguration flow. | Config hashes, integrity/signature results if present, load messages and effective settings. | Unsupported authentication claims remain unknown. | Not run |
| T-009 | Does detection propagate to expected sinks? | Trigger a known-positive control and trace it end to end. | Detector record, service IPC/event, app log, server receipt and timestamps. | Identify the first missing link rather than merely saying no alert. | Not run |
| T-010 | Are logs sensitive or incomplete? | Inspect logs from ordinary test flows and startup/shutdown. | Log paths, access controls, redacted content and tracing settings. | Never export credentials, auth tokens, personal data or real exam records. | Not run |
| T-011 | What online monitoring is independently visible? | In an authorized test session, inventory delivered scripts, permissions, endpoints and available event records. | Browser network export, script hashes, permission prompts and authorized server logs. | List inaccessible server-side logic and separate agents as unknown. | Not run |
| T-012 | Is a finding reproducible? | Restore snapshot and repeat candidate finding under documented conditions. | Manifest, raw timestamps, logs and VM/config identifiers. | Repeatability requires the same prerequisites and observable result. | Not run |

## Per-run evidence template
- Test ID and timestamp (ISO 8601 with timezone).
- VM/snapshot identifier, OS build and user privilege level.
- Artifact hashes and active-config hash.
- Benign stimulus and expected result.
- Independent host telemetry.
- Application/browser/service observations.
- Authorized remote/test-server observations.
- Collector health and known blind spots.
- Verdict: pass, fail, inconclusive or unsupported.
- Raw evidence IDs and SHA-256 digests.
- Result after clean restore.

## Verdict rules
- **Pass:** expected detection/reporting observed with functioning collectors.
- **Fail:** defined control failed its requirement and independent evidence is sufficient.
- **Inconclusive:** a relevant observation channel is missing or unverified.
- **Unsupported:** required environment/tool capability is unavailable.
- **False negative:** use only when the stimulus definitely occurred, coverage is expected, independent capture is healthy and the expected detection/reporting event is absent.

A concealment toggle and intentional suppression of alerts/telemetry are outside this matrix.

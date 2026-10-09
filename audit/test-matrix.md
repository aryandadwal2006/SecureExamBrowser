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
| T-013 | Is the launch handoff bound to the intended assessment? | Use the authorized test link and record the browser external-application prompt plus the target app/process identity. | Browser origin, prompt text, process tree, exact executable hash and sanitized launch/config identifiers. | Distinguish a browser protocol prompt from UAC; do not store personal session tokens. | Not run |
| T-014 | Are documented process/device restrictions active? | Use benign, approved positive controls for app closure and advertised device/desktop requirements in a disposable VM. | Independent Windows process/device/session telemetry, app/service logs and UI results. | Do not infer coverage from a warning alone; do not alter or suppress controls to hide activity. | Not run |
| T-015 | Do watchdog and integrity events reach their intended sinks? | Use only the vendor's documented benign positive-control event and supported diagnostics. | Detector status, watchdog heartbeat/tick markers, integrity-check outcome, local log and authorized test endpoint receipt. | A missing UI warning is not a pass; verify collector health and end-to-end receipt. | Not run |
| T-016 | What data is actually transmitted in the authorized test session? | In a dedicated test session, capture only permitted client/network evidence and compare it with public notices. | Redacted network metadata, script hashes, client logs and organizer-provided server event IDs. | Separate schema/policy descriptions from measured payloads; never export credentials or recording contents into the repo. | Not run |
| T-017 | Is recording UI/permission state consistent with the organizer's notice? | Use the approved mock assessment and ordinary camera/microphone permission flow. | Visible notices, OS permission state, authorized test-server receipt/recording indicator where provided. | Do not suppress, fake or conceal recording. Report gaps through the authorized channel. | Not run |
| T-018 | Is integrity validation documented for every shipped/loaded component? | Compare the implementation's integrity-coverage definition with an exact, vendor-confirmed component manifest and expected hashes; do not alter binaries. | Main executable MVID/hash, service/DLL/installer identities, integrity-verification code references and vendor-supplied expected values. | A valid signature on one executable does not establish trust in neighboring components; unsigned status is not itself proof of malware. | Not run |

| T-019 | Are privileged service operations restricted to the intended authenticated client? | In an authorized disposable VM, use a vendor-approved harness to exercise only documented benign operations from an authorized client and an unauthorized synthetic client. | Endpoint/binding configuration, caller identity, service/app logs, host state before/after, and an authorized test receipt if available. | Unauthorized requests must be rejected before side effects; operation reachability and access policy remain unknown until tested. | Not run |

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


## Evidence from the user's public-page/screenshot review

The HirePro landing page indicates that the web UI launches the native application through an explicit browser confirmation and warns that SEB closes other applications. The screenshots also show a video/audio recording notice. These observations motivated T-013 through T-017; they are not outcomes of executed tests. See [audit/platform-observations.md](platform-observations.md).


## Latest completed automation
The successful GitHub Actions run [37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412) completed REA build/check/test and Windows hash/signature collection. Results and all pending runtime cases are summarized in [audit/test-results.md](test-results.md).


## Source-level screenshot follow-up

The legacy XUL source contains browser-window screenshot code and a screenshot-data handler, but activation and correspondence to the current package are unverified. This increases the importance of treating screenshot capture, webcam recording, and full-desktop capture as different test questions. A future test must use documented diagnostics and authorized session evidence; do not infer “not captured” from a missing UI notification.


## Service authorization follow-up

Static analysis identifies a Windows service endpoint, registry-policy management operations and a process-launch helper. Their existence does not prove an externally reachable vulnerability. T-019 is the required high-level assurance test; it must use a documented harness and non-destructive requests in a disposable VM. See [privileged-service-authorization-review.md](privileged-service-authorization-review.md).

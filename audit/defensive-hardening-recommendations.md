# Defensive Hardening and Assurance Recommendations

**Updated:** 2026-10-09  
**Purpose:** Recommendations for improving demonstrable security assurance of the current SEB/HirePro browser and assessment integration. This is a design/review document, not a claim that each control is missing.

## 1. Effective configuration integrity

**Problem to prevent:** Repository sample profiles do not show the effective configuration for a live assessment. A signed installer alone does not establish which settings a session received.

Recommended controls:
- Treat the assessment-provided configuration as a security-sensitive artifact: verify authenticity and integrity before applying it.
- Record a non-secret configuration identifier and cryptographic digest at session start.
- Validate required settings against a versioned policy schema; reject invalid, contradictory or unsupported combinations rather than silently falling back.
- Make the effective policy discoverable in an authorized diagnostic report. Avoid logging secrets, exam tokens, candidate IDs or unnecessary device identifiers.
- Include negative tests for missing, malformed, stale and unauthorized configuration inputs.

Acceptance evidence: the same configuration digest and policy version appear in the local diagnostic record and authorized server receipt for a mock session.

## 2. Monitoring startup and fail-closed semantics

**Problem to prevent:** A detector can exist in the binary yet fail to start, terminate, or silently lose its event path.

Recommended controls:
- Model each mandatory detector as an explicit lifecycle state: requested, initializing, active, unhealthy and stopped.
- Before enabling a high-stakes session, require explicit readiness from each mandatory detector and the relevant local communication channel.
- If a mandatory monitor or health channel fails after launch, apply a documented and accessible recovery path instead of silently continuing as if monitoring were healthy.
- Separate a detector’s finding from its heartbeat/health signal; the server should distinguish “no violation observed” from “monitor is unavailable.”
- Add tests for startup failure, watchdog timeout, IPC loss/reconnection, delayed events and duplicate/out-of-order events.

Acceptance evidence: fault injection in a lab produces a deterministic degraded/unhealthy state that appears in local evidence and the authorized server receipt.

## 3. Event correlation and server-side evidence

**Problem to prevent:** A missing warning cannot be interpreted when the browser, local logs and server receipt are not correlated.

Recommended controls:
- Add unique event IDs and a monotonic per-session sequence number to security-relevant events.
- Timestamp at observation and receipt; preserve both values when possible.
- Use authenticated transport with explicit retry/idempotency semantics and bounded event queues.
- Emit an explicit “monitor healthy” heartbeat independently of violation events.
- On the server, record gaps in sequence, stale heartbeats, invalid configuration versions and reconnect periods as diagnostic events, not as proof of misconduct.
- Provide test-session receipts to authorized QA/security staff, with secrets and personal data redacted.

Acceptance evidence: scripted benign-positive controls can be traced from the host observation to the server receipt without relying on a visible warning alone.

## 4. IPC and protocol hardening

**Review priority, not a confirmed vulnerability:** The repository contains local IPC/WebSocket message paths. The current static review has not established their complete runtime authorization properties.

Recommended controls:
- Restrict local endpoints to the expected process/session and use an authentication mechanism that is not satisfied merely by connecting to loopback.
- Validate message schema, length, type, session binding and allowed handler for every message.
- Reject unknown or malformed commands; enforce per-session authorization for sensitive administrative operations.
- Enforce TLS and endpoint identity for remote control/report channels; use explicit timeouts and bounded message sizes.
- Test unauthorized local clients, malformed messages, reconnect storms and stale-session messages in an isolated harness.

Acceptance evidence: a protocol conformance suite demonstrates that unauthorized or malformed messages are rejected and logged, while authorized test messages continue to work.

## 5. Executable and package integrity

**Observed baseline:** The current public SEB 2.0.2 MSI has a valid Authenticode signature. The repository's 39 root-level EXE/DLLs and 12 selected legacy source/config assets match the extracted signed package by SHA-256.

Recommended controls:
- Verify the installer signature before use and retain the expected signer/publisher identity.
- Maintain a signed component manifest covering app binaries, helper executables, DLLs, scripts, configuration assets and update payloads.
- At build/release time, compare the package against the expected manifest and fail release on unknown, missing or mismatched components.
- Keep a versioned build ID, assembly MVIDs, package hash and configuration schema version in diagnostic evidence.
- Ensure integrity checks cover all security-relevant loaded components, not only the main EXE, and test those checks through supported benign positive controls.

Acceptance evidence: the release pipeline creates a signed manifest and produces a reproducible component inventory tied to the public package identity.

## 6. Privacy clarity and data minimization

**Observed uncertainty:** The UI says video/audio are recorded; public policy describes possible proctoring and device/browser data. Session-specific screen-pixel capture, sampling intervals and retention were not established by this static audit.

Recommended controls:
- Document separately whether a deployment uses webcam/audio, browser navigation telemetry, host process/window/display state, browser-window images, full-desktop image/video, and human live review.
- Surface the effective recording/capture mode before launch and retain the notice version for the session.
- Configure data minimization, retention, access controls and audit logs for recordings and device metadata.
- Do not rely on a generic privacy policy as a substitute for an accurate assessment-specific notice.
- Give candidates an organizer/contact route for questions about the exact data captured and retained.

Acceptance evidence: a test session's notice, effective policy and approved data-flow inventory agree.

## 7. Regression test plan

Run these only in an authorized disposable Windows VM/test tenant:
1. Baseline: clean boot, known supported configuration, all mandatory monitoring readiness signals healthy.
2. Positive control: a vendor-documented benign policy violation produces the expected local result and server receipt.
3. Health failure: stop or disconnect a test-only monitor through a supported harness; verify unhealthy state is visible and cannot be confused with “nothing happened.”
4. IPC fault: simulate reconnect and malformed messages through a test harness; verify protocol rejection and bounded recovery.
5. Configuration integrity: use valid, malformed, stale and unauthorized test configs; verify deterministic acceptance/rejection.
6. Package integrity: use the build's supported verification test hooks; never patch a live assessment binary.
7. Privacy notice: verify the visible notice matches the effective mode and the authorized test record.

For each test, capture artifact hashes, active configuration digest, VM snapshot ID, independent host evidence, app/service logs and server receipt/event IDs. Use synthetic test accounts and redact secrets/recordings from the repository.

## 8. Limits

This audit did not run SEB or a live assessment. These items are proposed assurance controls, not findings that a particular vulnerability exists. No evasion/bypass has been reproduced or ruled out by static analysis.

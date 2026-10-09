# Privileged Service Authorization Review

**Status:** High-priority validation item; no exploitability conclusion.  
**Evidence:** Static member/CIL inventory of the exact repository service build and contract DLL; see the latest `seb-static-analysis` workflow artifact and [static-service-analysis.md](static-service-analysis.md).

## What the static evidence establishes

- The Windows service has a host-initialization path that registers a service endpoint.
- Its managed types include registry-policy management operations and a helper that starts a process and captures standard output.
- The client application has service-handler methods that invoke service operations.
- The service and contract files match the current public installer payload by SHA-256.

## What it does not establish

Static metadata alone does not prove:
- which client identities can connect to the endpoint;
- whether transport-level or method-level authorization blocks untrusted callers;
- whether command execution is restricted to a fixed set of trusted internal operations;
- whether any caller-controlled data reaches a process command line;
- whether an operation is reachable in the effective assessment configuration.

This is therefore **not a confirmed vulnerability**, and no method invocation sequence has been constructed.

## Defensive verification required

In a disposable, authorized Windows VM, maintainers should establish:
1. The exact endpoint binding, security mode, and local access-control list.
2. The authenticated caller identity expected by every management operation.
3. Whether each operation is an explicit allow-listed action rather than a generic command interface.
4. Whether any process-launch helper uses fixed executable/argument definitions and rejects untrusted inputs.
5. Whether unauthorized test clients are denied, and denial is logged without leaking sensitive request data.
6. Whether operations that alter host policy have a documented lifecycle and are restored safely after normal and abnormal shutdown.
7. Whether the UI/service log and an authorized test receipt agree on the outcome of both authorized and denied test requests.

Use a vendor-approved harness and benign, non-destructive operations only. Do not test this by attempting to alter a live assessment, suppress monitoring, or invoke undocumented service operations.

## Acceptance criteria

- All unauthorized requests are rejected before side effects.
- Only explicitly permitted and authenticated operations execute.
- Invalid/unexpected requests fail closed and leave the host unchanged.
- Logs record outcome, caller class, request ID and reason without tokens or other secrets.
- Tests are repeatable from a clean VM snapshot.

Until these checks are run, endpoint authorization and process-launch reachability remain **unknown**.

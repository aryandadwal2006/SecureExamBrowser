# Initial Findings Register

**Last updated:** 2026-10-09  
**Confidence policy:** Source observations are not proof of runtime behaviour; limits are recorded per finding.

## F-001 — Compiled Windows enforcement is the main unresolved area
- **Status:** Open / high priority.
- **Observation:** Repository contains SecureExamBrowser.exe, SebWindowsServiceWCF.exe and SEBWindowsServiceContracts.dll, but initial tree review did not locate their corresponding C# source trees.
- **Evidence:** [Root repository](https://github.com/aryandadwal2006/SecureExamBrowser); [application config](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SecureExamBrowser.exe.config).
- **Confidence:** High for artifact presence; unknown for internal runtime behaviour.
- **Next action:** Hash and inspect exact binaries, enumerate managed methods and reconstruct relevant call chains.
- **Not established:** A detector weakness, a bypass, or coverage of any particular process/event.

## F-002 — Legacy XUL source has configurable process-monitoring setting
- **Status:** Open / correspondence unverified.
- **Observation:** SebWindowsBrowser/xul_seb/config.default.json includes monitorProcesses: false and enableLogging: false.
- **Evidence:** [Default config](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/config.default.json).
- **Confidence:** High for values in this committed file.
- **Next action:** Establish whether this configuration is read by target build and whether process monitoring is implemented separately in the C# service.
- **Not established:** Effective settings during the competition run.

## F-003 — Two browser-side messaging channels exist in the legacy source
- **Status:** Open / security-boundary review.
- **Observation:** SebHost.jsm contains a configurable WebSocket message dispatcher; SebServer.jsm contains a separate server channel and command dispatcher.
- **Evidence:** [SebHost.jsm](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebHost.jsm); [SebServer.jsm](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebServer.jsm); [config.json](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/config.json).
- **Confidence:** High for source structure.
- **Next action:** Check effective configuration, endpoint/transport, server authentication, command validation and whether this browser generation is active.
- **Not established:** An unauthenticated exploitable endpoint or reachable channel.

## F-004 — Active configuration and source-to-binary mapping are unknown
- **Status:** Open / critical prerequisite.
- **Observation:** Repository has multiple JSON configs and legacy XUL source alongside compiled Windows binaries and a large browser installer.
- **Evidence:** [Browser source tree](https://github.com/aryandadwal2006/SecureExamBrowser/tree/main/SebWindowsBrowser/xul_seb).
- **Confidence:** High for repository contents.
- **Next action:** Observe launch arguments, loaded modules, active config path and executable ancestry in isolated VM.
- **Impact:** Claims based only on a committed config/source file may be irrelevant to the running build.

## F-005 — Host policy changes appear in checked-in service log
- **Status:** Open / contextual evidence.
- **Observation:** Log includes changes to Windows policy values related to Task Manager, workstation locking and password changes; it also records Windows Update being stopped/restarted.
- **Evidence:** [Service log](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/sebwindowsservice.log).
- **Confidence:** High that the log contains these records; provenance/time correspondence to the competition build is unverified.
- **Next action:** Connect records to responsible service methods and validate on a clean VM.
- **Not established:** Comprehensive external-browser detection or its absence.

## F-006 — Historical diagnostic trace exposure is documented in executable config comments
- **Status:** Verify as regression check.
- **Observation:** SecureExamBrowser.exe.config comments describe removal of WCF message logging after sensitive IPC material had been written to a plaintext trace.
- **Evidence:** [Executable config](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SecureExamBrowser.exe.config).
- **Confidence:** High that comments state this; historical incident is not independently corroborated here.
- **Next action:** Verify shipped configs and runtime tracing settings; ensure test logs are sanitized.
- **Not established:** Current exposure.

## F-007 — Browser-side screenshot code exists
- **Status:** Open / active-use unknown.
- **Observation:** SebScreenshot.jsm creates screenshots from browser-window content and exposes a function to the XUL window. SebServer.jsm has a screenshot-related handler.
- **Evidence:** [Screenshot module](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebScreenshot.jsm); [server module](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebServer.jsm).
- **Confidence:** High for the available source functions.
- **Next action:** Determine whether functions are wired, when they are called, and whether screenshot data reaches an endpoint in target environment.
- **Not established:** Continuous screen capture or specific remote monitoring behaviour.

## Test status
No native Windows runtime test or executable decompilation has yet been completed through this investigation session. Do not label a bypass found or disproven. Continue with audit/test-matrix.md, independently instrumenting observation channels and repeating candidate findings from a clean snapshot.

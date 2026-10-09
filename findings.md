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
REA static PE/CLI, member/CIL and managed/native-boundary inventory completed for the main executable, service and contracts DLL through GitHub Actions. No native Windows runtime test or full source-like C# decompilation has yet been completed. Do not label a bypass found or disproven. Continue with audit/test-matrix.md, independently instrumenting observation channels and repeating candidate findings from a clean snapshot.


## F-008 — Main client contains multiple security-monitoring subsystems
- **Status:** Open / static analysis completed; runtime validation pending.
- **Observation:** REA's complete managed inventory for the exact main executable contains process-start observation, prohibited-process handling, a process watchdog, foreground/window and display monitoring, clipboard handling, screen-sharing/desktop utilities, camera/VM checks, executable-integrity verification and watchdog-health/log-protection components.
- **Artifact:** `SecureExamBrowser.exe`, SHA-256 `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`, assembly `2.0.2.0`, MVID `704e0878-fd78-47f7-922f-49d7ed0a9f18`.
- **Evidence:** [Static application analysis](audit/static-application-analysis.md); [GitHub Actions run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719).
- **Confidence:** High that these type/method declarations are present in this artifact; unknown whether each component is enabled or effective in a given configuration.
- **Impact:** The previous service-only check cannot be treated as a complete model of the browser's monitoring. Broader client-side controls are present and need controlled validation.
- **Next action:** Map configuration/lifecycle to these components, run known-positive controls and correlate independent Windows evidence with browser/service/test-server outputs.
- **Not established:** That every detector is activated, that online/remote monitoring is absent, or that a bypass exists.

## F-009 — Automated static-analysis pipeline succeeded
- **Status:** Completed for this repository snapshot.
- **Observation:** GitHub Actions run 37901362719 completed successfully. REA dependency install, build, fast check (types/lint) and fast test suite passed; static inspection produced artifact, member and managed/native-boundary reports for the main executable, service executable and contracts DLL.
- **Test output:** 321 test files passed, 1 skipped; 3,450 tests passed, 4 skipped. This validates the REA toolchain and its tests, not SecureExamBrowser's runtime security.
- **Evidence:** [Run and artifact](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719).
- **Next action:** Review the uploaded static reports, then perform isolated Windows runtime validation.


## F-010 — HirePro launch prompt and recording notice are separate platform layers
- **Status:** Observed / platform-specific behaviour documented; per-session capture not verified.
- **Evidence:** User-supplied screenshots show the browser asking permission to open Secure Exam Browser, the running client labelled 2.0.2 and a UI notice that video/audio are recorded for integrity review. The public HirePro Accenture SEB page independently documents the launch handoff and warns that SEB closes running applications and the test cannot be left without exiting.
- **References:** [HirePro Accenture SEB page](https://securetest.hirepro.in/accenture/); [HirePro privacy policy](https://hirepro.in/privacy-policy/); detailed notes in [audit/platform-observations.md](audit/platform-observations.md).
- **Confidence:** High for visible screenshot/public-page text; unknown for actual camera/microphone data flow, remote alert rules and human review in this individual session.
- **Interpretation:** The “Open Secure Exam Browser?” dialog in the screenshot is a browser external-application launch prompt, not by itself a Windows UAC privilege-elevation dialog.
- **Not established:** That accepting or dismissing that prompt affects other detectors or human observation.

## F-011 — Main-app call edges connect monitoring routines to session lifecycle
- **Status:** Static analysis completed / dynamic validation pending.
- **Observation:** The exact-build CIL/call graph shows `OpenSEBForm` calling `CheckIfInsideVirtualMachine`, `CheckIfRunViaRemoteConnection`, `CheckProhibitedProcesses`, `StartServer` and `MonitorProcesses`. `MonitorProcesses` references setup for process, display, foreground and high-data activity watchers. The process watchdog's timer routine references prohibited-process evaluation and enforcement calls, plus tick reporting; the display watchdog references monitor/camera enumeration; executable-integrity checking is called from startup and a watchdog path.
- **Artifact:** `SecureExamBrowser.exe`, SHA-256 `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e`, MVID `704e0878-fd78-47f7-922f-49d7ed0a9f18`.
- **Evidence:** [audit/static-application-analysis.md](audit/static-application-analysis.md); [successful REA CI run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37901362719).
- **Confidence:** High that these static call edges exist in the identified artifact; runtime activation and outcome unknown.
- **Impact:** The earlier WCF-service-only model was incomplete. These lifecycle paths need controlled positive-control tests, especially around process/device policy and local-to-remote event propagation, rather than an inference based on the service's narrow SEB-process-presence check.
- **Next action:** Validate benign documented positive controls and correlate independent Windows evidence with app/service logs and authorized endpoint receipts.
- **Not established:** Complete detector effectiveness, event delivery for the user's session, or a bypass.

## F-012 — Published privacy policy includes proctoring recordings and device/session data
- **Status:** Public-policy observation; data use in this specific assessment not independently measured.
- **Observation:** HirePro's privacy policy lists video/audio recording and captured live images through proctored assessments, device information, IP address/derived location, assessment performance, pages accessed and links clicked among possible service data. It describes processing on behalf of a customer/partner under that party's instructions.
- **Evidence:** [HirePro privacy policy](https://hirepro.in/privacy-policy/), updated 13 January 2026; [audit/platform-observations.md](audit/platform-observations.md).
- **Next action:** Keep platform and local-app observations separate; ask the assessment organizer for the specific session's notice, retention and contact for data-processing questions.
- **Not established:** Which optional collection categories were enabled for this session or who reviewed the footage.

## F-013 — Installer guidance asks users to disable antivirus / override Defender warning
- **Status:** Informational supply-chain caution, not a malware finding.
- **Observation:** The public HirePro Accenture SEB landing page lists antivirus disabled as an installation requirement and instructs users to choose “More Info” / “Run Anyway” if Windows Defender warns during installation.
- **Evidence:** [Public installation guide](https://securetest.hirepro.in/accenture/).
- **Risk:** Broadly disabling protection or overriding a warning without verifying artifact provenance increases endpoint risk.
- **Recommendation:** Independently verify publisher/signature and request an official hash or confirmation from the employer/HirePro if provenance is unclear. This observation alone does not show the installer is malicious.


## F-014 — Authenticode trust differs across checked-out components
- **Status:** Observed / provenance review required.
- **Observation:** The Windows preflight reports `SecureExamBrowser.exe` as `Valid`, signed by `CN=Hirepro Consulting Pvt Ltd`. The checked-out `SebWindowsServiceWCF.exe`, `SEBWindowsServiceContracts.dll` and `hirepro-chromium-installer.exe` return `NotSigned`.
- **Evidence:** [Windows provenance workflow run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412), artifact ID 11603138113; full identities in [audit/artifact-manifest.md](audit/artifact-manifest.md).
- **Confidence:** High for Authenticode status and hashes of the repository checkout inspected by the Windows runner.
- **Impact:** The GUI executable's valid signature does not extend automatically to its neighboring service, DLL or installer. Their provenance needs separate verification.
- **Limitation:** Unsigned does not mean malicious, and the repo's large Chromium installer has not been shown to be identical to the candidate's email-linked download.
- **Next action:** Obtain expected vendor hashes/publishers and verify the files installed on a clean Windows VM. Do not run or patch unsigned components just to test trust.


## F-015 — Repository Chromium installer differs from current public signed Chromium package
- **Status:** Comparison complete / actual user package still unknown.
- **Observation:** Repository `hirepro-chromium-installer.exe` is 102,636,032 bytes, SHA-256 `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16`, and reports `NotSigned`. The current public `Chromium_1.0.1_signed.msi` is 103,059,456 bytes, SHA-256 `946557de73da7aaccda17f9b1af63716492058069cfd6bdd709a825f7666d67f`, with a valid Hirepro Consulting Pvt Ltd signature.
- **Evidence:** [General HirePro SEB landing page](https://securetest.hirepro.in/); [public Chromium MSI](https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/Chromium_1.0.1_signed.msi); [successful Windows workflow](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253); [comparison table](audit/vendor-package-comparison.md).
- **Confidence:** High that the inspected repository EXE and current public MSI are different files. Unknown whether the repo EXE is an older/staged package, an intermediate build, or the exact candidate asset.
- **Risk interpretation:** File mismatch plus lack of signature warrants provenance verification; neither fact independently proves malware.
- **Next action:** Verify hashes/versions of the actual installed files and obtain publisher/hash confirmation for the candidate-specific assessment.



## F-016 — Current public SEB MSI is signed by the same publisher as the main executable
- **Status:** Observed.
- **Observation:** The current public `SecureExamBrowserInstaller_en_2.0.2.msi` (111,493,632 bytes, SHA-256 `ab22021acbfb81e30ff191d57772e616ec4fd971a88016fe6fd972f9cb322f42`) reports Authenticode `Valid` and signer `Hirepro Consulting Pvt Ltd`. The repository's main `SecureExamBrowser.exe` validates under the same signer thumbprint.
- **Evidence:** [Windows comparison run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253); [comparison report](audit/vendor-package-comparison.md).
- **Confidence:** High for those exact downloaded/repository files.
- **Limitations:** The current installer has not been installed, the internal file manifest has not yet been compared, and the user's candidate-specific download is unverified.

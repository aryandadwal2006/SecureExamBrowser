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


## F-014 — Repository component provenance matches the current signed vendor package
- **Status:** Resolved for repository root files; actual user installation not checked.
- **Observation:** The main `SecureExamBrowser.exe` is Authenticode-valid and signed by Hirepro Consulting Pvt Ltd. The service EXE, contracts DLL, Chromium bootstrapper and other root-level DLLs are not individually signed. However, a read-only extraction of the currently public signed SEB 2.0.2 MSI showed every repository root-level `.exe` and `.dll` file matches a same-named file inside that package by exact SHA-256.
- **Evidence:** [Successful Windows component-comparison run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190); [artifact 11604173812](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812); [audit/vendor-package-comparison.md](audit/vendor-package-comparison.md).
- **Confidence:** High for the current public MSI and repository checkout: 39 of 39 root-level EXE/DLLs match; zero mismatches.
- **Interpretation:** The standalone unsigned status of components is not evidence of tampering by itself; these exact bytes are contained in an authenticated vendor package.
- **Limitations:** No comparison has been made with the user's installed file hashes or their exact email-linked package.

## F-015 — Bundled Chromium bootstrapper is a component of the signed SEB installer
- **Status:** Resolved.
- **Observation:** The repository `hirepro-chromium-installer.exe` is not byte-identical to the separately downloadable `Chromium_1.0.1_signed.msi`, but its exact SHA-256 appears in the file set extracted from the signed SEB 2.0.2 MSI.
- **Evidence:** [Component comparison artifact](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812).
- **Interpretation:** It is a package-contained bootstrapper payload, not an unexplained repository-only binary relative to the inspected MSI. This is not evidence of malware.

## F-016 — Published SEB MSI and main executable have valid HirePro signatures
- **Status:** Observed.
- **Observation:** The current public `SecureExamBrowserInstaller_en_2.0.2.msi` (SHA-256 `ab22021acbfb81e30ff191d57772e616ec4fd971a88016fe6fd972f9cb322f42`) is Authenticode-valid and signed by Hirepro Consulting Pvt Ltd. The repository's main `SecureExamBrowser.exe` also validates standalone and matches byte-for-byte with the executable inside that MSI.
- **Evidence:** [Windows provenance and component comparison](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190); [audit/vendor-package-comparison.md](audit/vendor-package-comparison.md).
- **Confidence:** High for the specific public package and repository checkout.
- **Limitations:** The candidate-specific invitation asset and the user's installed files have not been hashed.

## F-017 — All 39 root-level EXE/DLL files match the public signed installer payload
- **Status:** Observed / exact hash comparison completed.
- **Observation:** A static extraction of the publicly linked SEB MSI produced same-named files whose SHA-256 digests exactly matched all 39 top-level repository executables and DLLs.
- **Evidence:** [Workflow run](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190); [component report 11604173812](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812).
- **Confidence:** High for those artifacts and that package.
- **Impact:** No root-level EXE/DLL mismatch was found between the repository and current public installer. This establishes repository/package correspondence, not the effectiveness of security controls or the identity of the files on the user's machine.
- **Next action:** Treat static provenance as complete for repository files; proceed with authorized runtime validation only when a Windows lab is available.


## F-018 — Legacy XUL source exposes browser-window screenshot capability
- **Status:** Observed in checked-in source / active use unknown.
- **Observation:** `SebScreenshot.jsm` can render a supplied browser window into canvas/image data. `SebServer.jsm` exposes a separate screenshot-data handling route.
- **Evidence:** [SebScreenshot.jsm](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebScreenshot.jsm); [SebServer.jsm](https://github.com/aryandadwal2006/SecureExamBrowser/blob/main/SebWindowsBrowser/xul_seb/modules/SebServer.jsm); [platform observations](audit/platform-observations.md).
- **Confidence:** High for the contents of the committed legacy source files.
- **Limitations:** This is source-level evidence. The exact correspondence to the packaged 2.0.2 client, the handler's activation, whether it is used during this test, image destination, and any whole-desktop capture are unverified.
- **Interpretation:** Do not claim “no screenshots” simply because the online page's policy does not explicitly list continuous screen recording; also do not claim continuous full-desktop capture from this code alone.
- **Next action:** Resolve source/runtime correspondence and use organizer-authorized session evidence to determine actual collection behavior. No suppression or concealment patch is part of this audit.


## F-019 — Selected legacy browser/config assets match the signed public MSI
- **Status:** Exact byte match confirmed.
- **Observation:** A corrected Windows CI comparison read canonical Git blob bytes (avoiding CRLF-transformed Windows working files) and found all 12 selected XUL modules, startup files, manifests and sample configs exactly match same-named files extracted from the current signed public SEB 2.0.2 MSI.
- **Evidence:** [Workflow run 37908852563](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563); [source/package artifact 11605307704](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563/artifacts/11605307704); [audit/legacy-source-package-comparison.md](audit/legacy-source-package-comparison.md).
- **Confidence:** High for the 12 selected files in the current public MSI and repository Git ref.
- **Impact:** These checked-in source assets are suitable evidence for static review of the corresponding package files.
- **Limitations:** This does not show which configuration was loaded in the candidate's specific session or prove any runtime branch was active.

## F-020 — Effective assessment configuration and screen-capture behavior remain unknown
- **Status:** Open / runtime evidence required.
- **Observation:** The repository contains multiple example/default configurations with different settings. The configuration loader merges a custom configuration with defaults; checked-in examples are not a session-specific config dump. Screenshot-related source code exists, but source presence alone does not prove activation, capture scope, upload, or retention.
- **Evidence:** [audit/config-profile-analysis.md](audit/config-profile-analysis.md); [audit/platform-observations.md](audit/platform-observations.md); [audit/legacy-source-package-comparison.md](audit/legacy-source-package-comparison.md).
- **Conclusion:** Current evidence does not establish continuous full-desktop capture or prove its absence during the user's mock test. Webcam/audio recording disclosure, page/navigation telemetry, native window/display monitoring, browser-window image capture and desktop-pixel capture must remain separate questions.
- **Next action:** Obtain effective configuration and use authorized, observable positive controls in a disposable Windows VM; correlate only permitted event/log/server receipts. No concealment or suppression changes are part of this plan.


## F-021 — Reported installed SEB core files match current signed public installer
- **Status:** Confirmed from user-provided read-only inventory.
- **Observation:** SHA-256 for the installed main EXE, service EXE, contracts DLL, bundled Chromium bootstrapper, three XUL JSON configuration assets and main EXE .config match the already verified repository/public MSI artifacts. The installed main EXE reports Authenticode Valid and the expected Hirepro signer.
- **Evidence:** User-provided inventory in this conversation; [audit/local-install-comparison.md](audit/local-install-comparison.md); [all root component hashes](audit/vendor-component-hashes.md).
- **Confidence:** High for the file hashes actually included in the inventory.
- **Impact:** No mismatch was found among the reported SEB core files. Their individual unsigned status on some components is not suspicious relative to the current signed vendor MSI.
- **Limitations:** The first inventory version did not search for the common Chromium executable name `chrome.exe`, so installed Chromium binary/DLL identity is not yet established. The effective assessment configuration and dynamic behavior remain unknown.

## F-022 — Installed service .config corresponds to the MSI package copy
- **Status:** Confirmed / benign line-ending difference explained.
- **Observation:** User's `SebWindowsServiceWCF.exe.config` SHA-256 `1941d2f8e171d75d35b6c400992c5cd87899e8315fc4b1149f412cd199e1a3fa` matches the extracted public MSI copy and Windows checkout copy (186 bytes). The canonical Git blob is 180 bytes; Windows checkout converts line endings, resulting in the same 186-byte package copy.
- **Evidence:** [Canonical source/package CI artifact 11614120932](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37925572215/artifacts/11614120932); [audit/local-install-comparison.md](audit/local-install-comparison.md).
- **Confidence:** High for these measured byte lengths and digests.
- **Impact:** This specific difference is consistent with line-ending transformation during Windows packaging/checkout, not unexplained tampering.

## F-023 — Installed Chromium browser binary still needs identification
- **Status:** Open / limited-inventory gap.
- **Observation:** The local report scanned known roots but the first inventory script searched for `Chromium.exe`, not the common `chrome.exe` and associated runtime DLL names. No actual Chromium browser binary hash was returned.
- **Evidence:** User-provided inventory; corrected script [audit/scripts/Collect-LocalSEBInventory.ps1](audit/scripts/Collect-LocalSEBInventory.ps1).
- **Impact:** Cannot yet determine whether the actual installed Chromium executable/DLLs match the current official package.
- **Next action:** Run the updated read-only inventory once its Windows CI validation completes. No browser launch, config read or assessment session is needed.

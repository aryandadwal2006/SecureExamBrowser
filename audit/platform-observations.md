# HirePro / Accenture Assessment Platform Observations

**Updated:** 2026-10-09  
**Evidence sources:** Screenshots supplied in the investigation conversation; public HirePro Accenture SEB landing page; HirePro privacy policy. The screenshots contain candidate/assessment data, so they are summarized here rather than committed to the repository.

## 1. Source verification and limits

- Public landing page: https://securetest.hirepro.in/accenture/
- Public privacy policy: https://hirepro.in/privacy-policy/ (the current page says it was updated 13 January 2026).
- The email's short URL is `https://a.hirepro.in/d1INrdCM`. The web retrieval path did not resolve this exact short URL, so its token-specific redirect has **not** been independently verified. The publicly accessible HirePro Accenture page matches the overall flow visible in the screenshots. Do not copy opaque `data=` query values from a candidate-specific URL into public audit notes.

## 2. Observed launch flow

1. The email invites the candidate to install Safe Exam Browser and open a mock assessment.
2. The public HirePro landing page has `Proceed to Test` and `Launch Test` flows.
3. The page instructs the candidate to confirm the browser's request to open Secure Exam Browser.
4. The supplied browser-dialog screenshot says that `securetest.hirepro.in` wants to open the Secure Exam Browser application. This is a **browser external-application/protocol handoff prompt**, not, by itself, a Windows User Account Control elevation dialog. A separate installer/elevation prompt may occur during installation.
5. The page says SEB closes currently running applications and the test window cannot be left without exiting the test.
6. The supplied mock-test photographs show the running UI labelled Secure Exam Browser 2.0.2 and a visible notice that video/audio are recorded and reviewed for integrity.
7. The email/page describes required system conditions including supported OS, administrative privileges, current Chrome, other applications closed, and Bluetooth/device restrictions communicated in the test instructions.

These observations document UI and workflow behaviour. They do not prove what data is uploaded for every session or whether a remote system or a human observer sees a particular event.

## 3. Published platform requirements and data handling

The public HirePro Accenture page currently states:
- Windows 11 / macOS support on that page;
- current Windows and Chrome, administrative rights and no network/system restrictions;
- all other applications should be closed;
- antivirus should be disabled;
- the page's Windows install instructions tell users to use “More Info” / “Run Anyway” if Microsoft Defender warns about the installer;
- the test-launch confirmation warns that applications will be closed and the test window cannot be left without exiting.

**Security caution:** Instructions to disable antivirus or override a Defender warning deserve independent publisher/signature verification. This observation does not establish that the installer is malicious. Do not leave antivirus disabled globally after installation; request confirmation from the university/employer or HirePro support if the signer/publisher or installer provenance is unclear.

HirePro's current privacy policy says proctored services may collect video/audio recordings and captured live images, device information, assessment performance, IP address and derived location, browser/device metadata, pages accessed and links clicked. It also says that for services used on behalf of a customer/partner, HirePro processes information on that customer's instructions and directs candidates to contact the customer/partner with questions about that processing. These are published policy categories, not proof that every category is enabled in this particular mock test.

## 4. Layered system model

Keep these observation and enforcement layers separate:

| Layer | What is established | Still unverified |
|---|---|---|
| Email / invitation | Instructions link the candidate to a HirePro assessment and SEB download/launch flow. | Exact redirect destination of the invitation short URL. |
| Browser handoff | Browser presents a confirmation to launch an external Secure Exam Browser application. | Exact protocol-handler registration/arguments for this candidate's installed version. |
| Local Windows app/service | Static binaries include process, device, integrity, logging and desktop/session-management code. | Runtime activation and outcome for each control on the candidate's machine. |
| Embedded browser / local IPC | The main application defines a local XUL/WebSocket message channel and session/system-information messages. | Which messages and fields are used in this assessment and which are forwarded beyond the machine. |
| Online platform | The running mock test shows a recording/integrity notice; public privacy policy describes proctoring data categories. | Actual network payloads, server-side alert rules, retention for this employer's session and any third-party endpoint agent. |
| Camera / microphone | The assessment UI states that audio/video are recorded and reviewed. | Actual recording intervals, upload timing, reviewer access and per-session configuration. |
| Human observation | Independent human observation is logically separate from application telemetry. | Whether a human observer is present for this specific test, and what they can see. |

## 5. Static evidence now connected to the screenshots

The main application static inventory and call graph show references linking the SEB window/session opening path to prohibited-process checks, process monitoring and startup of the XUL communication server. Separate code paths include watchdog status reports, executable-integrity checks, log-upload routines, desktop/session handling, Bluetooth management, monitor/camera checks and system-information message fields. See [static application analysis](static-application-analysis.md).

This establishes code-level components and static call relationships—not that every branch executed in the screenshot session, and not that a control was successfully triggered or evaded.

## 6. Recommended controlled validation

Use a test VM and a synthetic or explicitly authorized test session only.

- Verify executable signature/hash and effective configuration before launch.
- Observe the external-application handoff and process tree with independent host telemetry.
- Confirm ordinary application closure and the documented device restrictions using benign test cases.
- Trigger only documented positive controls, then correlate local UI, Windows events, app/service logs and authorized test-server receipts.
- Confirm the browser's recording/consent UI and observable permissions without attempting to suppress recording.
- Record server-side and human-observation coverage as separate unknowns unless there is independent evidence.
- Do not treat absence of a warning, an event in one local log, or a single screenshot as proof that no other monitoring channel collected data.


## 7. Installer provenance finding

A Windows CI preflight reports the repository's `SecureExamBrowser.exe` as Authenticode-valid with signer `Hirepro Consulting Pvt Ltd`. In contrast, the checked-out service executable, contracts DLL and `hirepro-chromium-installer.exe` are not digitally signed according to that check. This is a reason to request trusted expected hashes/publishers and inspect the installed file set; it is not proof that an unsigned component is malicious. The repository's large Chromium installer is not proven to be the exact file downloaded from the email link.

See [audit/artifact-manifest.md](artifact-manifest.md) and [F-014 in findings.md](../findings.md).


## 8. Distinguish public package variants

The current general HirePro SEB landing page, [https://securetest.hirepro.in/](https://securetest.hirepro.in/), says to install both Chromium and Secure Exam Browser and links to these publicly hosted packages:

- [Chromium 1.0.1 MSI](https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/Chromium_1.0.1_signed.msi)
- [Secure Exam Browser 2.0.2 MSI](https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/SecureExamBrowserInstaller_en_2.0.2.msi)

The Accenture-specific landing page at [https://securetest.hirepro.in/accenture/](https://securetest.hirepro.in/accenture/) currently displays a SEB download and the launch handoff, but the generic site displays both packages. The instructions also vary by tenant: the public Windows install iframe says the Chromium MSI may be shared with the candidate.

The repository contains `hirepro-chromium-installer.exe`, which has a different extension and filename from the currently linked `Chromium_1.0.1_signed.msi`. This is not enough to identify it as the same payload or a malicious file; the next workflow downloads the public MSIs and compares their SHA-256 and Authenticode metadata with the checked-out artifacts. It never executes the packages.


See also [vendor package comparison](vendor-package-comparison.md), which has exact SHA-256 and Authenticode results from downloaded public packages.

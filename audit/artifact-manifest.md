# Artifact Manifest (Repository-Level)

**Updated:** 2026-10-09  
**Source ref:** main at time of inspection  
**Purpose:** Record stable source-artifact identities before local hashing. Git blob IDs are not raw-file SHA-256 hashes.

| Path | Repository size (bytes) | Git blob ID | Inspection status |
|---|---:|---|---|
| SecureExamBrowser.exe | 1,924,120 | 6a9729ae2ad1a672af6e32566b9edcac83ffea91 | Binary content not retrievable through the current connector's base64 path; inspect locally. |
| SebWindowsServiceWCF.exe | 170,496 | 1364103ef2f4ce48f42f0dc3a71616fc3d40cf7d | Read-only PE/CLI metadata and selected CIL method bodies inspected in-memory. |
| SEBWindowsServiceContracts.dll | 6,144 | dc4abd16c9edbdb80fc2578b2440d34be26ce445 | Read-only PE/CLI metadata and declared contract names inspected in-memory. |
| SecureExamBrowser.exe.config | 980 | eb2966f83a74a5286ba14b0273e5d63e1218936d | Text inspected. |
| SebWindowsServiceWCF.exe.config | 180 | 8227adb98927a4da06134bba28b35ab85e938f61 | Text inspected. |
| sebwindowsservice.log | 50,922 | 095ecab3cdea922a0917bc99bd8839596a1862cf | Text inspected; provenance to the current test build not verified. |
| hirepro-chromium-installer.exe | 102,636,032 | Not recorded in this manifest | Not executed or locally analysed. |

## Local evidence still required

- Compute SHA-256 for each downloaded artifact. Do not substitute a Git blob ID for the file hash.
- Record file/product version, Authenticode status, PE machine and CLR metadata from the local bytes.
- Compare local hashes against a fresh pull of the documented source ref.
- Do not execute the browser installer while establishing identity; use an isolated VM snapshot if execution becomes necessary.

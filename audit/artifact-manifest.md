# Artifact Manifest (Repository-Level)

**Updated:** 2026-10-09  
**Source ref:** main at time of inspection  
**Purpose:** Record stable source-artifact identities before local hashing. Git blob IDs are not raw-file SHA-256 hashes.

| Path | Repository size (bytes) | Git blob ID | Inspection status |
|---|---:|---|---|
| SecureExamBrowser.exe | 1,924,120 | 6a9729ae2ad1a672af6e32566b9edcac83ffea91 | REA static PE/CLI/member/boundary analysis completed in GitHub Actions; exact file SHA-256 recorded below. |
| SebWindowsServiceWCF.exe | 170,496 | 1364103ef2f4ce48f42f0dc3a71616fc3d40cf7d | Read-only PE/CLI metadata and selected CIL method bodies inspected in-memory. |
| SEBWindowsServiceContracts.dll | 6,144 | dc4abd16c9edbdb80fc2578b2440d34be26ce445 | Read-only PE/CLI metadata and declared contract names inspected in-memory. |
| SecureExamBrowser.exe.config | 980 | eb2966f83a74a5286ba14b0273e5d63e1218936d | Text inspected. |
| SebWindowsServiceWCF.exe.config | 180 | 8227adb98927a4da06134bba28b35ab85e938f61 | Text inspected. |
| sebwindowsservice.log | 50,922 | 095ecab3cdea922a0917bc99bd8839596a1862cf | Text inspected; provenance to the current test build not verified. |
| hirepro-chromium-installer.exe | 102,636,032 | Not recorded in this manifest | Not executed or locally analysed. |

## REA static inspection identities\n\n| Path | Raw-file SHA-256 from REA | Assembly version / MVID | Static inventory summary |\n|---|---|---|---|\n| SecureExamBrowser.exe | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | `2.0.2.0` / `704e0878-fd78-47f7-922f-49d7ed0a9f18` | 377 types; 2,212 methods; 17,867 call edges; 126 P/Invoke declarations; complete parser coverage. |\n| SebWindowsServiceWCF.exe | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | `2.2.0.0` / `aea1abb8-cb61-45e8-9b75-81f72e71d848` | 38 types; 98 methods; complete parser coverage. |\n| SEBWindowsServiceContracts.dll | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | `2.2.0.0` / `e7845311-4100-4832-b088-bb4dea31ed85` | 3 types; 4 methods; complete parser coverage. |\n\nThese raw-file digests were computed by REA from the checked-out repository artifacts in the successful workflow run; the Git blob IDs in the prior table remain Git object identifiers and are not these digests.\n\n## Local evidence still required

- Compute SHA-256 for each downloaded artifact. Do not substitute a Git blob ID for the file hash.
- Record file/product version, Authenticode status, PE machine and CLR metadata from the local bytes.
- Compare local hashes against a fresh pull of the documented source ref.
- Do not execute the browser installer while establishing identity; use an isolated VM snapshot if execution becomes necessary.

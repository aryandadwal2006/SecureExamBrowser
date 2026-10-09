# Artifact Manifest (Repository-Level)

**Updated:** 2026-10-09  
**Source ref:** investigation branch checked out by GitHub Actions run 37901362719 (`da3b10c1e824dc79fc631f51b43e18d7c46a560f`); root artifacts match the branch baseline taken from `main`.  
**Purpose:** Record stable source-artifact identities before local hashing. Git blob IDs are not raw-file SHA-256 hashes.

| Path | Repository size (bytes) | Git blob ID | Inspection status |
|---|---:|---|---|
| SecureExamBrowser.exe | 1,924,120 | 6a9729ae2ad1a672af6e32566b9edcac83ffea91 | REA static PE/CLI/member/boundary analysis completed in GitHub Actions; exact file SHA-256 recorded below. |
| SebWindowsServiceWCF.exe | 170,496 | 1364103ef2f4ce48f42f0dc3a71616fc3d40cf7d | REA PE/CLI, member and native-boundary analyses completed in CI; selected CIL methods also inspected in-memory. |
| SEBWindowsServiceContracts.dll | 6,144 | dc4abd16c9edbdb80fc2578b2440d34be26ce445 | REA PE/CLI, member and native-boundary analyses completed in CI. |
| SecureExamBrowser.exe.config | 980 | eb2966f83a74a5286ba14b0273e5d63e1218936d | Text inspected. |
| SebWindowsServiceWCF.exe.config | 180 | 8227adb98927a4da06134bba28b35ab85e938f61 | Text inspected. |
| sebwindowsservice.log | 50,922 | 095ecab3cdea922a0917bc99bd8839596a1862cf | Text inspected; provenance to the current test build not verified. |
| hirepro-chromium-installer.exe | 102,636,032 | Not recorded in this manifest | Not executed or locally analysed. |

## REA static inspection identities

| Path | Raw-file SHA-256 from REA | Assembly version / MVID | Static inventory summary |
|---|---|---|---|
| SecureExamBrowser.exe | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | `2.0.2.0` / `704e0878-fd78-47f7-922f-49d7ed0a9f18` | 377 types; 2,212 methods; 17,867 call edges; 126 P/Invoke declarations; complete parser coverage. |
| SebWindowsServiceWCF.exe | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | `2.2.0.0` / `aea1abb8-cb61-45e8-9b75-81f72e71d848` | 38 types; 98 methods; complete parser coverage. |
| SEBWindowsServiceContracts.dll | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | `2.2.0.0` / `e7845311-4100-4832-b088-bb4dea31ed85` | 3 types; 4 methods; complete parser coverage. |

These raw-file digests were computed by REA from the checked-out repository artifacts in the successful workflow run; the Git blob IDs in the prior table remain Git object identifiers and are not these digests.

## Remaining identity checks

- Verify Authenticode status and file/product version metadata in a Windows environment.
- Confirm the exact launch target, loaded modules, process ancestry, active config path and runtime settings.
- Do not execute the browser installer while establishing identity; use an isolated VM snapshot if execution becomes necessary.


## Windows Authenticode preflight (2026-10-09)

A Windows GitHub Actions job ran `Get-FileHash -Algorithm SHA256` and `Get-AuthenticodeSignature` on the repository checkout. It did not execute any target binaries. Report: [workflow run 37904465412](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37904465412), artifact `windows-artifact-provenance` (ID 11603138113).

| File | SHA-256 | Authenticode status | Signer |
|---|---|---|---|
| `SecureExamBrowser.exe` | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | **Valid** | `CN=Hirepro Consulting Pvt Ltd`; thumbprint `B522BE129C67224D25A7566A9F293E5C256CC143`; certificate validity reported as 2024-02-21 through 2027-02-20 UTC. |
| `SebWindowsServiceWCF.exe` | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | **NotSigned** | None. |
| `SEBWindowsServiceContracts.dll` | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | **NotSigned** | None. |
| `hirepro-chromium-installer.exe` | `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16` | **NotSigned** | None. |

The valid main-EXE signature confirms the checked-out file verifies under Windows Authenticode and names Hirepro Consulting Pvt Ltd as the signer. It is not a full security audit. The other three files' unsigned status is a provenance concern, **not evidence by itself of malware**. In particular, the repository's `hirepro-chromium-installer.exe` has not been proven to be the same file the user downloaded from the email link. Preserve that distinction.

Recommended follow-up: ask the competition/employer/vendor for expected hashes and publishers for the service/contract DLL and the exact installer package; compare with the Windows report and validate the installed files in an isolated VM.

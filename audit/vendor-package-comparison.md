# Official Vendor Package Comparison

**Updated:** 2026-10-09  
**Collection method:** Windows GitHub Actions runner; SHA-256 and Authenticode metadata collected; no package was installed or executed.  
**Run:** [37906017253](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253)  
**Artifact:** [windows-artifact-provenance, ID 11604756323](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906017253/artifacts/11604756323)

## Results

| File | Size (bytes) | SHA-256 | Authenticode status | Signer |
|---|---:|---|---|---|
| Repository `SecureExamBrowser.exe` | 1,924,120 | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | Valid | Hirepro Consulting Pvt Ltd |
| Repository `SebWindowsServiceWCF.exe` | 170,496 | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | NotSigned | None |
| Repository `SEBWindowsServiceContracts.dll` | 6,144 | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | NotSigned | None |
| Repository `hirepro-chromium-installer.exe` | 102,636,032 | `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16` | NotSigned | None |
| Public `Chromium_1.0.1_signed.msi` | 103,059,456 | `946557de73da7aaccda17f9b1af63716492058069cfd6bdd709a825f7666d67f` | Valid | Hirepro Consulting Pvt Ltd |
| Public `SecureExamBrowserInstaller_en_2.0.2.msi` | 111,493,632 | `ab22021acbfb81e30ff191d57772e616ec4fd971a88016fe6fd972f9cb322f42` | Valid | Hirepro Consulting Pvt Ltd |

The public signed packages were downloaded from the exact URLs linked by the current generic HirePro page:
- https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/Chromium_1.0.1_signed.msi
- https://securetest.hirepro.in/s3_cached/hirepro-content/hirepro/paas/SecureExamBrowserInstaller_en_2.0.2.msi

Both validate under Windows Authenticode with signer thumbprint `B522BE129C67224D25A7566A9F293E5C256CC143` and signer subject `CN=Hirepro Consulting Pvt Ltd`.

## Signed package content comparison

The Windows runner extracted the public SEB MSI using the `lessmsi` file-extraction utility; the MSI was not installed or executed. The extracted package contains all four repository artifacts below with exact SHA-256 matches:

| Repository artifact | Package path | Exact SHA-256 match? |
|---|---|---|
| `SecureExamBrowser.exe` | `seb\\SourceDir\\SecureExamBrowser.exe` | Yes |
| `SebWindowsServiceWCF.exe` | `seb\\SourceDir\\SebWindowsServiceWCF.exe` | Yes |
| `SEBWindowsServiceContracts.dll` | `seb\\SourceDir\\SEBWindowsServiceContracts.dll` | Yes |
| `hirepro-chromium-installer.exe` | `seb\\SourceDir\\hirepro-chromium-installer.exe` | Yes |

Raw machine-readable evidence: [component comparison artifact, ID 11604692503](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906360710/artifacts/11604692503). The parent MSI has a valid Authenticode signature from Hirepro Consulting Pvt Ltd. Therefore these exact bytes were included in the authenticated published package inspected here. This does **not** prove the user's installed files came from that package, but it materially resolves the question of whether the repository artifacts are arbitrary injected files.

## Interpretation

1. The repository's `hirepro-chromium-installer.exe` differs from the separately downloadable current Chromium MSI, but it is included byte-for-byte inside the signed SEB 2.0.2 MSI as a component file.
2. Both currently published MSIs have valid Authenticode signatures from Hirepro Consulting Pvt Ltd.
3. The service EXE and contracts DLL do not have embedded Authenticode signatures as standalone files, but the exact repository bytes are present in the signed SEB MSI. Their unsigned standalone status is therefore not, on its own, a sign of tampering.
4. The repository's main EXE both validates standalone and matches the file in the signed MSI.
5. The actual installed files on the user's laptop remain unverified; a candidate-specific or older package could differ.

## Recommended next check

Broaden the same read-only extraction/hash comparison to all root-level EXE/DLL files and compare the user's installed versions only if the user later authorizes and provides local hashes. No installed package or target executable has been run by this workflow.

**No malware conclusion is made from these results.**


## Complete root-level component match (2026-10-09)

The broadened Windows comparison enumerated **all 39 top-level `.exe` and `.dll` files** in the repository and compared each raw SHA-256 digest against same-named files extracted from the publicly signed SEB 2.0.2 MSI. **All 39 matched exactly; zero had a missing or mismatched package candidate.** This includes every support DLL found at repository root, not just the four primary files.

Evidence: [comparison artifact 11604173812](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812). The JSON report records each repository digest, matching package path, packaged file digest and boolean match result. The Windows provenance job and the parallel REA static-analysis/test job both completed successfully in workflow run 37906673190.

This supports the conclusion that the repository's complete root-level executable/DLL set is an exact extraction of the contents of the current public, Authenticode-valid SEB MSI. It does not prove that the user's installed files or candidate-specific link resolve to this same package.


Complete per-file table: [audit/vendor-component-hashes.md](vendor-component-hashes.md). It records all 39 repository root-level EXE/DLL filenames, lengths, SHA-256 values, extracted MSI paths, and exact-match result.

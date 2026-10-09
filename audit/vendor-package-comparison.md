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

## Interpretation

1. The repository's `hirepro-chromium-installer.exe` differs in extension, size and SHA-256 from the current public signed Chromium MSI. The two files are **not the same file**.
2. The current public Chromium and SEB MSIs have valid Authenticode signatures from Hirepro Consulting Pvt Ltd.
3. The repository service EXE and contracts DLL do not have embedded Authenticode signatures. That alone does not make them unsafe; a trusted signed installer can legitimately contain unsigned component files.
4. The repository's `SecureExamBrowser.exe` independently validates and has the same signer thumbprint as the published MSIs, but this does not prove its file contents are identical to the executable inside the current MSI.
5. We have not inspected the actual file downloaded by the user from their candidate-specific link. The public generic page and Accenture-specific page may surface different packages/configurations.

## Recommended next check

Obtain the exact installed file paths, hashes, and version data from the user's system and compare with vendor-provided expected values. In a lab, inspect the signed MSI's package manifest/components and compare contained file hashes without installing or executing the packages. Ask HirePro/employer support to confirm the intended publisher/hash for the service and contract DLL if the expected values are not documented.

**No malware conclusion is made from these results.**

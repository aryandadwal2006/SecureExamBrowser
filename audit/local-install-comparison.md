# User-Provided Local Installation Comparison

**Updated:** 2026-10-09  
**Source:** User-provided output from the read-only local inventory script. No binaries were executed and no config contents, process arguments, logs or recordings were collected.

## Outcome

The local inventory confirms that the core SEB files found on the user's system match the files already measured from the current public, Authenticode-valid SEB 2.0.2 MSI by SHA-256. This substantially closes the local *core package identity* question.

| Local file | Reported SHA-256 | Comparison |
|---|---|---|
| `SecureExamBrowser.exe` | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | Exact match to repository and published signed MSI; inventory says Authenticode Valid |
| `SebWindowsServiceWCF.exe` | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | Exact match to repository and published MSI |
| `SEBWindowsServiceContracts.dll` | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | Exact match to repository and published MSI |
| `hirepro-chromium-installer.exe` | `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16` | Exact match to repository and published SEB MSI payload |
| `SebWindowsBrowser/xul_seb/config.json` | `b34a8904ddc03842fbd1d39708a938aa561aa5cff04a2078489e7c059301dc3e` | Exact match to canonical source/package asset |
| `SebWindowsBrowser/xul_seb/config.SEB22.json` | `0fef225c916b079004a26a80df362eca0ba12b32a296d1eaae0f8021536ed704` | Exact match to canonical source/package asset |
| `SebWindowsBrowser/xul_seb/default.json` | `397ff11b3d4edc9ef0dc0accaf35b4a4f9d50d20bf07224632dea5915e094563` | Exact match to canonical source/package asset |
| `SecureExamBrowser.exe.config` | `7ddc2fafe0a2b3ac40011d90c072fe50cec8db4454e6c8ba85e436004c81ef47` | Exact match to canonical Git blob and extracted installer file |
| `SebWindowsServiceWCF.exe.config` | `1941d2f8e171d75d35b6c400992c5cd87899e8315fc4b1149f412cd199e1a3fa` | Exact match to extracted installer file and Windows checkout bytes |

## Interpretation

- No mismatch was observed among these installed SEB core files and the current public vendor installer. This is strong evidence the installed core package matches the examined vendor package.
- The standalone `NotSigned` status on the service EXE, contracts DLL, and Chromium bootstrapper is expected relative to the current package: their exact bytes are present inside the Authenticode-valid installer.
- The service `.exe.config` differs from the canonical LF Git blob by size/hash, but its 186-byte user-installed file matches the 186-byte Windows checkout/package copy exactly. The 180-byte canonical blob is transformed to CRLF in the Windows working tree. This is a line-ending/package-build difference, not evidence of tampering.
- `UnknownError` Authenticode statuses on JSON/XML configuration files are not meaningful as executable-signature verdicts. Compare their SHA-256 instead.
- The report's first version of the inventory script searched for `Chromium.exe` but not the common `chrome.exe` name. Therefore it did **not** establish the identity of the actual installed Chromium browser binary or its DLL dependencies. The script is being corrected to collect those specific files.
- The discovered files named `config.json`, `default.json` and `config.SEB22.json` are installed configuration assets; this metadata-only inventory does not prove which configuration was effective in the mock assessment or whether the app supplied a separate config argument.

## Remaining boundaries

This finding establishes package/file correspondence for the reported files. It does not establish runtime monitor activation, the effective assessment configuration, screen-pixel capture behavior, remote telemetry delivery or human-observer coverage.

For the remaining Chromium identity check, rerun the corrected inventory script after its CI syntax validation succeeds. Do not read or share any configuration content, logs, process command lines, tokens, URLs or recordings.


## Chromium browser comparison pending

The updated CI pipeline now extracts the nested Chromium payload as data only and records the 15 EXE/DLL hashes in [audit/chromium-payload-hashes.md](chromium-payload-hashes.md). The expected `chrome.exe` SHA-256 is `12f2e3b2e818060ed6828bd2bd6fc0de69385e3d1c5a9906a2c3cd1c3cd585e7`. Once the corrected local collector output is supplied, compare `chrome.exe`, `chrome.dll`, `chrome_elf.dll`, and associated files against that manifest.

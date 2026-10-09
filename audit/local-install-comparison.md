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


## Second inventory: Chromium executable/DLL comparison

The corrected inventory includes the browser's actual installation paths. **All 11 Chromium binary files reported below match the official nested Chromium payload by exact byte count and SHA-256.**

| Installed file | Bytes | SHA-256 | Result |
|---|---:|---|---|
| `chrome.exe` | 3,339,776 | `12f2e3b2e818060ed6828bd2bd6fc0de69385e3d1c5a9906a2c3cd1c3cd585e7` | Exact match |
| `chrome.dll` | 247,295,488 | `7e1fbae4bb981688ed226c613b2a655534fff3da3e5b043dd0e8db7b8ec4846b` | Exact match |
| `chrome_elf.dll` | 1,634,816 | `28a47a61c8eb57ab4c7815fc7900776ec8574c45283c127d53a20ea85eca0528` | Exact match |
| `chrome_pwa_launcher.exe` | 1,757,696 | `185d6964494755f277cf2f4bdb2cbc80075f36380cfcef00d9ac872f579b270c` | Exact match |
| `chrome_proxy.exe` | 1,453,056 | `70723a8ac0d18bfd17fde09a34ac657753c03a1bf9e411bf0f406a9ef25bbf02` | Exact match |
| `d3dcompiler_47.dll` | 4,916,840 | `a05d04a270f68c8c6d6ea2d23bebf8cd1d5453b26b5442fa54965f90f1c62082` | Exact match |
| `libEGL.dll` | 495,104 | `fd66ed01a2efdf25b2764635c6fac5b42fa9d6532aae42cd908956e3d715c78c` | Exact match |
| `libGLESv2.dll` | 7,839,232 | `cc2176bd292f633c25ed1ca5b7034198962a2157fdbf609675e4f96f2bcd55ac` | Exact match |
| `notification_helper.exe` | 1,665,536 | `990bf7d4812ae67cfd29ff96ded0cf233b89078f97cba2a1d5cc5523b2e88ed6` | Exact match |
| `vk_swiftshader.dll` | 5,396,992 | `27cbfc7c94a66b35b98300e7df09d1b182dc78d6bcb6e70d8de83a3ad85a83dc` | Exact match |
| `vulkan-1.dll` | 886,272 | `bb115d5c22c9316d9addeed43abb7a4417f5ac9647e733b8d870150803715aa2` | Exact match |

The browser reports version `135.0.7049.96`, consistent with the package. Four other EXE/DLL entries in the 15-file package manifest were not included by the collector's target-name list: `chrome_wer.dll`, `dxcompiler.dll`, `dxil.dll`, and `eventlog_provider.dll`. They remain unverified, not presumed absent. Full details are in [audit/chromium-payload-hashes.md](chromium-payload-hashes.md).

**Conclusion:** the main SEB files and all Chromium executable/DLL files reported in the user's two inventories match the examined public package. This closes the primary installed-file identity question for the reported files. It does not establish effective session configuration or the runtime operation of monitoring/proctoring controls.

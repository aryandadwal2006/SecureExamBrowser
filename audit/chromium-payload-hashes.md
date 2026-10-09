# Chromium 135.0.7049.96 Payload Hash Manifest

**Updated:** 2026-10-09  
**Source chain:** Public `SecureExamBrowserInstaller_en_2.0.2.msi` and `Chromium_1.0.1_signed.msi`, extracted by Windows CI without executing the installer; nested `chromium-135-0-7049-96.exe` and its `chrome.7z` payload extracted by 7-Zip as data only.  
**Workflow:** [37926967501](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926967501)  
**Evidence artifact:** [nested-chromium-installer-inventory, ID 11613754590](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37926967501/artifacts/11613754590)

## Result

The signed public package contains a nested Chromium bootstrapper (`chromium-135-0-7049-96.exe`) that expands to `chrome.7z`. The `.7z` payload extracted successfully, yielding 86 files, including 15 EXE/DLL files. None of these files was executed during analysis.

| File | Bytes | SHA-256 | Authenticode | Package-relative path |
|---|---:|---|---|---|
| `chrome_proxy.exe` | 1,453,056 | `70723a8ac0d18bfd17fde09a34ac657753c03a1bf9e411bf0f406a9ef25bbf02` | NotSigned | `Chrome-bin\chrome_proxy.exe` |
| `chrome.exe` | 3,339,776 | `12f2e3b2e818060ed6828bd2bd6fc0de69385e3d1c5a9906a2c3cd1c3cd585e7` | NotSigned | `Chrome-bin\chrome.exe` |
| `chrome_elf.dll` | 1,634,816 | `28a47a61c8eb57ab4c7815fc7900776ec8574c45283c127d53a20ea85eca0528` | NotSigned | `Chrome-bin\135.0.7049.96\chrome_elf.dll` |
| `chrome_pwa_launcher.exe` | 1,757,696 | `185d6964494755f277cf2f4bdb2cbc80075f36380cfcef00d9ac872f579b270c` | NotSigned | `Chrome-bin\135.0.7049.96\chrome_pwa_launcher.exe` |
| `chrome_wer.dll` | 118,272 | `068085f2c4dbb70e3535493b46ced20c066cbf253efaa0c09feff45b493d20c1` | NotSigned | `Chrome-bin\135.0.7049.96\chrome_wer.dll` |
| `chrome.dll` | 247,295,488 | `7e1fbae4bb981688ed226c613b2a655534fff3da3e5b043dd0e8db7b8ec4846b` | NotSigned | `Chrome-bin\135.0.7049.96\chrome.dll` |
| `d3dcompiler_47.dll` | 4,916,840 | `a05d04a270f68c8c6d6ea2d23bebf8cd1d5453b26b5442fa54965f90f1c62082` | Valid | `Chrome-bin\135.0.7049.96\d3dcompiler_47.dll` |
| `dxcompiler.dll` | 25,752,064 | `a017d60fbb4fe89af1e6ef3f732837f4e47c98bc89890582d8b0a45751efd46c` | NotSigned | `Chrome-bin\135.0.7049.96\dxcompiler.dll` |
| `dxil.dll` | 1,508,472 | `6c37738cd2fb4d659b0f49dead8311ae75c93b8c6602b991c00e070f7be20bc1` | Valid | `Chrome-bin\135.0.7049.96\dxil.dll` |
| `eventlog_provider.dll` | 6,144 | `b3285f5c153d3b726a5ba363a4e21f50a116c8a1c69af8a927b2d7c7078e5cad` | NotSigned | `Chrome-bin\135.0.7049.96\eventlog_provider.dll` |
| `libEGL.dll` | 495,104 | `fd66ed01a2efdf25b2764635c6fac5b42fa9d6532aae42cd908956e3d715c78c` | NotSigned | `Chrome-bin\135.0.7049.96\libEGL.dll` |
| `libGLESv2.dll` | 7,839,232 | `cc2176bd292f633c25ed1ca5b7034198962a2157fdbf609675e4f96f2bcd55ac` | NotSigned | `Chrome-bin\135.0.7049.96\libGLESv2.dll` |
| `notification_helper.exe` | 1,665,536 | `990bf7d4812ae67cfd29ff96ded0cf233b89078f97cba2a1d5cc5523b2e88ed6` | NotSigned | `Chrome-bin\135.0.7049.96\notification_helper.exe` |
| `vk_swiftshader.dll` | 5,396,992 | `27cbfc7c94a66b35b98300e7df09d1b182dc78d6bcb6e70d8de83a3ad85a83dc` | NotSigned | `Chrome-bin\135.0.7049.96\vk_swiftshader.dll` |
| `vulkan-1.dll` | 886,272 | `bb115d5c22c9316d9addeed43abb7a4417f5ac9647e733b8d870150803715aa2` | NotSigned | `Chrome-bin\135.0.7049.96\vulkan-1.dll` |

## Interpretation

- This provides expected SHA-256 values for the actual Chromium 135.0.7049.96 binary set, beyond the hash of the installer wrapper.
- The user-provided first inventory had no `chrome.exe` entry because the initial collector searched for `Chromium.exe` rather than the common `chrome.exe` filename.
- The corrected collector has been prepared and its PowerShell parser step succeeded in Windows CI. A second inventory is needed to compare installed `chrome.exe`, `chrome.dll`, `chrome_elf.dll` and related files to these hashes.
- The standalone unsigned status of Chromium EXE/DLL files is not, on its own, evidence of tampering; the nested payload was contained within the vendor-signed package chain. Two DLLs in this manifest (`d3dcompiler_47.dll` and `dxil.dll`) individually validate under Authenticode.
- Exact file equality only validates package identity, not runtime safety or whether proctoring controls detect a particular event.

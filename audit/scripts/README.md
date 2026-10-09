# Local SEB Inventory Script

`Collect-LocalSEBInventory.ps1` records a narrow, read-only inventory of installed SEB/HirePro executable, DLL and configuration-file metadata. It does not execute the exam browser or installer, modify settings, or inspect live assessment processes.

## When to use it

Only use this if the audit later needs to compare the exact files installed on a Windows machine against the signed public package. Static repository checks do not require it.

## Command

Open PowerShell in the root of a checkout of the investigation branch and run:

```powershell
powershell.exe -NoLogo -NoProfile -File .\audit\scripts\Collect-LocalSEBInventory.ps1 -OutputPath "$env:TEMP\seb-inventory.json"
```

The script prints the JSON report and writes the same report to the specified temporary path. It masks the current user's home path in the output. It records file names, sizes, SHA-256, file/product versions, timestamps and Authenticode status/signer. For JSON configuration files, it records only file metadata and a hash; it does not read or emit their contents.

It does not collect process command lines, candidate URLs, tokens, logs, screenshots, audio or video. No administrator privileges should normally be required. The search may not find custom install paths; an explicit known installation directory can be passed with `-ExtraRoot 'C:\\Known\\SEB\\Path'`.

Do not commit the output to the repository without reviewing it first. Paths, signer names and installation metadata may be sensitive. Share it only if requested for an authorized local-file identity check. If execution is blocked by local policy, do not change system policy; report the blocker.


## Updated Chromium targets

The collector now includes `chrome.exe`, `chrome.dll`, `chrome_elf.dll`, `chrome_proxy.exe`, `chrome_crashpad_handler.exe`, `chrome_pwa_launcher.exe` and common runtime DLLs such as `libEGL.dll` and `libGLESv2.dll`. The first report searched for `Chromium.exe` and therefore did not establish which actual browser executable was installed.

For a verified one-time rerun, the current script's Git blob ID is `7dfc24f0a862c38058f67422bdb6276db4d5ef8d`. Fetch the same branch URL, verify this ID with `git hash-object`, and write output to a new file such as `seb-inventory-v2.json`. Do not run it during a live assessment.

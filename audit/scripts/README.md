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

[CmdletBinding()]
param(
    [string[]] $ExtraRoot = @(),
    [string] $OutputPath = ""
)

# Read-only inventory of installed SEB/HirePro files.
# This script never starts, stops, patches, or configures the exam browser.
# It records only hashes, file metadata, and Authenticode signer/status;
# it does not read configuration file contents, process arguments, tokens,
# assessment URLs, logs, screenshots, or recordings.

$ErrorActionPreference = 'SilentlyContinue'
$targetNames = @(
    'SecureExamBrowser.exe',
    'SebWindowsServiceWCF.exe',
    'SEBWindowsServiceContracts.dll',
    'hirepro-chromium-installer.exe',
    'Chromium.exe',
    'config.json',
    'default.json',
    'config.SEB22.json',
    'SecureExamBrowser.exe.config',
    'SebWindowsServiceWCF.exe.config'
)

$roots = [System.Collections.Generic.List[string]]::new()

function Add-Root([string] $Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { return }
    if (Test-Path -LiteralPath $Path -PathType Container) {
        $resolved = (Resolve-Path -LiteralPath $Path).Path
        if (-not $roots.Contains($resolved)) { $roots.Add($resolved) }
    }
}

foreach ($path in $ExtraRoot) { Add-Root $path }

$programParents = @(
    $env:ProgramFiles,
    ${env:ProgramFiles(x86)},
    $env:LOCALAPPDATA
) | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) }

foreach ($parent in $programParents) {
    Get-ChildItem -LiteralPath $parent -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match 'HirePro|Safe.?Exam|Secure.?Exam|SEB|Chromium' } |
        ForEach-Object { Add-Root $_.FullName }
}

$uninstallPaths = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

foreach ($key in $uninstallPaths) {
    Get-ItemProperty -Path $key -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -match 'HirePro|Safe.?Exam|Secure.?Exam|SEB' } |
        ForEach-Object { Add-Root $_.InstallLocation }
}

$files = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
$filePaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($root in $roots) {
    Get-ChildItem -LiteralPath $root -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $targetNames -contains $_.Name } |
        ForEach-Object {
            if ($filePaths.Add($_.FullName)) { $files.Add($_) }
        }
}

$records = foreach ($file in ($files | Sort-Object FullName)) {
    $hash = Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256
    $signature = Get-AuthenticodeSignature -LiteralPath $file.FullName
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($file.FullName)

    $displayPath = $file.FullName
    if ($env:USERPROFILE) { $displayPath = $displayPath.Replace($env:USERPROFILE, '%USERPROFILE%') }
    if ($env:LOCALAPPDATA) { $displayPath = $displayPath.Replace($env:LOCALAPPDATA, '%LOCALAPPDATA%') }

    [pscustomobject]@{
        path = $displayPath
        fileName = $file.Name
        bytes = $file.Length
        sha256 = $hash.Hash.ToLowerInvariant()
        lastWriteUtc = $file.LastWriteTimeUtc.ToString('o')
        fileVersion = $version.FileVersion
        productVersion = $version.ProductVersion
        productName = $version.ProductName
        signatureStatus = $signature.Status.ToString()
        signerSubject = if ($signature.SignerCertificate) { $signature.SignerCertificate.Subject } else { $null }
        signerThumbprint = if ($signature.SignerCertificate) { $signature.SignerCertificate.Thumbprint } else { $null }
    }
}

$result = [pscustomobject]@{
    reportType = 'read-only-installed-file-inventory'
    generatedUtc = [DateTime]::UtcNow.ToString('o')
    rootsScanned = @($roots | ForEach-Object {
        $p = $_
        if ($env:USERPROFILE) { $p = $p.Replace($env:USERPROFILE, '%USERPROFILE%') }
        if ($env:LOCALAPPDATA) { $p = $p.Replace($env:LOCALAPPDATA, '%LOCALAPPDATA%') }
        $p
    })
    filesFound = @($records).Count
    files = @($records)
    notes = @(
        'No target executable was launched.',
        'Configuration file contents were not read; only file hashes and metadata were collected.',
        'This report does not include process command lines, assessment URLs, tokens, logs, screenshots, audio or video.',
        'A missing file means it was not found under the scanned roots, not necessarily that it is absent from the machine.'
    )
}

$json = $result | ConvertTo-Json -Depth 6
if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
}
$json

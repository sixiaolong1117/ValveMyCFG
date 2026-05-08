Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$gameName = "Counter-Strike Global Offensive"
$targetRelativeDir = "game\csgo\cfg"
$configFiles = @(
    "mycs2.cfg",
    "mydemo.cfg",
    "f97cs2alist.cfg",
    "f97cs2basic.cfg"
)

function Get-NormalizedPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return [System.IO.Path]::GetFullPath($Path).TrimEnd('\')
}

function Test-SameSymlinkTarget {
    param(
        [Parameter(Mandatory = $true)][System.IO.FileSystemInfo]$Item,
        [Parameter(Mandatory = $true)][string]$ExpectedTarget
    )

    $linkTypeProperty = $Item.PSObject.Properties["LinkType"]
    if ($null -eq $linkTypeProperty -or $linkTypeProperty.Value -ne "SymbolicLink") {
        return $false
    }

    $targetProperty = $Item.PSObject.Properties["Target"]
    if ($null -eq $targetProperty) {
        return $false
    }

    $actualTarget = $targetProperty.Value
    if ($actualTarget -is [array]) {
        $actualTarget = $actualTarget[0]
    }

    if ([string]::IsNullOrWhiteSpace($actualTarget)) {
        return $false
    }

    if (-not [System.IO.Path]::IsPathRooted($actualTarget)) {
        $actualTarget = Join-Path (Split-Path -Parent $Item.FullName) $actualTarget
    }

    $actualFullPath = Get-NormalizedPath -Path $actualTarget
    $expectedFullPath = Get-NormalizedPath -Path $ExpectedTarget
    return [string]::Equals($actualFullPath, $expectedFullPath, [System.StringComparison]::OrdinalIgnoreCase)
}

function New-CfgSymlink {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$LinkPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        throw "Source cfg does not exist: $SourcePath"
    }

    $targetDir = Split-Path -Parent $LinkPath
    if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "Created directory: $targetDir"
    }

    $existingItem = Get-Item -LiteralPath $LinkPath -Force -ErrorAction SilentlyContinue
    if ($null -ne $existingItem) {
        if (Test-SameSymlinkTarget -Item $existingItem -ExpectedTarget $SourcePath) {
            Write-Host "Already linked: $LinkPath"
            return
        }

        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupPath = "$LinkPath.backup-$timestamp"
        Move-Item -LiteralPath $LinkPath -Destination $backupPath
        Write-Host "Backed up existing file: $backupPath"
    }

    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourcePath | Out-Null
    Write-Host "Linked: $LinkPath -> $SourcePath"
}

Write-Host "=== $gameName cfg link script ==="
Write-Host "Enter the game install root directory."
Write-Host "Example: D:\Program Files (x86)\Steam\steamapps\common\$gameName"
$gameRoot = Read-Host "Game install root"
$gameRoot = $gameRoot.Trim().Trim('"')

if ([string]::IsNullOrWhiteSpace($gameRoot)) {
    throw "Game install root cannot be empty."
}

if (-not (Test-Path -LiteralPath $gameRoot -PathType Container)) {
    throw "Game install root does not exist: $gameRoot"
}

$targetDir = Join-Path $gameRoot $targetRelativeDir
foreach ($configFile in $configFiles) {
    $sourcePath = Join-Path $PSScriptRoot $configFile
    $linkPath = Join-Path $targetDir $configFile
    New-CfgSymlink -SourcePath $sourcePath -LinkPath $linkPath
}

Write-Host "Done."

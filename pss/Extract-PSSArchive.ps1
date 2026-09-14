<#
.SYNOPSIS
    Validates the presence of C:\PDQ, C:\PDQ\PSS.zip, and C:\PSS, then extracts
    PSS.zip into C:\PSS.

.NOTES
    Exit codes:
      0 - Extraction completed successfully (C:\PDQ cleaned up)
      1 - C:\PDQ does not exist
      2 - C:\PDQ\PSS.zip does not exist
      3 - C:\PSS does not exist
      4 - Extraction failed
#>

$sourceFolder  = 'C:\PDQ'
$archivePath   = Join-Path $sourceFolder 'PSS.zip'
$destFolder    = 'C:\PSS'

# 1. Check C:\PDQ exists
if (-not (Test-Path -Path $sourceFolder -PathType Container)) {
    Write-Output "FAIL: '$sourceFolder' does not exist."
    exit 1
}

# 2. Check C:\PDQ\PSS.zip exists
if (-not (Test-Path -Path $archivePath -PathType Leaf)) {
    Write-Output "FAIL: '$archivePath' does not exist."
    exit 2
}

# 3. Check C:\PSS exists
if (-not (Test-Path -Path $destFolder -PathType Container)) {
    Write-Output "FAIL: '$destFolder' does not exist."
    exit 3
}

# 4. Extract archive to C:\PSS
try {
    Expand-Archive -Path $archivePath -DestinationPath $destFolder -Force -ErrorAction Stop
    Write-Output "SUCCESS: Extracted '$archivePath' to '$destFolder'."
}
catch {
    Write-Output "FAIL: Extraction of '$archivePath' to '$destFolder' failed: $($_.Exception.Message)"
    exit 4
}

# 5. Cleanup: remove C:\PDQ and its contents now that extraction succeeded
try {
    Remove-Item -Path $sourceFolder -Recurse -Force -ErrorAction Stop
    Write-Output "SUCCESS: Removed '$sourceFolder'."
}
catch {
    Write-Output "WARNING: Extraction succeeded, but cleanup of '$sourceFolder' failed: $($_.Exception.Message)"
}

exit 0

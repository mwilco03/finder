param(
    [string]$url = "http://frippery.org/files/busybox/busybox.exe",
    [string]$keywords
)

$ErrorActionPreference = "Stop"
$tempPath = [System.IO.Path]::GetTempPath()
$busyBoxPath = Join-Path -Path $tempPath -ChildPath "busybox.exe"

# Download BusyBox
try {
    Invoke-RestMethod -Uri $url -OutFile $busyBoxPath
    Write-Output "BusyBox downloaded successfully."
} catch {
    Write-Output "Error downloading BusyBox: $_"
    exit
}

# Define directories to search
$directories = @("$HOME\Documents", "$HOME\Downloads", "$HOME\Desktop")

# Search using BusyBox grep
try {
    foreach ($dir in $directories) {
        if (Test-Path $dir) {
            Write-Output "Searching in $dir"
            & $busyBoxPath grep -Erin $keywords $dir
        } else {
            Write-Output "Directory not found: $dir"
        }
    }
} catch {
    Write-Output "Error during search: $_"
} finally {
    Remove-Item -Path $busyBoxPath -Force
    Write-Output "Cleanup completed, BusyBox deleted."
}

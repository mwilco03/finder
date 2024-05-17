# Set error preference
$ErrorActionPreference = "Stop"

# Define the URL and local paths
$url = "http://frippery.org/files/busybox/busybox.exe"
$tempPath = [System.IO.Path]::GetTempPath()
$busyBoxPath = Join-Path -Path $tempPath -ChildPath "busybox.exe"

# Download BusyBox
try {
    Invoke-WebRequest -Uri $url -OutFile $busyBoxPath
    Write-Output "BusyBox downloaded successfully."
} catch {
    Write-Output "Error downloading BusyBox: $_"
    exit
}

# Define directories to search
$directories = @("$HOME\Documents", "$HOME\Downloads", "$HOME\Desktop")

# Search for the keywords using BusyBox grep
try {
    $keywords = "$kw1|$kw2"
    foreach ($dir in $directories) {
        if (Test-Path $dir) {
            Write-Output "Searching in $dir"
            & $busyBoxPath grep -Ern $keywords $dir
        } else {
            Write-Output "Directory not found: $dir"
        }
    }
} catch {
    Write-Output "Error during search: $_"
} finally {
    # Clean up
    Remove-Item -Path $busyBoxPath -Force
    Write-Output "Cleanup completed, BusyBox deleted."
}

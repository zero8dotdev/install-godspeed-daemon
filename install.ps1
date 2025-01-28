
Write-Host "Installing godspeed-daemon..."

# Check if running with administrator privileges
$runAsAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $runAsAdmin.IsInRole($adminRole)) {
    Write-Host "This script must be run as Administrator. Please right-click and 'Run as Administrator'."
    exit
}

# Define the target installation directory
$targetDir = "$env:USERPROFILE\AppData\Local\Programs\godspeed"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# Download the Windows executable to the target directory
$executableUrl = "https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main/executables/godspeed-daemon-win.exe"
$destinationPath = "$targetDir\godspeed-daemon.exe"

Write-Host "Downloading godspeed-daemon..."
Invoke-WebRequest -Uri $executableUrl -OutFile $destinationPath

# Wait for the download to finish
Start-Sleep -Seconds 10

# Verify if the download was successful
if (Test-Path -Path $destinationPath) {
    Write-Host "File downloaded successfully!"
} else {
    Write-Host "Download failed. Exiting script."
    exit
}

# Add the target directory to the PATH for this session
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$targetDir", [System.EnvironmentVariableTarget]::User)

# Verify if the installation was successful
if (Get-Command godspeed-daemon -ErrorAction SilentlyContinue) {
    Write-Host "Installation complete! You can now run 'godspeed-daemon'."
} else {
    Write-Host "Installation failed."
    exit
}


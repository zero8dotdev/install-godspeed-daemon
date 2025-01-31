Write-Host "Installing godspeed-daemon..."

# Check if running with administrator privileges
$runAsAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $runAsAdmin.IsInRole($adminRole)) {
    Write-Host "This script must be run as Administrator. Please right-click and 'Run as Administrator'." -ForegroundColor Red
    exit
}

# Define the target installation directory
$targetDir = "$env:USERPROFILE\AppData\Local\Programs\godspeed"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Download the Windows executable to the target directory
$executableUrl = "https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main/executables/godspeed-daemon-win.exe"
$destinationPath = "$targetDir\godspeed-daemon.exe"

Write-Host "Downloading godspeed-daemon..."
try {
    Invoke-WebRequest -Uri $executableUrl -OutFile $destinationPath -ErrorAction Stop
}
catch {
    Write-Host "Download failed: $_" -ForegroundColor Red
    exit
}

# Verify if the download was successful
if (Test-Path -Path $destinationPath) {
    Write-Host "File downloaded successfully!"
} else {
    Write-Host "Download failed. Exiting script." -ForegroundColor Red
    exit
}

# Add the target directory to the PATH for this session
$persistentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $persistentPath.Contains($targetDir)) {
    [Environment]::SetEnvironmentVariable('Path', "$persistentPath;$targetDir", 'User')
}

# Verify if the installation was successful
if (Get-Command godspeed-daemon -ErrorAction SilentlyContinue) {
    Write-Host "Installation complete! You can now run 'godspeed-daemon'." -ForegroundColor Green
} else {
    Write-Host "Installation failed." -ForegroundColor Red
    exit
}

# Create .godspeed directory and services.json if they don't exist
Write-Host "`nSetting up configuration files..." -ForegroundColor Cyan

$godspeedDir = Join-Path -Path $env:USERPROFILE -ChildPath ".godspeed"
$servicesJson = Join-Path -Path $godspeedDir -ChildPath "services.json"

# Create .godspeed directory
if (-not (Test-Path -Path $godspeedDir)) {
    Write-Host "Creating configuration directory: $godspeedDir"
    New-Item -ItemType Directory -Path $godspeedDir | Out-Null
}
else {
    Write-Host "Configuration directory already exists: $godspeedDir"
}

# Create services.json file
if (-not (Test-Path -Path $servicesJson)) {
    Write-Host "Creating configuration file: $servicesJson"
    New-Item -ItemType File -Path $servicesJson | Out-Null
}
else {
    Write-Host "Configuration file already exists: $servicesJson"
}

Write-Host "Configuration setup complete!`n" -ForegroundColor Cyan
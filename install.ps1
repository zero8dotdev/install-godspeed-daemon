Write-Host "Installing godspeed-daemon..."

# Check if running with administrator privileges
$runAsAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $runAsAdmin.IsInRole($adminRole)) {
    Write-Host "This script must be run as Administrator. Please right-click and 'Run as Administrator'." -ForegroundColor Red
    exit
}

# Define the GitHub release URL
$executableUrl = "https://github.com/zero8dotdev/install-godspeed-daemon/releases/download/v1.1.2/godspeed-daemon-win.exe"

# Define the target installation directory
$targetDir = "$env:USERPROFILE\AppData\Local\Programs\godspeed"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Define the destination path
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

# Add the target directory to the PATH for persistence
$persistentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $persistentPath.Contains($targetDir)) {
    [Environment]::SetEnvironmentVariable('Path', "$persistentPath;$targetDir", 'User')
}

# Add it to the current session as well (to take effect immediately)
$env:Path += ";$targetDir"

# Verify if the installation was successful
if (Test-Path -Path $destinationPath) {
    Write-Host "Installation complete! You can now run '$destinationPath'." -ForegroundColor Green
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

# Create services.json file with '{ "services": [] }' if it doesn't exist (UTF-8 without BOM)
if (-not (Test-Path -Path $servicesJson)) {
    Write-Host "Creating configuration file: $servicesJson"
    $content = '{ "services": [] }'
    [System.IO.File]::WriteAllText(
        $servicesJson,
        $content,
        [System.Text.UTF8Encoding]::new($false)
    )
} else {
    Write-Host "Configuration file already exists: $servicesJson"
}

Write-Host "Configuration setup complete!`n" -ForegroundColor Cyan
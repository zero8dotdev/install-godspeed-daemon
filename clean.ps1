#Requires -RunAsAdministrator
<#
.SYNOPSIS
Complete uninstaller for Godspeed CLI, daemon, NVM, Node.js, and related components.
#>

Write-Host "Starting Godspeed Complete Uninstallation..." -ForegroundColor Cyan

#region Admin Check
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator. Please right-click and 'Run as Administrator'." -ForegroundColor Red
    exit
}
#endregion

#region Godspeed CLI Uninstallation
Write-Host "`nUninstalling Godspeed CLI..." -ForegroundColor Cyan
try {
    npm uninstall -g @godspeedsystems/godspeed
    Write-Host "Godspeed CLI uninstalled successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to uninstall Godspeed CLI: $_" -ForegroundColor Yellow
}
#endregion

#region Daemon Removal
Write-Host "`nRemoving Godspeed Daemon..." -ForegroundColor Cyan
$targetDir = "$env:USERPROFILE\AppData\Local\Programs\godspeed"
$destinationPath = "$targetDir\godspeed-daemon.exe"

try {
    if (Test-Path $destinationPath) {
        # Stop running daemon process
        $daemonProcess = Get-Process | Where-Object { $_.Path -eq $destinationPath }
        if ($daemonProcess) {
            $daemonProcess | Stop-Process -Force
        }
        
        # Remove files
        Remove-Item $destinationPath -Force
        Write-Host "Daemon executable removed." -ForegroundColor Green
        
        # Remove from PATH if present
        $persistentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        if ($persistentPath.Contains($targetDir)) {
            $newPath = ($persistentPath -split ';' | Where-Object { $_ -ne $targetDir }) -join ';'
            [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
            Write-Host "Removed from user PATH." -ForegroundColor Green
        }
        
        # Remove directory if empty
        if ((Get-ChildItem $targetDir -Force | Measure-Object).Count -eq 0) {
            Remove-Item $targetDir -Force
        }
    } else {
        Write-Host "Daemon not found at $destinationPath" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Failed to remove daemon: $_" -ForegroundColor Red
}

# Remove configuration directory
$godspeedDir = Join-Path $env:USERPROFILE ".godspeed"
try {
    if (Test-Path $godspeedDir) {
        Remove-Item $godspeedDir -Recurse -Force
        Write-Host "Removed configuration directory." -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to remove configuration directory: $_" -ForegroundColor Yellow
}
#endregion

#region Node.js and NVM Cleanup
Write-Host "`nCleaning up Node.js and NVM..." -ForegroundColor Cyan

# Check for NVM installation
$nvmInstalled = $false
try {
    $nvmVersion = cmd /c nvm version 2>&1
    if (-not ($nvmVersion -match "not recognized")) {
        $nvmInstalled = $true
    }
} catch { }

if ($nvmInstalled) {
    Write-Host "NVM detected. Removing all Node.js versions..."
    try {
        # List all installed versions
        $versions = cmd /c nvm list | Where-Object { $_ -match '^  \d+' } | ForEach-Object { $_.Trim().Split(' ')[0] }
        
        foreach ($version in $versions) {
            cmd /c "nvm uninstall $version"
        }
        
        # Uninstall NVM itself
        Write-Host "Uninstalling NVM for Windows..." -ForegroundColor Cyan
        winget uninstall -e --id CoreyButler.NVMforWindows
        
        # Remove NVM environment variables
        [Environment]::SetEnvironmentVariable("NVM_HOME", $null, "User")
        [Environment]::SetEnvironmentVariable("NVM_SYMLINK", $null, "User")
        $env:NVM_HOME = $null
        $env:NVM_SYMLINK = $null
        
        # Remove NVM from PATH
        $persistentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        $nvmPath = (Get-ItemProperty "HKCU:\Environment" -ErrorAction SilentlyContinue).NVM_HOME
        if ($nvmPath) {
            $newPath = ($persistentPath -split ';' | Where-Object { $_ -ne $nvmPath -and $_ -ne "$nvmPath\nodejs" }) -join ';'
            [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        }
        
        Write-Host "NVM and all Node.js versions removed." -ForegroundColor Green
    } catch {
        Write-Host "Failed to clean NVM/Node.js: $_" -ForegroundColor Red
    }
} else {
    # Fallback: Check for standalone Node.js installation
    $nodeInstalled = Get-Command node -ErrorAction SilentlyContinue
    if ($nodeInstalled) {
        Write-Host "Standalone Node.js detected. Attempting to remove..."
        try {
            winget uninstall -e --id OpenJS.NodeJS
            Write-Host "Node.js removed via winget." -ForegroundColor Green
        } catch {
            Write-Host "Failed to remove Node.js. Please uninstall manually." -ForegroundColor Red
        }
    } else {
        Write-Host "No Node.js installation detected." -ForegroundColor Yellow
    }
}
#endregion

#region Git Uninstallation (Optional)
Write-Host "`nWould you like to uninstall Git? (y/n)" -ForegroundColor Cyan
$response = Read-Host
if ($response -eq 'y') {
    try {
        winget uninstall -e --id Git.Git
        Write-Host "Git uninstalled successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to uninstall Git: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Skipping Git uninstallation." -ForegroundColor Yellow
}
#endregion

#region Final Cleanup
Write-Host "`nPerforming final cleanup..." -ForegroundColor Cyan

# Remove npm cache
try {
    npm cache clean --force
    Write-Host "Cleared npm cache." -ForegroundColor Green
} catch {
    Write-Host "Failed to clear npm cache: $_" -ForegroundColor Yellow
}

# Remove temporary files
try {
    Remove-Item "$env:TEMP\npm-*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\godspeed-*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Cleaned temporary files." -ForegroundColor Green
} catch {
    Write-Host "Failed to clean temporary files: $_" -ForegroundColor Yellow
}

# Refresh environment
Write-Host "`nUninstallation complete! Please restart your computer to ensure all changes take effect." -ForegroundColor Green
Write-Host "This will ensure all environment variables are properly cleaned up." -ForegroundColor Yellow
#endregion

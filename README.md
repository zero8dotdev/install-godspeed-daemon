
# godspeed-daemon Installation Guide

## Introduction

`godspeed-daemon` is a cross-platform daemon that can be installed and run on Windows, macOS, and Linux. This guide will walk you through the installation process for each operating system using the new simplified installation commands.

## Prerequisites

Before proceeding with the installation, ensure you have the following:
- Administrator/root privileges (required for installation).
- **Windows**: A Windows 7 or later version.
- **macOS**: macOS 10.14 (Mojave) or later.
- **Linux**: Any Linux-based system (Ubuntu, Debian, CentOS, etc.).

## Installation

### 1. Windows Installation

1. **Open PowerShell as Administrator**:
   - Press `Win + X` and select "Windows PowerShell (Admin)".
   - Alternatively, you can search for "PowerShell", right-click on it, and select "Run as Administrator".

2. **Run the Installation Command**:
   - Copy and paste the following command into PowerShell and press Enter:

     ```powershell
     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main/install.ps1" -OutFile "install.ps1"; Start-Process powershell -ArgumentList "-File .\install.ps1" -Verb RunAs
     ```

3. **Follow the Script**:
   - The script will automatically download and install `godspeed-daemon` by executing the necessary steps.
   - It will download the `install.ps1` file, run it, and install the `godspeed-daemon` to the appropriate location.

4. **Verify the Installation**:
   - After the installation completes, open a new PowerShell window and type the following command:

     ```powershell
     godspeed-daemon
     ```

   - You should see the `godspeed-daemon` daemon running.

---

### 2. macOS Installation

1. **Open the Terminal**:
   - Press `Cmd + Space`, type "Terminal", and press Enter to open the Terminal.

2. **Run the Installation Command**:
   - Copy and paste the following command into the Terminal and press Enter:

     ```bash
     curl -fsSL https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main/install.sh | sudo bash
     ```

3. **Enter Your Password**:
   - You will be prompted to enter your macOS password to grant administrative privileges.

4. **Follow the Script**:
   - The script will automatically download and install `godspeed-daemon` by executing the necessary steps.
   - It will install the `godspeed-daemon` binary to `/usr/local/bin`.

5. **Verify the Installation**:
   - After the installation completes, open a new Terminal window and type the following command:

     ```bash
     godspeed-daemon
     ```

   - You should see the `godspeed-daemon` daemon running.

---

### 3. Linux Installation

1. **Open the Terminal**:
   - Press `Ctrl + Alt + T` (or open the terminal from your application menu).

2. **Run the Installation Command**:
   - Copy and paste the following command into the Terminal and press Enter:

     ```bash
     curl -fsSL https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main/install.sh | sudo bash
     ```

3. **Enter Your Password**:
   - You will be prompted to enter your Linux password to grant administrative privileges.

4. **Follow the Script**:
   - The script will automatically download and install `godspeed-daemon` by executing the necessary steps.
   - It will install the `godspeed-daemon` binary to `/usr/local/bin`.

5. **Verify the Installation**:
   - After the installation completes, open a new Terminal window and type the following command:

     ```bash
     godspeed-daemon
     ```

   - You should see the `godspeed-daemon` daemon running.

---

## Troubleshooting

1. **Command Not Found on Windows**:
   - If the `godspeed-daemon` command is not recognized after installation, ensure the executable is added to the system PATH.
   - You can verify this by typing `echo %PATH%` in PowerShell. If the installation directory is not included, follow the manual steps to add the path to your environment variables.

2. **Permission Issues**:
   - On macOS and Linux, ensure you have the correct permissions to run the scripts. If necessary, re-run the script using `sudo` to gain administrative privileges.

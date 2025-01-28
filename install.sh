#!/bin/bash

echo "Installing godspeed-daemon..."

# Check if the script is being run with sudo/root permissions
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# Define the GitHub repository URL
REPO_URL="https://raw.githubusercontent.com/zero8dotdev/install-godspeed-daemon/main"

# Define the installation and resource URLs for the executables
EXECUTABLE_URL_LINUX="$REPO_URL/executables/godspeed-daemon-linux"
EXECUTABLE_URL_MACOS="$REPO_URL/executables/godspeed-daemon-macos"

# Define the target installation directory
TARGET_DIR="/usr/local/bin"

# Determine the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    EXECUTABLE_URL=$EXECUTABLE_URL_MACOS
    EXECUTABLE_NAME="godspeed-daemon"
elif [[ "$(uname)" == "Linux" ]]; then
    EXECUTABLE_URL=$EXECUTABLE_URL_LINUX
    EXECUTABLE_NAME="godspeed-daemon"
else
    echo "Unsupported OS. This script supports only Linux and macOS."
    exit 1
fi

# Download the executable using curl
echo "Downloading the godspeed-daemon executable..."
curl -o "$TARGET_DIR/$EXECUTABLE_NAME" "$EXECUTABLE_URL" --silent --fail
if [[ $? -ne 0 ]]; then
    echo "Failed to download the executable. Please check your internet connection or the URL."
    exit 1
fi

# Make the downloaded file executable
chmod +x "$TARGET_DIR/$EXECUTABLE_NAME"

# Verify if the installation was successful
if command -v godspeed-daemon &>/dev/null; then
    echo "Installation complete! You can now run 'godspeed-daemon'."
else
    echo "Installation failed. Ensure $TARGET_DIR is in your PATH and try again."
    exit 1
fi

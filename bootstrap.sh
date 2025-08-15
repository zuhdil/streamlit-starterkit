#!/bin/bash

set -e

# Repository configuration
REPO_URL="https://github.com/your-username/streamlit-starterkit.git"  # REPLACE WITH YOUR ACTUAL REPO URL
TEMP_DIR="/tmp/streamlit-starterkit-$$"

echo "=== Streamlit App Bootstrap ==="
echo "Downloading Streamlit scaffolding tools..."

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: Git is required but not installed."
    echo "Please install git and try again."
    exit 1
fi

# Clone the repository to a temporary directory
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "Error: Failed to clone repository from $REPO_URL"
    echo "Please check your internet connection and repository URL."
    exit 1
}

# Run the main setup script
cd "$TEMP_DIR"
./setup_app.sh

# Cleanup - Remove the temporary directory after scaffolding
rm -rf "$TEMP_DIR"

echo
echo "Bootstrap complete! Your new Streamlit application is ready."
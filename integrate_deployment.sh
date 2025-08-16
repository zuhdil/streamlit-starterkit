#!/bin/bash

set -e

# Integration script for adding streamlit-starterkit deployment to existing projects
REPO_URL="https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/templates"

echo "=== Streamlit Deployment Integration ==="
echo "This script will add Cloud Run deployment capability to your existing Streamlit project."
echo

# Check if we're in a directory with Python files
if [ ! -f "requirements.txt" ] && [ -z "$(find . -maxdepth 1 -name "*.py" -type f)" ]; then
    echo "Error: This doesn't appear to be a Python project directory."
    echo "   Please run this script from your Streamlit project root directory."
    exit 1
fi

echo "Python project detected"

# Detect main Streamlit file
MAIN_FILES=()
for file in app.py main.py streamlit_app.py; do
    if [ -f "$file" ]; then
        MAIN_FILES+=("$file")
    fi
done

# Check for any .py file that imports streamlit
if [ ${#MAIN_FILES[@]} -eq 0 ]; then
    echo "Searching for Streamlit files..."
    while IFS= read -r -d '' file; do
        if grep -q "import streamlit\|from streamlit" "$file" 2>/dev/null; then
            MAIN_FILES+=("$(basename "$file")")
        fi
    done < <(find . -maxdepth 2 -name "*.py" -type f -print0)
fi

# Determine main file
MAIN_FILE=""
if [ ${#MAIN_FILES[@]} -eq 0 ]; then
    echo "Error: No Streamlit files detected."
    echo "   This script is designed for Streamlit projects."
    exit 1
elif [ ${#MAIN_FILES[@]} -eq 1 ]; then
    MAIN_FILE="${MAIN_FILES[0]}"
    echo "Found main Streamlit file: $MAIN_FILE"
else
    echo "Multiple Streamlit files found:"
    for i in "${!MAIN_FILES[@]}"; do
        echo "   $((i+1)). ${MAIN_FILES[i]}"
    done
    echo -n "Select main file (1-${#MAIN_FILES[@]}): "
    read -r selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#MAIN_FILES[@]}" ]; then
        MAIN_FILE="${MAIN_FILES[$((selection-1))]}"
        echo "Selected: $MAIN_FILE"
    else
        echo "Error: Invalid selection"
        exit 1
    fi
fi

# Backup existing files
echo "Creating backups..."
for file in deploy.sh deploy.env Dockerfile; do
    if [ -f "$file" ]; then
        cp "$file" "${file}.backup.$(date +%s)"
        echo "   Backed up $file"
    fi
done

# Download deployment files
echo "Downloading deployment files..."

# Download deploy.env
DEPLOY_ENV_DOWNLOADED=false
if curl -fsSL "${REPO_URL}/deploy.env" > deploy.env.tmp; then
    echo "   deploy.env downloaded"
    DEPLOY_ENV_DOWNLOADED=true
else
    echo "   Failed to download deploy.env, creating basic version..."
    cat > deploy.env.tmp << 'EOF'
# GCP Deployment Configuration
# Edit these values for your project

# Your Google Cloud Project ID
# Find this in your GCP Console or run: gcloud config get-value project
PROJECT_ID=akvo-lumen

# GCP region for deployment
# Common regions: us-central1, us-east1, europe-west1, europe-west4, asia-southeast1
REGION=europe-west4
EOF
    DEPLOY_ENV_DOWNLOADED=false
fi

# Download deploy.sh
if curl -fsSL "${REPO_URL}/deploy.sh" > deploy.sh.tmp; then
    echo "   deploy.sh downloaded"
else
    echo "   Failed to download deploy.sh"
    rm -f deploy.env.tmp deploy.sh.tmp
    exit 1
fi

# Download and adapt Dockerfile
if curl -fsSL "${REPO_URL}/Dockerfile" > Dockerfile.tmp; then
    echo "   Dockerfile downloaded"

    # Adapt Dockerfile if main file is not app.py
    if [ "$MAIN_FILE" != "app.py" ]; then
        echo "Adapting Dockerfile for main file: $MAIN_FILE"
        sed -i "s/app\.py/$MAIN_FILE/g" Dockerfile.tmp
    fi
else
    echo "   Failed to download Dockerfile, creating basic version..."
    cat > Dockerfile.tmp << EOF
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \\
    build-essential \\
    curl \\
    software-properties-common \\
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port that Streamlit runs on
EXPOSE 8080

# Health check
HEALTHCHECK CMD curl --fail http://localhost:8080/_stcore/health

# Run the application
CMD ["streamlit", "run", "$MAIN_FILE", "--server.port=8080", "--server.address=0.0.0.0", "--server.headless=true", "--server.fileWatcherType=none"]
EOF
fi

# Interactive configuration (only if deploy.env download failed)
if [ "$DEPLOY_ENV_DOWNLOADED" = false ]; then
    echo
    echo "Configuration Setup"
    echo -n "Enter your GCP Project ID: "
    read -r PROJECT_ID
    if [ -n "$PROJECT_ID" ]; then
        sed -i "s/akvo-lumen/$PROJECT_ID/g" deploy.env.tmp
    fi

    echo -n "Enter your preferred GCP region (default: europe-west4): "
    read -r REGION
    if [ -n "$REGION" ]; then
        sed -i "s/europe-west4/$REGION/g" deploy.env.tmp
    fi
else
    echo
    echo "Configuration loaded with defaults:"
    echo "   PROJECT_ID=akvo-lumen"
    echo "   REGION=europe-west4"
    echo "   Edit deploy.env to customize these values"
fi

# Move files to final location
mv deploy.env.tmp deploy.env
mv deploy.sh.tmp deploy.sh
mv Dockerfile.tmp Dockerfile

# Make scripts executable
chmod +x deploy.sh

# Validation
echo
echo "Validation..."

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "Warning: No requirements.txt found. Creating basic one..."
    echo "streamlit" > requirements.txt
    echo "pandas" >> requirements.txt
    echo "plotly" >> requirements.txt
fi

# Check if streamlit is in requirements
if ! grep -q "streamlit" requirements.txt; then
    echo "Warning: Adding streamlit to requirements.txt..."
    echo "streamlit" >> requirements.txt
fi

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "Warning: Docker not found. Please install Docker to use deployment."
fi

# Check gcloud installation
if ! command -v gcloud &> /dev/null; then
    echo "Warning: gcloud CLI not found. Please install Google Cloud SDK."
fi

echo
echo "Integration complete!"
echo
echo "Next steps:"
echo "1. Review deploy.env configuration"
echo "2. Test your app locally: streamlit run $MAIN_FILE"
echo "3. Deploy to Cloud Run: ./deploy.sh"
echo
echo "Files added:"
echo "   - deploy.sh (deployment script)"
echo "   - deploy.env (configuration)"
echo "   - Dockerfile (container config)"
echo
echo "For troubleshooting, visit:"
echo "   https://github.com/zuhdil/streamlit-starterkit"
#!/bin/bash

set -e

echo "=== Streamlit App Scaffold Generator ==="
echo "This script will create a new Streamlit application ready for Google Cloud Run deployment."
echo

# Function to normalize app name to cloud-compliant format
normalize_name() {
    local name="$1"
    # Convert to lowercase, replace spaces and underscores with hyphens, remove special chars
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]_]/-/g' | sed 's/[^a-z0-9-]//g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to process template with variable substitution
process_template() {
    local template_file="$1"
    local output_file="$2"
    local app_name="$3"

    if [ ! -f "$template_file" ]; then
        echo "Error: Template file $template_file not found."
        exit 1
    fi

    sed "s/{{APP_NAME}}/$app_name/g" "$template_file" > "$output_file"
}

# Get the script's directory to locate templates
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Validate templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "Error: Templates directory not found at $TEMPLATES_DIR"
    echo "Please ensure you're running this script from the correct location."
    exit 1
fi

# Prompt for application name
read -p "Enter your application name (e.g., 'My Analysis App'): " app_name

if [ -z "$app_name" ]; then
    echo "Error: Application name cannot be empty."
    exit 1
fi

# Normalize the name
normalized_name=$(normalize_name "$app_name")

if [ -z "$normalized_name" ]; then
    echo "Error: Application name must contain at least one alphanumeric character."
    exit 1
fi

echo "Creating application: '$app_name'"
echo "Directory name: '$normalized_name'"
echo

# Check if directory already exists
if [ -d "$normalized_name" ]; then
    echo "Error: Directory '$normalized_name' already exists."
    exit 1
fi

# Create project directory
mkdir "$normalized_name"
cd "$normalized_name"

echo "Creating project structure..."

# Process templates
echo "  Processing app.py..."
process_template "$TEMPLATES_DIR/app.py" "app.py" "$app_name"

echo "  Processing README.md..."
process_template "$TEMPLATES_DIR/README.md" "README.md" "$app_name"

echo "  Copying requirements.txt..."
cp "$TEMPLATES_DIR/requirements.txt" .

echo "  Copying Dockerfile..."
cp "$TEMPLATES_DIR/Dockerfile" .

echo "  Copying deploy.sh..."
cp "$TEMPLATES_DIR/deploy.sh" .

echo "  Copying deployment configuration..."
cp "$TEMPLATES_DIR/deploy.env" .

echo "  Copying .gitignore..."
cp "$TEMPLATES_DIR/.gitignore" .

# Make scripts executable
chmod +x deploy.sh

echo "Project scaffolding complete!"
echo
echo "Created directory: $normalized_name"
echo "Generated files:"
echo "   - app.py (Streamlit application)"
echo "   - README.md (Project documentation)"
echo "   - requirements.txt (Python dependencies)"
echo "   - Dockerfile (Container configuration)"
echo "   - deploy.sh (Deployment script)"
echo "   - deploy.env (Deployment configuration - EDIT THIS)"
echo "   - .gitignore (Git ignore rules)"
echo
echo "Next steps:"
echo "1. cd $normalized_name"
echo "2. Edit deploy.env and set your PROJECT_ID"
echo "3. Customize app.py for your use case"
echo "4. Run ./deploy.sh to deploy to Google Cloud Run"
echo
echo "Happy coding!"
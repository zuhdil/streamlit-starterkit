# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Streamlit application deployment starter kit designed to create an automated workflow for scaffolding, containerizing, and deploying Python Streamlit applications to Google Cloud Run. The project focuses on rapid deployment with minimal manual configuration and comprehensive documentation.

## Key Components

The repository contains templates and scripts for:

1. **Bootstrap Script** (`bootstrap.sh`) - Lightweight remote execution script that:
   - Handles `curl | bash` remote scaffolding workflow
   - Clones repository to temporary directory
   - Executes main scaffolding script
   - Cleans up temporary files

2. **Application Scaffolding Script** (`setup_app.sh`) - Interactive Bash script that:
   - Prompts for human-readable app name
   - Normalizes name to cloud-compliant format (lowercase, hyphens, alphanumeric)
   - Processes template files with variable substitution
   - Creates complete project directory with all necessary files
   - Makes scripts executable and provides next-step guidance

3. **Template System** (`templates/` directory) with:
   - **app.py** - Feature-rich Streamlit starter with Plotly Express visualizations
   - **requirements.txt** - Core dependencies (Streamlit, Pandas, NumPy, Plotly)
   - **Dockerfile** - Production-ready container with health checks
   - **deploy.sh** - Automated deployment with auto-authentication
   - **deploy.env** - External configuration file for PROJECT_ID and REGION
   - **README.md** - Comprehensive 291-line documentation with troubleshooting
   - **.gitignore** - GitHub-ready ignore rules for Python projects

## Workflow Architecture

The intended end-to-end process:
1. Remote execution via `curl ... | bash` (or local `./setup_app.sh`)
2. Interactive scaffolding with app name normalization
3. External configuration via `deploy.env` file (PROJECT_ID and REGION)
4. Auto-authentication with `gcloud auth login`
5. Custom development in generated app files
6. Deployment via `./deploy.sh` execution

## Technology Stack

- **Application Framework**: Python, Streamlit
- **Containerization**: Docker
- **Cloud Platform**: Google Cloud Platform (Cloud Run, Artifact Registry)
- **Automation**: Bash scripting, gcloud CLI

## Usage Commands

**Local development** (when you have the repo):
```bash
./setup_app.sh
```

**Remote bootstrap** (single command via curl):
```bash
curl -sL https://raw.githubusercontent.com/your-org/streamlit-starterkit/main/bootstrap.sh | bash
```

**Configuration and deployment** after scaffolding:
```bash
cd [app-directory]
# Configure deployment settings
nano deploy.env
# Deploy to Cloud Run
./deploy.sh
```

## Implementation Details

- **Two-script architecture**: Lightweight bootstrap + main scaffolding script for single-command usage
- **Template system**: Separate files in `templates/` directory with `{{APP_NAME}}` placeholders and sed substitution
- **External configuration**: `deploy.env` file for PROJECT_ID/REGION instead of editing scripts directly
- **Auto-authentication**: Automatic `gcloud auth login` prompting instead of error messages
- **Git-based distribution**: Bootstrap clones repo to temp directory and runs main script
- **Name normalization**: Converts spaces/underscores to hyphens, removes special characters, ensures lowercase
- **Error handling**: Validates inputs, checks for existing directories, comprehensive troubleshooting docs
- **Cloud Run optimization**: Uses Artifact Registry, proper memory/CPU limits, health checks
- **GitHub-ready**: Generated projects include .gitignore and comprehensive README.md
- **Organization defaults**: Akvo-optimized defaults (akvo-lumen project, europe-west4 region) but configurable

## Project Structure

```
streamlit-starterkit/
├── bootstrap.sh          # Lightweight script for curl | bash usage
├── setup_app.sh          # Main scaffolding script
├── templates/            # Template files directory
│   ├── app.py           # Streamlit app template with {{APP_NAME}} placeholders
│   ├── requirements.txt # Python dependencies with Plotly Express
│   ├── Dockerfile       # Container configuration with health checks
│   ├── deploy.sh        # Deployment script with auto-authentication
│   ├── deploy.env       # External configuration (PROJECT_ID, REGION)
│   ├── README.md        # 291-line comprehensive documentation
│   └── .gitignore       # GitHub-ready ignore rules
├── CLAUDE.md            # This file
├── README.md            # Project documentation with curl usage
└── PROJECT_BRIEF.md     # Original project specifications
```

## Configuration and Troubleshooting

### Default Configuration
- **Project ID**: akvo-lumen (configurable via deploy.env)
- **Region**: europe-west4 (configurable via deploy.env)
- **Visualization**: Plotly Express (preferred over Altair for data science)
- **Health Check**: Uses Streamlit's `/_stcore/health` endpoint

### Common Issues and Solutions
- **Authentication**: Auto-prompts for `gcloud auth login` if not authenticated
- **Docker permissions**: Template README includes Docker troubleshooting
- **GCP project access**: Comprehensive permissions guide in generated README
- **Name conflicts**: Automatic normalization prevents cloud naming issues
- **Template maintenance**: Separate files instead of embedded heredocs

### Generated App Features
Each scaffolded app includes:
- GitHub-ready structure with .gitignore and comprehensive README
- Self-contained 291-line documentation with troubleshooting
- Interactive Streamlit app with sample data visualization
- One-command deployment with external configuration
- Production-ready Dockerfile with health checks

## Style Guidelines

### Emoji Usage
- **Minimize emoji usage** in all scripts and documentation
- Use plain text prefixes like "Error:", "Warning:", "Note:" instead of emojis
- Maintain compatibility across different terminal environments
- Exception: Can be used sparingly in README.md for visual appeal if needed

### Git Commit Guidelines
When making commits to this repository:
- Use short, descriptive commit messages (no signatures)
- Focus on the actual changes made
- Avoid adding author signatures or generated tags

### Script Output
- Use clear, professional text output
- Prefer descriptive text over symbols and emojis
- Ensure output is readable in all terminal environments
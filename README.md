# Streamlit Starter Kit

A streamlined toolkit for rapidly scaffolding, developing, and deploying Python Streamlit applications to Google Cloud Run. This starter kit automates the entire workflow from idea to production deployment with minimal configuration.

## Features

- **One-command scaffolding** - Create a complete Streamlit app structure instantly
- **Remote setup** - Use curl/wget for zero-installation setup
- **Docker containerization** - Production-ready containers included
- **Auto-deployment** - Deploy to Google Cloud Run with a single command
- **Interactive visualizations** - Template includes Plotly Express examples
- **Authentication handling** - Automatic Google Cloud authentication
- **European deployment** - Optimized defaults for Europe-based deployments

## Quick Start

### Remote Scaffolding (Recommended)

Create a new Streamlit app without cloning this repository:

```bash
# Using curl
curl -sL https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/bootstrap.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/bootstrap.sh | bash
```

### Local Setup

If you have this repository locally:

```bash
./setup_app.sh
```

## Local Development

After scaffolding your app:

### 1. Navigate to Your Project
```bash
cd your-app-name
```

### 2. Set Up Python Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/Mac:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Run Locally
```bash
streamlit run app.py
```

Your app will be available at `http://localhost:8501`

### 5. Customize Your App
- Edit `app.py` to build your Streamlit application
- Modify `requirements.txt` to add Python dependencies
- The template includes examples with:
  - Interactive sidebar controls
  - Plotly Express visualizations
  - Data tables and metrics
  - Sample data generation

## Cloud Deployment

### Prerequisites
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed
- [Docker](https://docs.docker.com/get-docker/) installed
- Access to a Google Cloud Project

### Configuration

1. **Edit deployment configuration**:
   ```bash
   nano deploy.env
   ```

2. **Set your Google Cloud Project ID**:
   ```bash
   # Your Google Cloud Project ID
   PROJECT_ID=your-project-id

   # GCP region for deployment
   REGION=europe-west4
   ```

3. **Find your project ID**:
   ```bash
   gcloud config get-value project
   ```

### Deploy to Google Cloud Run

```bash
./deploy.sh
```

The deployment script will automatically:
- Authenticate with Google Cloud (if needed)
- Enable required APIs (Cloud Run, Artifact Registry, etc.)
- Build and push your Docker image
- Deploy to Cloud Run
- Provide the public URL for your app

### Deployment Features

- **Automatic authentication** - Opens browser for Google OAuth if needed
- **API management** - Enables required Google Cloud services automatically
- **Container registry** - Creates and manages Artifact Registry repositories
- **Health checks** - Built-in health monitoring for your app
- **Auto-scaling** - Scales from 0 to 10 instances based on traffic
- **Public access** - Deployed apps are publicly accessible by default

## Generated Project Structure

```
your-app-name/
├── app.py              # Main Streamlit application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Container configuration
├── deploy.sh          # Deployment script
└── deploy.env         # Deployment configuration
```

## Template Features

The generated `app.py` includes:

- **Interactive sidebar** with configuration controls
- **Multiple visualization types** (scatter, line, bar charts)
- **Data manipulation** with pandas
- **Plotly Express integration** for interactive charts
- **Responsive layout** with columns and expandable sections
- **Sample data generation** for quick prototyping

## Configuration Options

### Deployment Configuration (`deploy.env`)

```bash
# Required: Your Google Cloud Project ID
PROJECT_ID=your-project-id

# Required: Deployment region
REGION=europe-west4
```

### Available Regions

Common Google Cloud regions:
- `europe-west4` (Netherlands) - Default
- `europe-west1` (Belgium)
- `us-central1` (Iowa)
- `us-east1` (South Carolina)
- `asia-southeast1` (Singapore)

## Troubleshooting

### Authentication Issues
```bash
# Re-authenticate with Google Cloud
gcloud auth login

# Set your project
gcloud config set project YOUR_PROJECT_ID
```

### Docker Issues
```bash
# Ensure Docker is running
docker --version

# Check Docker authentication
gcloud auth configure-docker europe-west4-docker.pkg.dev
```

### Local Development Issues
```bash
# Reinstall dependencies
pip install --upgrade -r requirements.txt

# Check Python version (requires 3.8+)
python --version
```

### Deployment Failures
- Verify your `PROJECT_ID` in `deploy.env`
- Ensure you have permissions in your Google Cloud Project
- Check that billing is enabled for your project
- Verify Docker is running and authenticated

## For Organizations

### Customizing Defaults

To customize for your organization:

1. **Fork this repository**
2. **Update `templates/deploy.env`** with your defaults:
   ```bash
   PROJECT_ID=your-org-project
   REGION=your-preferred-region
   ```
3. **Update the bootstrap URL** in your documentation

### Team Workflow

For teams using the same Google Cloud Project:
1. Set organization defaults in `templates/deploy.env`
2. Team members can scaffold apps with zero configuration
3. All apps deploy to the same project with consistent settings

## Examples

### Creating Multiple Apps

```bash
# Create first app
curl -sL [bootstrap_url] | bash
# Enter: "Sales Dashboard"
# Creates: sales-dashboard/

# Create second app
curl -sL [bootstrap_url] | bash
# Enter: "ML Model Monitor"
# Creates: ml-model-monitor/
```

### Development Workflow

```bash
# 1. Scaffold
curl -sL [bootstrap_url] | bash

# 2. Develop locally
cd my-app
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
streamlit run app.py

# 3. Deploy when ready
./deploy.sh

# 4. Update and redeploy
# Edit app.py
./deploy.sh  # Redeploys automatically
```

## For Existing Projects

If you already have a Streamlit app and want to add Cloud Run deployment:

### Integration Script (Recommended)

Run this command from within your existing Streamlit project directory:

```bash
# Navigate to your existing Streamlit project first
cd your-existing-streamlit-project

# Then run the integration script
curl -sL https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/integrate_deployment.sh | bash
```

This script will:
- **Auto-detect** your main Streamlit file (app.py, main.py, etc.)
- **Download** deployment files (deploy.sh, deploy.env, Dockerfile)
- **Adapt** Dockerfile to your project structure
- **Configure** your GCP settings interactively
- **Backup** existing files before making changes

### Manual Integration

1. **Copy deployment files** to your project:
   ```bash
   wget https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/templates/deploy.sh
   wget https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/templates/deploy.env
   wget https://raw.githubusercontent.com/zuhdil/streamlit-starterkit/main/templates/Dockerfile
   ```

2. **Make executable and configure**:
   ```bash
   chmod +x deploy.sh
   nano deploy.env  # Set your PROJECT_ID and REGION
   ```

3. **Update Dockerfile** if your main file isn't `app.py`:
   ```dockerfile
   # Change this line in Dockerfile
   CMD ["streamlit", "run", "your-main-file.py", "--server.port=8080", ...]
   ```

4. **Deploy**: `./deploy.sh`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the scaffolding and deployment process
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- **Issues**: Report bugs or request features via GitHub Issues
- **Documentation**: Check the `CLAUDE.md` file for development guidance
- **Community**: Share your apps and get help in GitHub Discussions

---

**Happy building!** Go from idea to deployed Streamlit app in minutes.
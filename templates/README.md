# {{APP_NAME}}

A Streamlit application built with the [Streamlit Starter Kit](https://github.com/zuhdil/streamlit-starterkit).

## Quick Start

### Run Locally

1. **Set up your environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the app**:
   ```bash
   streamlit run app.py
   ```

4. **Open your browser** to `http://localhost:8501`

## Cloud Deployment

### Prerequisites

Before deploying, ensure you have:
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed
- [Docker](https://docs.docker.com/get-docker/) installed
- Access to a Google Cloud Project with appropriate permissions

### Deployment Configuration

1. **Edit deployment configuration**:
   ```bash
   nano deploy.env
   ```

2. **Set your Google Cloud Project ID**:
   ```bash
   # Required: Your Google Cloud Project ID
   PROJECT_ID=your-project-id

   # Required: Deployment region
   REGION=europe-west4
   ```

3. **Find your project ID**:
   ```bash
   gcloud config get-value project
   ```

### Available Regions

Choose from these common Google Cloud regions:
- `europe-west4` (Netherlands) - Default
- `europe-west1` (Belgium)
- `us-central1` (Iowa)
- `us-east1` (South Carolina)
- `asia-southeast1` (Singapore)

### Deploy to Google Cloud Run

```bash
./deploy.sh
```

The deployment script will automatically:
- Authenticate with Google Cloud (opens browser if needed)
- Enable required APIs (Cloud Run, Artifact Registry, etc.)
- Build and push your Docker image
- Deploy to Cloud Run with optimized settings
- Provide the public URL for your app

### Deployment Features

Your deployed app includes:
- **Automatic authentication** - Handles Google OAuth seamlessly
- **API management** - Enables required Google Cloud services
- **Container registry** - Creates and manages Artifact Registry repositories
- **Health checks** - Built-in health monitoring
- **Auto-scaling** - Scales from 0 to 10 instances based on traffic
- **Public access** - Deployed apps are publicly accessible

## Troubleshooting

### Authentication Issues

If you encounter authentication problems:

```bash
# Re-authenticate with Google Cloud
gcloud auth login

# Set your project
gcloud config set project YOUR_PROJECT_ID

# Verify authentication
gcloud auth list
```

### Docker Issues

Ensure Docker is running and authenticated:

```bash
# Check if Docker is running
docker --version
docker ps

# Configure Docker authentication for GCP
gcloud auth configure-docker europe-west4-docker.pkg.dev

# Test Docker functionality
docker run hello-world
```

### Local Development Issues

Common local development solutions:

```bash
# Reinstall dependencies
pip install --upgrade -r requirements.txt

# Check Python version (requires 3.8+)
python --version

# Clear Streamlit cache
streamlit cache clear

# Run with verbose output
streamlit run app.py --logger.level=debug
```

### Deployment Failures

If deployment fails, check these common issues:

**Configuration Issues:**
- Verify your `PROJECT_ID` in `deploy.env`
- Ensure `REGION` is set correctly
- Check that your project ID exists and is accessible

**Permission Issues:**
- Ensure you have appropriate permissions in your Google Cloud Project
- Required roles: Cloud Run Admin, Artifact Registry Administrator
- Check that billing is enabled for your project

**Docker Issues:**
- Verify Docker is running: `docker ps`
- Ensure Docker authentication: `gcloud auth configure-docker`
- Check disk space for Docker images

**Network Issues:**
- Verify internet connectivity
- Check if corporate firewall blocks Docker/GCP access
- Ensure DNS resolution works: `nslookup googleapis.com`

### Common Error Messages

**"Permission denied" on Cloud Run deployment:**
```bash
# Missing Cloud Run permissions
# Solution: Ask admin to grant roles/run.admin role
```

**"Cannot create Artifact Registry repository":**
```bash
# Missing Artifact Registry permissions
# Solution: Ask admin to grant roles/artifactregistry.admin role
```

**"Cannot enable APIs":**
```bash
# Missing Service Usage permissions
# Solution: Ask admin to grant roles/serviceusage.serviceUsageAdmin role
```

**"Access denied" on Docker push:**
```bash
# Authentication issue
gcloud auth configure-docker europe-west4-docker.pkg.dev --quiet
```

### Getting Help

If you're still having issues:

1. **Check the deployment logs** for specific error messages
2. **Verify all prerequisites** are installed and configured
3. **Test each component** individually (Docker, gcloud CLI)
4. **Contact your system administrator** for permission-related issues

## Development

### Project Structure

```
├── app.py              # Main Streamlit application
├── README.md           # This documentation
├── requirements.txt    # Python dependencies
├── Dockerfile         # Container configuration
├── deploy.sh          # Deployment script
├── deploy.env         # Deployment configuration
└── .gitignore         # Git ignore rules
```

### Customizing Your App

- **Edit `app.py`** to add your application logic
- **Update `requirements.txt`** to add Python packages you need
- **Modify the deployment configuration** in `deploy.env` if needed

### Adding New Features

The template includes examples of:
- Interactive sidebar controls
- Data visualization with Plotly Express
- Data tables and metrics
- Sample data generation

You can build upon these examples or replace them entirely with your own functionality.

### Development Workflow

1. **Develop locally**: Make changes and test with `streamlit run app.py`
2. **Version control**: Commit changes to git
3. **Deploy**: Run `./deploy.sh` to deploy to Cloud Run
4. **Iterate**: Repeat the process for updates

### Adding Python Dependencies

To add new Python packages:

1. **Install locally**:
   ```bash
   pip install package-name
   ```

2. **Update requirements.txt**:
   ```bash
   pip freeze > requirements.txt
   ```

3. **Test locally** to ensure everything works
4. **Deploy** with `./deploy.sh`

## Version Control

This project is ready for Git:

```bash
# Initialize git repository
git init

# Add files
git add .

# Commit
git commit -m "Initial commit"

# Add remote repository
git remote add origin https://github.com/yourusername/your-repo.git

# Push to GitHub
git push -u origin main
```

The included `.gitignore` file ensures sensitive files and temporary files are not committed.

## Support

- **Streamlit Documentation**: [docs.streamlit.io](https://docs.streamlit.io/)
- **Google Cloud Run Documentation**: [cloud.google.com/run/docs](https://cloud.google.com/run/docs)
- **Starter Kit Issues**: [GitHub Issues](https://github.com/zuhdil/streamlit-starterkit/issues)

## Contributing

1. Create a feature branch: `git checkout -b feature-name`
2. Make your changes
3. Test locally with `streamlit run app.py`
4. Commit and push your changes
5. Deploy when ready with `./deploy.sh`

---

**Happy building!** Your Streamlit app is ready for development and deployment.
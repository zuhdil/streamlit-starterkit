#!/bin/bash

set -e

# Load configuration from deploy.env file
if [ -f "deploy.env" ]; then
    echo "Loading configuration from deploy.env..."
    source deploy.env
else
    echo "Error: deploy.env configuration file not found"
    echo "Please edit the deploy.env file with your GCP configuration."
    echo "Set your PROJECT_ID and other deployment settings."
    exit 1
fi

# Configuration loaded from deploy.env file

# Automatically determine service name from directory
SERVICE_NAME=$(basename "$(pwd)")
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "=== Streamlit App Deployment ==="
echo "Project ID: ${PROJECT_ID}"
echo "Service Name: ${SERVICE_NAME}"
echo "Image: ${IMAGE_NAME}"
echo "Region: ${REGION}"
echo

# Validate configuration
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID not configured"
    echo "Please edit deploy.env and set your GCP project ID"
    exit 1
fi

if [ -z "$REGION" ]; then
    echo "Error: REGION not configured"
    echo "Please edit deploy.env and set your preferred GCP region"
    exit 1
fi

# Check if gcloud is installed and authenticated
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud CLI is not installed"
    echo "   Install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated, auto-login if needed
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n1 > /dev/null; then
    echo "Not authenticated with gcloud. Starting login process..."
    gcloud auth login
    echo "Authentication complete. Continuing with deployment..."
fi

# Set project
echo "Setting GCP project..."
gcloud config set project "${PROJECT_ID}"

# Enable required APIs (only if not already enabled)
echo "Ensuring required APIs are enabled..."
gcloud services enable cloudbuild.googleapis.com --quiet
gcloud services enable run.googleapis.com --quiet
gcloud services enable artifactregistry.googleapis.com --quiet

# Create Artifact Registry repository if it doesn't exist
echo "Setting up Artifact Registry..."
if ! gcloud artifacts repositories describe streamlit-apps --location=${REGION} &> /dev/null; then
    echo "   Creating Artifact Registry repository..."
    gcloud artifacts repositories create streamlit-apps \
        --repository-format=docker \
        --location=${REGION} \
        --description="Repository for Streamlit applications"
fi

# Configure Docker authentication
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet

# Update image name to use Artifact Registry
IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/streamlit-apps/${SERVICE_NAME}"

echo "Building Docker image..."
docker build -t "${IMAGE_NAME}" .

echo "Pushing image to Artifact Registry..."
docker push "${IMAGE_NAME}"

echo "Deploying to Cloud Run..."
gcloud run deploy "${SERVICE_NAME}" \
    --image="${IMAGE_NAME}" \
    --platform=managed \
    --region="${REGION}" \
    --allow-unauthenticated \
    --port=8080 \
    --memory=1Gi \
    --cpu=1 \
    --max-instances=10 \
    --timeout=3600

echo
echo "Deployment complete!"
echo
echo "Your application is available at:"
gcloud run services describe "${SERVICE_NAME}" --platform=managed --region="${REGION}" --format='value(status.url)'
echo
echo "To deploy updates, simply run ./deploy.sh again from this directory."
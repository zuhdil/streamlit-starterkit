FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port that Streamlit runs on
EXPOSE 8080

# Health check - uses Streamlit's official health endpoint
# The /_stcore/health endpoint returns "ok" when Streamlit server is running
# Note: This checks server availability, not application-level errors
HEALTHCHECK CMD curl --fail http://localhost:8080/_stcore/health

# Run the application
CMD ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0", "--server.headless=true", "--server.fileWatcherType=none"]
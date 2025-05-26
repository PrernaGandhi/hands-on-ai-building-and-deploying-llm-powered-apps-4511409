# Use Python 3.9 slim image as the base
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install system dependencies for PDF processing
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    poppler-utils \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a modified requirements file without chromadb
COPY requirements.txt .
RUN grep -v "chromadb" requirements.txt > requirements_no_chroma.txt

# Install everything except chromadb
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements_no_chroma.txt

# Install chromadb with pip options that avoid problematic dependencies
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org chromadb==0.4.17 \
    --no-deps && \
    pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org hnswlib posthog clickhouse-connect duckdb pypika mmh3 overrides pandas pulsar-client BCrypt fastapi uvicorn \
    && pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org packaging typing_extensions numpy pydantic requests tqdm 

# Copy the application code and other necessary files
COPY app/ ./app/
COPY sample_pdf/ ./sample_pdf/
COPY chainlit.md ./

# Expose the port Chainlit runs on (default is 8000)
EXPOSE 8000

# Command to run the Chainlit application
CMD ["chainlit", "run", "app/app.py", "--host", "0.0.0.0"]

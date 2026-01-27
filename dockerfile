FROM python:3.11-slim

# Prevent Python buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create exports directory with proper permissions
RUN mkdir -p /app/exports && chmod 755 /app/exports

# Expose port
EXPOSE 5000

# FIXED: Use Gunicorn instead of Flask dev server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "--workers=4", "--timeout=120", "app:app"]

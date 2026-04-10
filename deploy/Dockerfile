# OpenClaw Independent Runtime - Docker Container
# Self-contained, portable, zero dependencies

FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install base dependencies
RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

# Set working directory
WORKDIR /app

# Copy all OpenClaw files
COPY . .

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies (if requirements.txt exists)
RUN if [ -f requirements.txt ]; then \
        pip install --no-cache-dir -r requirements.txt; \
    else \
        echo "No requirements.txt found, skipping..."; \
    fi

# Make scripts executable
RUN chmod +x scripts/*.sh bin/* 2>/dev/null || true

# Create data directory
RUN mkdir -p /app/data /app/logs

# Expose port for web interface
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Set environment variables
ENV OPENCLAW_ENV=docker
ENV OPENCLAW_PORT=3000
ENV OPENCLAW_DATA=/app/data

# Volume for persistent data
VOLUME ["/app/data", "/app/logs"]

# Default command - start OpenClaw server
CMD ["python3", "-m", "http.server", "3000"]

# Alternative: Run specific script
# CMD ["python3", "main.py"]

# Alternative: Interactive shell
# CMD ["/bin/bash"]

FROM swift:5.9

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
WORKDIR /workspace

# Copy project files
COPY . .

# Build project
RUN swift build

# Default command
CMD ["swift", "run", "demo"]

# Apple Directory

Apple-specific research and experimental code for Metal image processing.

## Environment

Use the research development shell:
```bash
nix develop .#research
```

## Scripts

- **gpu_capabilities.swift** - Explore Metal GPU capabilities
- **performance_analysis.swift** - Analyze kernel performance characteristics
- **flake.nix** - Research environment with Python/Jupyter

## Usage

```bash
# Explore GPU capabilities
swift apple/gpu_capabilities.swift

# Analyze performance
swift apple/performance_analysis.swift

# Start research environment
cd apple && nix develop
```

## Research Areas

- Metal GPU architecture analysis
- Apple Silicon optimization strategies
- Performance profiling and benchmarking
- Algorithm complexity analysis
- Memory bandwidth utilization

# GPU Directory

GPU-specific profiling and analysis tools for Metal development.

## Scripts

- **memory_profiler.swift** - GPU memory allocation and usage profiler
- **compute_analyzer.swift** - Compute unit and threadgroup optimization analyzer
- **thermal_profiler.swift** - Thermal and power consumption profiler

## Usage

```bash
# Profile GPU memory
swift gpu/memory_profiler.swift

# Analyze compute units
swift gpu/compute_analyzer.swift

# Profile thermal behavior
swift gpu/thermal_profiler.swift
```

## Analysis Areas

- **Memory Management** - Buffer and texture allocation limits
- **Compute Optimization** - Threadgroup configuration efficiency
- **Thermal Behavior** - Power consumption and thermal throttling
- **Performance Bottlenecks** - Memory bandwidth and compute utilization

## Integration

These tools can be integrated into:
- CI/CD pipelines for performance regression testing
- Development workflows for optimization guidance
- Production monitoring for thermal management

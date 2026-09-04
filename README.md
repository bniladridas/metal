<p align="center">
  <img src="https://raw.githubusercontent.com/basebin/metal/main/.github/assets/thumbnail.png" alt="metal" width="100%">
</p>

# metal

High-performance GPU-accelerated image processing for Swift using Metal compute shaders.

Updates the MetalProcessor configuration to support a config property that is a map of Metal-specific settings that will be transformed into Metal shader compilation flags and runtime parameters.

Therefore, something like this:

```swift
let processor = try MetalProcessor(config: [
  "optimization_level": 3,
  "threadgroup_size": ["width": 16, "height": 16],
  "fast_math": true,
  "memory_access": ["coalesced": true, "bandwidth_optimized": true]
])
```

would result in the following Metal configuration being applied:

```
-O3 -ffast-math -threadgroup-size-hint=16,16 -memory-access=coalesced,bandwidth-optimized
```

## Configuration

We should be able to provide a fully typed config interface and validation schema, including narrow enums of the permitted values in specific config positions. Can we push the Metal framework to do this?

For example, Swift can natively represent that threadgroup_size has a fixed set of valid configurations. Let's do that!

```swift
public enum ThreadgroupSize {
    case small   // 8x8
    case medium  // 16x16
    case large   // 32x32
    case custom(width: Int, height: Int)
}

public enum OptimizationLevel: Int {
    case none = 0
    case size = 1
    case speed = 2
    case aggressive = 3
}

public struct MetalConfig {
    let optimizationLevel: OptimizationLevel
    let threadgroupSize: ThreadgroupSize
    let fastMath: Bool
    let memoryAccess: MemoryAccessPattern
}
```

Ideally with tests to ensure it matches the real Metal shader compilation format!

> **Note**: That is not something we have the bandwidth to take on right now, but contributions are welcome for a fully typed configuration system.

## Install

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/bniladridas/metal.git", from: "1.0.0")
]
```

### Xcode

1. File → Add Package Dependencies
2. Enter: `https://github.com/bniladridas/metal.git`
3. Add to your target

## Quick Start

```swift
import metal

let processor = try MetalProcessor()

// Apply Gaussian blur
let blurred = try processor.gaussianBlur(texture: inputTexture, radius: 5.0)

// Edge detection
let edges = try processor.edgeDetection(texture: inputTexture)

// Custom convolution
let sharpen: [Float] = [0, -1, 0, -1, 5, -1, 0, -1, 0]
let sharpened = try processor.convolution(texture: inputTexture, kernel: sharpen, kernelSize: 3)
```

## Performance

Benchmarked on M1 Pro (1024×1024 texture):

- **Gaussian Blur**: 3.32ms per operation
- **Edge Detection**: 0.94ms per operation
- **Convolution**: 1.60ms per operation

## Requirements

- macOS 12+ / iOS 15+
- Metal-compatible GPU
- Swift 5.9+

### Metal Toolchain Installation

To install Metal Toolchain for shader validation:

```bash
xcodebuild -downloadComponent MetalToolchain
```

This enables standalone Metal shader compilation and validation tools.

## Demo

```bash
git clone https://github.com/bniladridas/metal.git
cd metal
swift run demo
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](docs/CONTRIBUTING.md) for details.

## Code of Conduct

This project adheres to our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## License

MIT License - see [LICENSE](LICENSE) for details.

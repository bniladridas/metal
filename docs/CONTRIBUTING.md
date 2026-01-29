# Contributing to metal

We welcome contributions to the metal project! This guide will help you get started.

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/metal.git
cd metal
```

2. Build and test:
```bash
swift build
swift test
swift run demo
```

## Making Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass: `swift test`
6. Submit a pull request

## Code Style

- Follow Swift naming conventions
- Add documentation for public APIs
- Include performance tests for new operations
- Keep Metal shaders optimized for Apple GPUs

## Reporting Issues

Please use GitHub Issues to report bugs or request features. Include:
- Swift version
- macOS/iOS version
- GPU model
- Minimal reproduction case

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

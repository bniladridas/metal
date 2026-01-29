# Tools Directory

Build and deployment tools for the metal project.

## Scripts

- **e2e_test.swift** - End-to-end test runner
- **package.swift** - Project packaging utility

## Usage

```bash
# Run E2E tests
swift tools/e2e_test.swift

# Create release package
swift tools/package.swift
```

## E2E Test Flow

1. Build project (`swift build`)
2. Run unit tests (`swift test`)
3. Execute demo (`swift run demo`)
4. Validate Metal shaders
5. Report results

## Packaging

Creates versioned archives in `pkg/` directory with:
- Source code
- Documentation
- Metal shaders
- Package manifest

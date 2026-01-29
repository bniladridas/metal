#!/usr/bin/env swift

import Foundation

struct E2ETestRunner {
    func runTests() {
        print("Running E2E tests for metal project...")

        // Test 1: Build project
        print("\n1. Building project...")
        guard runCommand("swift", args: ["build"]) else {
            print("✗ Build failed")
            exit(1)
        }
        print("✓ Build successful")

        // Test 2: Run unit tests
        print("\n2. Running unit tests...")
        guard runCommand("swift", args: ["test"]) else {
            print("✗ Unit tests failed")
            exit(1)
        }
        print("✓ Unit tests passed")

        // Test 3: Run demo
        print("\n3. Running demo...")
        guard runCommand("swift", args: ["run", "demo"]) else {
            print("✗ Demo failed")
            exit(1)
        }
        print("✓ Demo completed")

        // Test 4: Validate Metal shaders
        print("\n4. Validating Metal shaders...")
        guard runCommand("swift", args: ["hack/validate_metal.swift"]) else {
            print("✗ Metal validation failed")
            exit(1)
        }
        print("✓ Metal shaders validated")

        print("\n🎉 All E2E tests passed!")
    }

    private func runCommand(_ command: String, args: [String]) -> Bool {
        let process = Process()
        process.launchPath = "/usr/bin/\(command)"
        process.arguments = args

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        process.launch()
        process.waitUntilExit()

        return process.terminationStatus == 0
    }
}

E2ETestRunner().runTests()

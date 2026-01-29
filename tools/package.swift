#!/usr/bin/env swift

import Foundation

struct ProjectPackager {
    func createPackage() {
        print("Creating metal project package...")

        let version = getVersion()
        let packageName = "metal-\(version)"

        print("Package: \(packageName)")

        // Create package directory
        let packageDir = "pkg/\(packageName)"
        createDirectory(packageDir)

        // Copy essential files
        let filesToCopy = [
            "Package.swift",
            "README.md",
            "LICENSE",
            "VERSION",
            "shaders.metal",
            "Sources/",
            "Tests/",
        ]

        for file in filesToCopy {
            copyItem(from: file, to: "\(packageDir)/\(file)")
        }

        // Create archive
        let archiveName = "\(packageName).tar.gz"
        if runCommand("tar", args: ["-czf", "pkg/\(archiveName)", "-C", "pkg", packageName]) {
            print("✓ Package created: pkg/\(archiveName)")
        } else {
            print("✗ Failed to create archive")
            exit(1)
        }

        // Cleanup
        removeDirectory(packageDir)

        print("📦 Packaging complete!")
    }

    private func getVersion() -> String {
        guard let version = try? String(contentsOfFile: "VERSION").trimmingCharacters(in: .whitespacesAndNewlines) else {
            return "1.0.0"
        }
        return version
    }

    private func createDirectory(_ path: String) {
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    private func copyItem(from source: String, to destination: String) {
        try? FileManager.default.copyItem(atPath: source, toPath: destination)
    }

    private func removeDirectory(_ path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }

    private func runCommand(_ command: String, args: [String]) -> Bool {
        let process = Process()
        process.launchPath = "/usr/bin/\(command)"
        process.arguments = args
        process.launch()
        process.waitUntilExit()
        return process.terminationStatus == 0
    }
}

// Create pkg directory if it doesn't exist
try? FileManager.default.createDirectory(atPath: "pkg", withIntermediateDirectories: true)

ProjectPackager().createPackage()

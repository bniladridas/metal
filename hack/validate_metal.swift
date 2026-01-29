#!/usr/bin/env swift

import Foundation

func validateMetalShaders() {
    print("Validating Metal shaders...")

    // Check if xcrun is available
    let xcrunCheck = Process()
    xcrunCheck.launchPath = "/usr/bin/which"
    xcrunCheck.arguments = ["xcrun"]
    xcrunCheck.launch()
    xcrunCheck.waitUntilExit()

    guard xcrunCheck.terminationStatus == 0 else {
        print("✗ xcrun not found (Metal compiler unavailable)")
        exit(1)
    }

    print("✓ xcrun found")

    // Check if shaders.metal exists
    guard FileManager.default.fileExists(atPath: "shaders.metal") else {
        print("✗ shaders.metal not found")
        exit(1)
    }

    // Compile Metal shaders
    print("Compiling shaders.metal...")

    let metalCompile = Process()
    metalCompile.launchPath = "/usr/bin/xcrun"
    metalCompile.arguments = ["-sdk", "macosx", "metal", "-c", "shaders.metal", "-o", "/tmp/shaders.air"]

    let pipe = Pipe()
    metalCompile.standardError = pipe
    metalCompile.launch()
    metalCompile.waitUntilExit()

    if metalCompile.terminationStatus == 0 {
        print("✓ Metal shaders compiled successfully")
        try? FileManager.default.removeItem(atPath: "/tmp/shaders.air")
    } else {
        print("✗ Metal shader compilation failed")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let error = String(data: data, encoding: .utf8) {
            print(error)
        }
        exit(1)
    }

    print("Metal validation complete")
}

validateMetalShaders()

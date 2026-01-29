#!/usr/bin/env swift

import Foundation
import Metal

// GPU compute unit analyzer
struct ComputeUnitAnalyzer {
    func analyzeComputeUnits() {
        print("GPU Compute Unit Analysis")
        print("========================")

        guard let device = MTLCreateSystemDefaultDevice() else {
            print("No Metal device available")
            return
        }

        print("Device: \(device.name)")
        print("Max threads per threadgroup: \(device.maxThreadsPerThreadgroup)")

        // Analyze optimal threadgroup configurations
        print("\nOptimal threadgroup configurations:")

        let configurations = [
            (8, 8, 1),
            (16, 16, 1),
            (32, 32, 1),
            (64, 4, 1),
            (128, 2, 1),
            (256, 1, 1),
        ]

        for (width, height, depth) in configurations {
            let total = width * height * depth
            let maxThreads = device.maxThreadsPerThreadgroup.width

            if total <= maxThreads {
                let efficiency = Double(total) / Double(maxThreads) * 100
                print("  \(width)x\(height)x\(depth) = \(total) threads (\(String(format: "%.1f", efficiency))% efficiency) ✓")
            } else {
                print("  \(width)x\(height)x\(depth) = \(total) threads (exceeds limit) ✗")
            }
        }

        // Memory bandwidth estimation
        print("\nMemory bandwidth analysis:")
        let pixelSize = 4 // RGBA8

        for (width, height, _) in configurations.prefix(4) {
            let threadsPerGroup = width * height
            let bytesPerGroup = threadsPerGroup * pixelSize
            let groupsFor1024 = (1024 * 1024) / threadsPerGroup
            let totalBandwidth = groupsFor1024 * bytesPerGroup

            print("  \(width)x\(height): ~\(totalBandwidth / 1024 / 1024)MB for 1024x1024 texture")
        }
    }
}

ComputeUnitAnalyzer().analyzeComputeUnits()

#!/usr/bin/env swift

import Foundation
import Metal

// Metal GPU capability explorer
struct MetalExplorer {
    func exploreCapabilities() {
        print("Metal GPU Exploration")
        print("====================")

        guard let device = MTLCreateSystemDefaultDevice() else {
            print("No Metal device available")
            return
        }

        print("Device: \(device.name)")
        print("Max threads per threadgroup: \(device.maxThreadsPerThreadgroup)")
        print("Max buffer length: \(device.maxBufferLength / 1024 / 1024) MB")
        print("Supports non-uniform threadgroups: \(device.supportsFamily(.common3))")

        if #available(macOS 10.15, *) {
            print("Max threadgroup memory: \(device.maxThreadgroupMemoryLength) bytes")
        }

        // Test different threadgroup sizes
        print("\nOptimal threadgroup sizes:")
        let sizes = [(8, 8), (16, 16), (32, 32)]

        for (width, height) in sizes {
            let total = width * height
            if total <= device.maxThreadsPerThreadgroup.width {
                print("  \(width)x\(height) = \(total) threads ✓")
            } else {
                print("  \(width)x\(height) = \(total) threads ✗")
            }
        }
    }
}

MetalExplorer().exploreCapabilities()

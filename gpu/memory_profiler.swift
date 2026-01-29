#!/usr/bin/env swift

import Foundation
import Metal

// GPU memory profiler
struct GPUMemoryProfiler {
    func profileMemoryUsage() {
        print("GPU Memory Profiler")
        print("===================")

        guard let device = MTLCreateSystemDefaultDevice() else {
            print("No Metal device available")
            return
        }

        print("Device: \(device.name)")

        // Test different buffer sizes
        let sizes = [1, 4, 16, 64, 256, 512] // MB

        print("\nMemory allocation test:")
        for sizeMB in sizes {
            let sizeBytes = sizeMB * 1024 * 1024

            if let buffer = device.makeBuffer(length: sizeBytes, options: .storageModeShared) {
                print("✓ Allocated \(sizeMB)MB buffer")
                // Release immediately for testing
            } else {
                print("✗ Failed to allocate \(sizeMB)MB buffer")
            }
        }

        // Test texture memory
        print("\nTexture memory test:")
        let textureSizes = [512, 1024, 2048, 4096]

        for size in textureSizes {
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: .rgba8Unorm,
                width: size,
                height: size,
                mipmapped: false
            )
            descriptor.usage = [.shaderRead, .shaderWrite]

            if let texture = device.makeTexture(descriptor: descriptor) {
                let memoryMB = (size * size * 4) / (1024 * 1024)
                print("✓ Created \(size)x\(size) texture (~\(memoryMB)MB)")
            } else {
                print("✗ Failed to create \(size)x\(size) texture")
            }
        }
    }
}

GPUMemoryProfiler().profileMemoryUsage()

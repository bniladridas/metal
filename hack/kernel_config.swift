#!/usr/bin/env swift

import Foundation

struct KernelConfig: Codable {
    let kernel: String
    let threadsPerThreadgroup: ThreadgroupSize
    let optimizations: Optimizations

    struct ThreadgroupSize: Codable {
        let width: Int
        let height: Int
        let depth: Int
    }

    struct Optimizations: Codable {
        let memoryAccess: String
        let boundaryChecking: Bool
        let vectorization: Bool
    }
}

func generateKernelConfig(name: String, threadsPerGroup: (Int, Int) = (16, 16)) -> KernelConfig {
    KernelConfig(
        kernel: name,
        threadsPerThreadgroup: KernelConfig.ThreadgroupSize(
            width: threadsPerGroup.0,
            height: threadsPerGroup.1,
            depth: 1
        ),
        optimizations: KernelConfig.Optimizations(
            memoryAccess: "coalesced",
            boundaryChecking: true,
            vectorization: true
        )
    )
}

let kernels = ["gaussianBlur", "sobelEdgeDetection", "convolution"]
var configs: [String: KernelConfig] = [:]

for kernel in kernels {
    configs[kernel] = generateKernelConfig(name: kernel)
}

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

if let data = try? encoder.encode(configs),
   let json = String(data: data, encoding: .utf8)
{
    print(json)
}

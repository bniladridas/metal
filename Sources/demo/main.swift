import CoreGraphics
import Metal
import metal
import MetalKit

@main
struct Demo {
    static func main() async {
        print("Metal Image Processing Demo")

        do {
            let processor = try MetalProcessor()

            // Create a test texture
            let testTexture = try createTestTexture()
            print("Created test texture: \(testTexture.width)x\(testTexture.height)")

            // Apply Gaussian blur
            let blurredTexture = try processor.gaussianBlur(texture: testTexture, radius: 5.0)
            print("Applied Gaussian blur")

            // Apply edge detection
            let edgeTexture = try processor.edgeDetection(texture: testTexture)
            print("Applied edge detection")

            // Apply custom convolution (sharpen filter)
            let sharpenKernel: [Float] = [
                0, -1, 0,
                -1, 5, -1,
                0, -1, 0,
            ]
            let sharpenTexture = try processor.convolution(texture: testTexture, kernel: sharpenKernel, kernelSize: 3)
            print("Applied sharpen convolution")

            // Performance benchmark
            await benchmarkPerformance(processor: processor, texture: testTexture)

        } catch {
            print("Error: \(error)")
        }
    }

    static func createTestTexture() throws -> MTLTexture {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw MetalError.deviceNotFound
        }

        let width = 1024
        let height = 1024

        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: width,
            height: height,
            mipmapped: false
        )
        descriptor.usage = [.shaderRead, .shaderWrite]

        guard let texture = device.makeTexture(descriptor: descriptor) else {
            throw MetalError.textureCreationFailed
        }

        // Fill with test pattern
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        var pixels = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        for y in 0 ..< height {
            for x in 0 ..< width {
                let index = (y * width + x) * bytesPerPixel
                pixels[index] = UInt8((x * 255) / width) // R
                pixels[index + 1] = UInt8((y * 255) / height) // G
                pixels[index + 2] = UInt8(128) // B
                pixels[index + 3] = 255 // A
            }
        }

        texture.replace(
            region: MTLRegionMake2D(0, 0, width, height),
            mipmapLevel: 0,
            withBytes: pixels,
            bytesPerRow: bytesPerRow
        )

        return texture
    }

    static func benchmarkPerformance(processor: MetalProcessor, texture: MTLTexture) async {
        print("\nPerformance Benchmark")

        let iterations = 100

        // Benchmark Gaussian blur
        let blurStart = CFAbsoluteTimeGetCurrent()
        for _ in 0 ..< iterations {
            _ = try? processor.gaussianBlur(texture: texture, radius: 3.0)
        }
        let blurTime = CFAbsoluteTimeGetCurrent() - blurStart

        // Benchmark edge detection
        let edgeStart = CFAbsoluteTimeGetCurrent()
        for _ in 0 ..< iterations {
            _ = try? processor.edgeDetection(texture: texture)
        }
        let edgeTime = CFAbsoluteTimeGetCurrent() - edgeStart

        // Benchmark convolution
        let sharpenKernel: [Float] = [0, -1, 0, -1, 5, -1, 0, -1, 0]
        let convStart = CFAbsoluteTimeGetCurrent()
        for _ in 0 ..< iterations {
            _ = try? processor.convolution(texture: texture, kernel: sharpenKernel, kernelSize: 3)
        }
        let convTime = CFAbsoluteTimeGetCurrent() - convStart

        print("Gaussian Blur: \(String(format: "%.2f", blurTime * 1000))ms (\(iterations) iterations)")
        print("Edge Detection: \(String(format: "%.2f", edgeTime * 1000))ms (\(iterations) iterations)")
        print("Convolution: \(String(format: "%.2f", convTime * 1000))ms (\(iterations) iterations)")
        print("Avg Blur: \(String(format: "%.2f", (blurTime / Double(iterations)) * 1000))ms per operation")
        print("Avg Edge: \(String(format: "%.2f", (edgeTime / Double(iterations)) * 1000))ms per operation")
        print("Avg Conv: \(String(format: "%.2f", (convTime / Double(iterations)) * 1000))ms per operation")
    }
}

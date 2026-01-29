@testable import metal
import XCTest

final class MetalTests: XCTestCase {
    var processor: MetalProcessor!

    override func setUp() {
        super.setUp()
        processor = try? MetalProcessor()
        XCTAssertNotNil(processor, "Failed to initialize MetalProcessor")
    }

    func testGaussianBlur() throws {
        let texture = try createTestTexture(width: 256, height: 256)
        let blurredTexture = try processor.gaussianBlur(texture: texture, radius: 2.0)

        XCTAssertEqual(blurredTexture.width, texture.width)
        XCTAssertEqual(blurredTexture.height, texture.height)
        XCTAssertEqual(blurredTexture.pixelFormat, texture.pixelFormat)
    }

    func testEdgeDetection() throws {
        let texture = try createTestTexture(width: 256, height: 256)
        let edgeTexture = try processor.edgeDetection(texture: texture)

        XCTAssertEqual(edgeTexture.width, texture.width)
        XCTAssertEqual(edgeTexture.height, texture.height)
        XCTAssertEqual(edgeTexture.pixelFormat, texture.pixelFormat)
    }

    func testPerformance() throws {
        let texture = try createTestTexture(width: 512, height: 512)

        measure {
            _ = try? processor.gaussianBlur(texture: texture, radius: 3.0)
        }
    }

    private func createTestTexture(width: Int, height: Int) throws -> MTLTexture {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw MetalError.deviceNotFound
        }

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

        return texture
    }
}

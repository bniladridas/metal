#include <metal_stdlib>
using namespace metal;

kernel void gaussianBlur(texture2d<float, access::read> inputTexture [[texture(0)]],
                        texture2d<float, access::write> outputTexture [[texture(1)]],
                        constant float &radius [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {

    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }

    int kernelSize = int(radius * 2) + 1;
    float sigma = radius / 3.0;
    float twoSigmaSquared = 2.0 * sigma * sigma;

    float4 sum = float4(0.0);
    float weightSum = 0.0;

    for (int y = -kernelSize/2; y <= kernelSize/2; y++) {
        for (int x = -kernelSize/2; x <= kernelSize/2; x++) {
            int2 coord = int2(gid) + int2(x, y);
            coord = clamp(coord, int2(0), int2(inputTexture.get_width()-1, inputTexture.get_height()-1));

            float distance = sqrt(float(x*x + y*y));
            float weight = exp(-distance * distance / twoSigmaSquared);

            sum += inputTexture.read(uint2(coord)) * weight;
            weightSum += weight;
        }
    }

    outputTexture.write(sum / weightSum, gid);
}

kernel void sobelEdgeDetection(texture2d<float, access::read> inputTexture [[texture(0)]],
                              texture2d<float, access::write> outputTexture [[texture(1)]],
                              uint2 gid [[thread_position_in_grid]]) {

    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }

    // Sobel X kernel
    float sobelX[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
    // Sobel Y kernel
    float sobelY[9] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};

    float4 gradientX = float4(0.0);
    float4 gradientY = float4(0.0);

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            int2 coord = int2(gid) + int2(x, y);
            coord = clamp(coord, int2(0), int2(inputTexture.get_width()-1, inputTexture.get_height()-1));

            int kernelIndex = (y + 1) * 3 + (x + 1);
            float4 pixel = inputTexture.read(uint2(coord));

            gradientX += pixel * sobelX[kernelIndex];
            gradientY += pixel * sobelY[kernelIndex];
        }
    }

    float4 magnitude = sqrt(gradientX * gradientX + gradientY * gradientY);
    outputTexture.write(magnitude, gid);
}

kernel void convolution(texture2d<float, access::read> inputTexture [[texture(0)]],
                       texture2d<float, access::write> outputTexture [[texture(1)]],
                       constant float* convKernel [[buffer(0)]],
                       constant int& kernelSize [[buffer(1)]],
                       uint2 gid [[thread_position_in_grid]]) {

    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }

    float4 sum = float4(0.0);
    int halfSize = kernelSize / 2;

    for (int y = -halfSize; y <= halfSize; y++) {
        for (int x = -halfSize; x <= halfSize; x++) {
            int2 coord = int2(gid) + int2(x, y);
            coord = clamp(coord, int2(0), int2(inputTexture.get_width()-1, inputTexture.get_height()-1));

            int kernelIndex = (y + halfSize) * kernelSize + (x + halfSize);
            float4 pixel = inputTexture.read(uint2(coord));

            sum += pixel * convKernel[kernelIndex];
        }
    }

    outputTexture.write(sum, gid);
}

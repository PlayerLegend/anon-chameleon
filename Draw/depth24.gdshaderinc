
uniform float depth24_far = 100.0;

vec3 depth24_encode(float d) {
    d = clamp(d, 0.0, 1.0);
    uint v = uint(d * 16777215.0 + 0.5);        // 24-bit integer
    float r = float((v >> 16u) & 255u);
    float g = float((v >> 8u)  & 255u);
    float b = float(v & 255u);
    return vec3(r, g, b) / 255.0;
}

float depth24_decode(vec3 c) {
    c = floor(c * 255.0 + 0.5);                     // snap back to exact bytes
    return (c.r * 65536.0 + c.g * 256.0 + c.b) / 16777215.0;
}

#define DEPTH24_LINEAR_DEPTH -VERTEX.z / depth24_far  // view-space distance, normalized

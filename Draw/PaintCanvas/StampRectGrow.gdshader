shader_type canvas_item;
render_mode blend_premul_alpha;

uniform int radius : hint_range(0, 8) = 2;

void fragment() {
    vec2 px = TEXTURE_PIXEL_SIZE;
    vec4 best = texture(TEXTURE, UV);

    for (int y = -radius; y <= radius; y++) {
        for (int x = -radius; x <= radius; x++) {
            if (x * x + y * y > radius * radius) continue;  // round kernel
            vec4 s = texture(TEXTURE, UV + vec2(float(x), float(y)) * px);
            if (s.a > best.a) best = s;
        }
    }
    COLOR = best;
}
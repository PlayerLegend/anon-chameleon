shader_type canvas_item;

uniform sampler2D uv_texture : filter_nearest;
uniform vec2 brush_pos;
uniform float radius = 0.02;
uniform vec2 out_size = vec2(1024.0);
uniform int grid = 64;               // must match brush_mesh.gd
uniform float pad_px = 1.5;          // small safety padding
uniform float max_jump_px = 48.0;    // footprint larger than this = seam/silhouette, don't stretch
uniform vec4 brush_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

varying float keep;

void vertex() {
    float step_src = 2.0 * radius / float(grid - 1);
    vec2 src = brush_pos + (COLOR.rg - 0.5) * 2.0 * radius;

    vec4 m  = textureLod(uv_texture, src, 0.0);
    vec4 mx = textureLod(uv_texture, src + vec2(step_src, 0.0), 0.0);
    vec4 my = textureLod(uv_texture, src + vec2(0.0, step_src), 0.0);

    vec2 dx = (mx.rg - m.rg) * out_size;
    vec2 dy = (my.rg - m.rg) * out_size;

    // Neighbour is background, or UVs jump (UV seam / silhouette): fall back to a plain quad
    bool ok_x = mx.a > 0.5 && length(dx) < max_jump_px;
    bool ok_y = my.a > 0.5 && length(dy) < max_jump_px;
    if (!ok_x) dx = vec2(0.0);
    if (!ok_y) dy = vec2(0.0);

    keep = step(distance(src, brush_pos), radius) * step(0.5, m.a);

    vec2 c = UV - 0.5;
    VERTEX = m.rg * out_size + c.x * dx + c.y * dy + c * pad_px;
}

void fragment() {
    if (keep < 0.5) discard;
    COLOR = brush_color;
}
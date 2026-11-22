shader_type canvas_item;

uniform sampler2D uv_texture : filter_nearest;
uniform vec2 brush_pos;              // 0..1 in uv_map space (e.g. screen position)
uniform float radius = 0.02;         // in the same 0..1 space
uniform vec2 out_size = vec2(1024.0);
uniform float quad_px = 3.0;         // quad size in output pixels; covers gaps
uniform vec4 brush_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

varying float keep;

void vertex() {
    // Which source pixel does this quad represent?
    vec2 src = brush_pos + (COLOR.rg - 0.5) * 2.0 * radius;

    vec4 m = textureLod(uv_texture, src, 0.0);
    vec2 target = m.rg;                         // where it lands on the output

    keep = step(distance(src, brush_pos), radius) * step(0.5, m.a);

    VERTEX = target * out_size + (UV - 0.5) * quad_px;
}

void fragment() {
    if (keep < 0.5) discard;
    COLOR = brush_color;
}
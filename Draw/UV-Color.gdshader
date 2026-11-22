shader_type spatial;

uniform sampler2D base_albedo : source_color;
uniform sampler2D paint_tex : source_color, filter_linear, hint_default_transparent;

void fragment() {
    if (CAMERA_VISIBLE_LAYERS == (1u << 19u)) {
        // UV pass: output raw UVs
        ALBEDO = vec3(0.0);
        EMISSION = vec3(UV, 0.0);
        SPECULAR = 0.0;
    } else {
        // Normal pass: base texture with paint on top
        vec3 base = texture(base_albedo, UV).rgb;
        vec4 p = texture(paint_tex, UV);
        ALBEDO = mix(base, p.rgb, p.a);
    }
}
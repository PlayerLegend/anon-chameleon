shader_type spatial;
render_mode blend_premul_alpha;

uniform sampler2D base_albedo : source_color;
uniform sampler2D paint_albedo : source_color, filter_linear, hint_default_transparent;

void fragment() {
    vec3 base = texture(base_albedo, UV).rgb;
    vec4 paint = texture(paint_albedo, UV);
    //ALBEDO = mix(base, paint.rgb, paint.a);
    ALBEDO = base * (1.0 - paint.a) + paint.rgb;
}

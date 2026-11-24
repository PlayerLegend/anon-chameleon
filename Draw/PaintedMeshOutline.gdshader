shader_type spatial;

uniform sampler2D base_albedo : source_color;
uniform sampler2D paint_albedo : source_color, filter_linear, hint_default_transparent;
uniform vec4 outline_tint : source_color;

void fragment() {
    vec4 paint = texture(paint_albedo, UV);
    //if (paint.a < 0.5)
        //discard;
    vec3 base = texture(base_albedo, UV).rgb;
    //ALBEDO = mix(base, (vec4(paint.rgb, 1.0) * outline_tint).rgb, paint.a);
    ALBEDO = base * (1.0 - paint.a) + outline_tint.rgb * paint.a;
}

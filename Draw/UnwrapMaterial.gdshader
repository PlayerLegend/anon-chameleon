shader_type spatial;
render_mode unshaded, cull_disabled;

#include "WorldPositionTexture.gdshaderinc"

uniform sampler2D depth_texture : filter_nearest;
uniform vec2 cursor_uv;

varying vec3 world_pos;
varying flat vec3 cursor_world_pos;
varying flat float hit;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    vec4 s = textureLod(depth_texture, cursor_uv, 0.0);
    cursor_world_pos = world_position_decode(s.rgb);
    hit = s.a;

    POSITION = vec4(UV * 2.0 - 1.0, 1.0, 1.0);
}

void fragment() {
    vec3 d = world_pos - cursor_world_pos;
    if (hit < 0.5 || dot(d, d) > 0.0025) discard;   // 0.05 radius
    ALBEDO = vec3(1.0, 0.0, 0.5);
}
shader_type spatial;
render_mode unshaded;

#include "WorldPositionCommon.gdshaderinc"

varying vec3 world_pos;

vec3 world_position_encode(vec3 pos)
{
    return (pos - world_position_origin) / world_position_width + 0.5;
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    ALBEDO = world_position_encode(world_pos);
}
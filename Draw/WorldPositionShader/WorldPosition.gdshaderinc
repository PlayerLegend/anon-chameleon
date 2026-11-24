#include "WorldPositionCommon.gdshaderinc"

uniform sampler2D world_position_texture : filter_nearest;

vec4 world_position_sample(vec2 uv)
{
    vec4 encoded = texture(world_position_texture, uv);
    return vec4((encoded.xyz - 0.5) * world_position_width + world_position_origin, encoded.a);
}

uniform vec3 world_position_origin = vec3(0);
uniform float world_position_width = 10.0;

vec3 world_position_encode(vec3 pos)
{
    return (pos - world_position_origin) / world_position_width + 0.5;
}

vec3 world_position_decode(vec3 encoded)
{
    return (encoded - 0.5) * world_position_width + world_position_origin;
}
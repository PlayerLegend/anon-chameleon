shader_type spatial;
render_mode unshaded;

varying vec3 world_pos;

#include "depth24.gdshaderinc"

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    ALBEDO = depth24_encode(DEPTH24_LINEAR_DEPTH);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

shader_type spatial;
render_mode unshaded;

uniform vec3 paint_color : source_color = vec3(1.0, 0.0, 0.5);
uniform sampler2D depth_texture : filter_nearest, hint_default_transparent;

uniform vec2 cursor_uv;

// Main-camera data, set from DrawTex._process each frame.
uniform mat4 main_cam_inv_view;
uniform mat4 main_cam_inv_proj;
uniform vec3 main_cam_pos;
uniform float main_cam_far = 100.0;

varying vec3 world_pos;

varying vec3 cursor_ray_origin;
varying vec3 cursor_ray_dir;
varying float cursor_ray_z;

#include "depth24.gdshaderinc"

void vertex() {
    // Real world-space position of this surface fragment.
    // (MeshInstanceSync gives the unwrap mesh the same transform as the painted mesh.)
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Draw the unwrap flat in UV space; the spatial camera is irrelevant for position.
    POSITION = vec4(UV * 2.0 - 1.0, 1.0, 1.0);

    // Build the cursor ray in MAIN-camera world space from the cursor's screen UV,
    // NOT from this vertex's UV, and NOT with this shader's INV_VIEW/INV_PROJ
    // (those belong to the unwrap camera).
    vec3 ndc_corner = vec3(cursor_uv * 2.0 - 1.0, 1.0);
    vec4 world_h    = main_cam_inv_view * main_cam_inv_proj * vec4(ndc_corner, 1.0);
    vec3 world_pt   = world_h.xyz / world_h.w;

    cursor_ray_origin = main_cam_pos;
    cursor_ray_dir    = world_pt - main_cam_pos;

    // View-space depth of the far-plane point along the main camera's forward axis.
    vec3 cam_forward  = -main_cam_inv_view[2].xyz;
    cursor_ray_z      = -dot(cursor_ray_dir, cam_forward);
}

void fragment() {
    // Depth at the cursor, in view-space units of the main/depth camera.
    float view_depth = depth24_decode(texture(depth_texture, cursor_uv).rgb) * main_cam_far;

    // Walk the cursor ray to the surface point under the cursor.
    float t = view_depth / cursor_ray_z;
    vec3 cursor_world_pos = cursor_ray_origin + cursor_ray_dir * t;

    if (distance(world_pos, cursor_world_pos) > 1.0)
        ALBEDO = vec3(1.0);
    else
        ALBEDO = paint_color;
}
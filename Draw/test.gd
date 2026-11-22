extends Node3D

@export var pan_center: Node3D
@export var pan_camera: Camera3D

@export var brush_material: ShaderMaterial
@export var brush_subviewport: SubViewport
@export var uv_subviewport: SubViewport
@export var screen_material: ShaderMaterial
@export var uv_color_material: ShaderMaterial

func _ready():
    assert(brush_material)
    brush_material.set_shader_parameter("uv_texture", uv_subviewport.get_texture())
    screen_material.set_shader_parameter("screen_render", brush_subviewport.get_texture())
    brush_material.set_shader_parameter("out_size", Vector2(brush_subviewport.size))
    uv_color_material.set_shader_parameter("paint_tex", brush_subviewport.get_texture())
    
func _process_painting():
    var painting := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

    if painting:
        brush_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    elif brush_subviewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS:
        brush_subviewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
        
    if not painting:
        return

    # Mouse position normalised to 0..1 in the same space as uv_map
    var vp := get_viewport()
    var pos := vp.get_mouse_position() / Vector2(vp.get_visible_rect().size)

    brush_material.set_shader_parameter("brush_pos", pos)
    print("Set brush pos ", pos)

@export var orbit_sensitivity := 0.005   # radians per pixel
@export var min_pitch_deg := -85.0
@export var max_pitch_deg := 85.0
var _orbit_last_mouse := Vector2.ZERO
var _was_orbiting := false

func _process_orbit():
    var orbiting := Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)
    var mouse := get_viewport().get_mouse_position()

    if orbiting and _was_orbiting:
        var delta := mouse - _orbit_last_mouse
        var center := pan_center.global_position
        var t := pan_camera.global_transform

        # One rotation, built from the camera's own axes
        var rot := Basis.IDENTITY
        rot = rot.rotated(t.basis.y, -delta.x * orbit_sensitivity)  # yaw about camera up
        rot = rot.rotated(t.basis.x, -delta.y * orbit_sensitivity)  # pitch about camera right

        # Apply it to the orientation and to the offset from the center
        t.basis = (rot * t.basis).orthonormalized()
        t.origin = center + rot * (t.origin - center)
        pan_camera.global_transform = t

    _orbit_last_mouse = mouse
    _was_orbiting = orbiting
    
func _process(_delta: float) -> void:
    _process_painting()
    _process_orbit()

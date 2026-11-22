extends ColorRect

@export var brush_material: ShaderMaterial
@export var brush_subviewport: SubViewport
@export var uv_subviewport: SubViewport
@export var screen_material: ShaderMaterial

func _ready():
    assert(brush_material)
    brush_material.set_shader_parameter("uv_texture", uv_subviewport.get_texture())
    screen_material.set_shader_parameter("screen_render", brush_subviewport.get_texture())
    brush_material.set_shader_parameter("out_size", Vector2(brush_subviewport.size))

func _process(_delta: float) -> void:
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

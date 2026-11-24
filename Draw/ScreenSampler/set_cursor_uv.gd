extends Node

@export var unwrap_material: ShaderMaterial

func _process(_delta: float):
    unwrap_material.set_shader_parameter("cursor_uv", _get_cursor_uv())
    
func _get_cursor_uv() -> Vector2:
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var viewport_size: Vector2 = get_viewport().get_visible_rect().size
    var cursor_uv: Vector2 = mouse_pos / viewport_size
    return cursor_uv
 

extends SubViewport

@export var resolution_scale: float = 1.0
@export var unwrap_material: ShaderMaterial

func _process(_delta: float):
    var win := get_tree().root.get_visible_rect().size
    var s := Vector2i(win * resolution_scale)
    if s != size:
        size = s

func _ready():
    transparent_bg = true
    use_hdr_2d = true
    msaa_3d = Viewport.MSAA_DISABLED
    unwrap_material.set_shader_parameter("depth_texture", get_texture())

extends SubViewport
@export var paint_viewport: SubViewport
@export var stamp_rect: TextureRect

func _ready():
    transparent_bg = true
    disable_3d = true
    render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
    render_target_update_mode = SubViewport.UPDATE_ONCE
    paint_viewport.size = size
    stamp_rect.texture = paint_viewport.get_texture()
    stamp_rect.size = Vector2(size)

var _painting: bool

func start_painting():
    if not _painting:
        paint_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
        render_target_update_mode = SubViewport.UPDATE_ALWAYS
        _painting = true

func stop_painting():
    if _painting:
        paint_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
        render_target_update_mode = SubViewport.UPDATE_DISABLED
        _painting = false

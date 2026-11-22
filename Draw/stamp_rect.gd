extends TextureRect

func _ready():
    stamp_rect.texture = paint_viewport.get_texture()

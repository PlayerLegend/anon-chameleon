extends SubViewport

@export var resolution_scale: float = 2.0

func _process(_delta: float):
    var win := get_tree().root.get_visible_rect().size
    var s := Vector2i(win * resolution_scale)
    if s != size:
        size = s

func _ready():
    transparent_bg = true
    use_hdr_2d = true
    msaa_3d = Viewport.MSAA_DISABLED

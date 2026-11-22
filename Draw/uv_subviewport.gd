extends SubViewport

func _process(_delta: float):
    size = get_viewport().get_visible_rect().size

func _ready():
    transparent_bg = true
    use_hdr_2d = true

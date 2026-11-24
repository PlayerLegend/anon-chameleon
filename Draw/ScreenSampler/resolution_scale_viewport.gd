class_name ResolutionScaleViewport
extends SubViewport

@export var resolution_scale: float = 1.0

func _process(_delta: float):
    var win := get_tree().root.get_visible_rect().size
    var s := Vector2i(win * resolution_scale)
    if s != size:
        size = s

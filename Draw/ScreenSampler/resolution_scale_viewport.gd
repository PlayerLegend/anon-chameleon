class_name ResolutionScaleViewport
extends SubViewport

@export var resolution_scale: float = 1.0

func _process(_delta: float):
    var new_size := Vector2i(get_window().size * resolution_scale)
    if new_size != size:
        size = new_size

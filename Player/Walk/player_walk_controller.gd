extends Node3D

@export var visual_model: Node3D:
    set(value):
        visual_model = value
        _deferred_set_visual_model.call_deferred(value)
        
func _deferred_set_visual_model(target: Node3D):
    pass

class_name SyncCamera
extends Camera3D

@export var copy: Camera3D:
    set(value):
        copy = value
        process_priority = copy.process_priority + 1

func _process(_delta: float):
    if copy:
        global_transform = copy.global_transform
        fov = copy.fov
        near = copy.near
        far = copy.far

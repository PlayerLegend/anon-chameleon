extends Camera3D

@export var copy: Camera3D

func _process(_delta: float):
    global_transform = copy.global_transform
    fov = copy.fov
    near = copy.near
    far = copy.far

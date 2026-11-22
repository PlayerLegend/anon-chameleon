extends Camera3D

@export var copy: Camera3D
@export_flags_3d_render var uv_pass

func _ready():
    cull_mask = uv_pass

func _process(_delta: float):
    global_transform = copy.global_transform
    fov = copy.fov
    near = copy.near
    far = copy.far

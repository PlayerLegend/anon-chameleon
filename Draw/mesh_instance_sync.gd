class_name MeshInstanceSync
extends MeshInstance3D

@export var copy: MeshInstance3D:
    set(value):
        copy = value
        mesh = copy.mesh
        skin = copy.skin
        skeleton = get_path_to(copy.get_node(copy.skeleton))

func _process(_delta: float) -> void:
    if copy:
        global_transform = copy.global_transform

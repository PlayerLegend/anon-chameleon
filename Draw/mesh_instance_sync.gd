class_name MeshInstanceSync
extends MeshInstance3D

@export var copy: MeshInstance3D:
    set(value):
        assert(!copy)
        assert(value)
        copy = value
        mesh = copy.mesh
        skin = copy.skin
        skeleton = get_path_to(copy.get_node(copy.skeleton))
        value.tree_exited.connect(_on_copy_tree_exited)
        process_priority = copy.process_priority + 1

func _on_copy_tree_exited():
    queue_free()

func _process(_delta: float) -> void:
    if copy:
        global_transform = copy.global_transform
    else:
        push_warning("Sync mesh has no copy target")
        queue_free()

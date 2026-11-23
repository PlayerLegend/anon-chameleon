class_name PlayerWalkController
extends Node3D

@onready var animation_tree: PlayerWalkControllerAnimTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _deferred_set_visual_model(node: Node3D, old: Node3D):
    if old:
        old.queue_free()
    add_child(node)
    animation_tree.set_view_model(node)
    
@export var visual_model: Node3D:
    set(value):
        if value == visual_model:
            return
        var old = visual_model
        visual_model = value
        _deferred_set_visual_model.call_deferred(value, old)
        
func walk_anim():
    state_machine.travel("walk")

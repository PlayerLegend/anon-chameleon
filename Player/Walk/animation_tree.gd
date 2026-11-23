class_name PlayerWalkControllerAnimTree
extends AnimationTree

func _get_animation_player(node: Node3D) -> AnimationPlayer:
    for child in node.get_children():
        if child is AnimationPlayer:
            return child
        var result = _get_animation_player(child)
        if result is AnimationPlayer:
            return result
    return null

func set_view_model(node: Node3D):
    root_motion_local = true
    root_motion_track = NodePath()
    anim_player = NodePath()
    
    var animation_player := _get_animation_player(node)
    
    if not animation_player:
        push_warning("No AnimationPlayer found in player model")
        return
        
    anim_player = get_path_to(animation_player)
    
    for animation_name in animation_player.get_animation_list():
        var animation: Animation = animation_player.get_animation(animation_name)
        for i in animation.get_track_count():
            var path: NodePath = animation.track_get_path(i)
            if String(path).containsn("root"):
                root_motion_track = path
                
    if not root_motion_track:
        push_warning("No root bone found in player model")
        
    

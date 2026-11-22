extends SubViewport

func _ready():
    transparent_bg = true
    render_target_update_mode = SubViewport.UPDATE_ALWAYS

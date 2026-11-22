extends SubViewport

func _ready():
    transparent_bg = true
    disable_3d = true
    render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
    render_target_update_mode = SubViewport.UPDATE_ONCE

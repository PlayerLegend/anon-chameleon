extends SubViewport

func _ready():
    transparent_bg = true
    disable_3d = true
    render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE  # clears the first frame, then never
    #size = Vector2i(1024, 1024) 

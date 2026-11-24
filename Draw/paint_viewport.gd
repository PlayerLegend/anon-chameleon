extends SubViewport

var painting: bool:
    set(value):
        if painting == value:
            return
            
        painting = value
            
        if painting:
            render_target_update_mode = SubViewport.UPDATE_ALWAYS
        else:
            render_target_update_mode = SubViewport.UPDATE_DISABLED
         
func _ready():
    transparent_bg = true
